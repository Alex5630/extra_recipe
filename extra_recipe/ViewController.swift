//
//  ViewController.swift
//  extra_recipe
//
//  Created by Ian Beer on 1/23/17.
//  Copyright © 2017 Ian Beer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	var attemptsCount = 1
	
	@IBOutlet weak var substrate: UISwitch!
	@IBOutlet weak var generator: UISwitch!
	
	@IBAction func jailbreakAction(_ sender: Any) {
		NSLog("Substrate will " + (substrate.isOn ? "be enabled." : "not be enabled."))
		NSLog("Nonce generator will " + (generator.isOn ? "be set to " + UserDefaults.standard.string(forKey: "generatorValue")! : "not be set."))
		NSLog("Starting jailbreak...")
		tryToJailbreakUntilSuccess()
	}
	
	@IBAction func generatorAction(_ sender: Any) {
		let defaults = UserDefaults.standard
		defaults.set(generator.isOn, forKey: "generatorIsOn")
		defaults.synchronize()
		if generator.isOn {
			let alert = UIAlertController(title: "Set Nonce Generator", message: "", preferredStyle: .alert)
			alert.addTextField { (textField) in
				let defaults = UserDefaults.standard
				textField.text = defaults.string(forKey: "generatorValue")
				textField.placeholder = "Your Nonce Generator"
			}
			alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
				let generatorValue = alert?.textFields![0].text
				let defaults = UserDefaults.standard
				defaults.set(generatorValue, forKey: "generatorValue")
				if generatorValue == "" {
					self.generator.setOn(false, animated: true)
					defaults.set(self.generator.isOn, forKey: "generatorIsOn")
				}
				defaults.synchronize()
			}))
			alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak alert] (_) in
				self.generator.setOn(false, animated: true)
				let defaults = UserDefaults.standard
				defaults.set(self.generator.isOn, forKey: "generatorIsOn")
				defaults.synchronize()
			}))
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func tryToJailbreakUntilSuccess() {
		let result = jb_go(substrate.isOn)
		if result == 123456789 {
			UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
		} else if result == 987654321 {
			UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
				exit(0)
			}
		} else {
			attemptsCount += 1
			NSLog("Jailbreak failed. Starting attempt #" + String(attemptsCount) + "...")
			tryToJailbreakUntilSuccess()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		generator.isOn = UserDefaults.standard.bool(forKey: "generatorIsOn")
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}
