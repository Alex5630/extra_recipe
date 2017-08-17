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
	
	@IBOutlet weak var daemons: UISwitch!
	@IBOutlet weak var command: UISwitch!
	
	@IBAction func jailbreakAction(_ sender: Any) {
		NSLog("Daemons will " + (daemons.isOn ? "be loaded." : "not be loaded."))
		NSLog("Custom command will " + (command.isOn ? "be run: \"" + UserDefaults.standard.string(forKey: "commandValue")! + "\"" : "not be run."))
		NSLog("Starting jailbreak...")
		tryToJailbreakUntilSuccess()
	}
	
	@IBAction func daemonsAction(_ sender: Any) {
		let defaults = UserDefaults.standard
		defaults.set(daemons.isOn, forKey: "loadDaemons")
		defaults.synchronize()
	}
	
	@IBAction func commandAction(_ sender: Any) {
		let defaults = UserDefaults.standard
		defaults.set(command.isOn, forKey: "commandIsOn")
		defaults.synchronize()
		if command.isOn {
			let alert = UIAlertController(title: "Set Custom Command", message: "Set a command to be run with root privileges upon successful jailbreak.", preferredStyle: .alert)
			alert.addTextField { (textField) in
				let defaults = UserDefaults.standard
				textField.text = defaults.string(forKey: "commandValue")
				textField.placeholder = "Your Custom Command"
			}
			alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
				let commandValue = alert?.textFields![0].text
				let defaults = UserDefaults.standard
				defaults.set(commandValue, forKey: "commandValue")
				if commandValue == "" {
					self.command.setOn(false, animated: true)
					defaults.set(self.command.isOn, forKey: "commandIsOn")
				}
				defaults.synchronize()
			}))
			alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak alert] (_) in
				self.command.setOn(false, animated: true)
				let defaults = UserDefaults.standard
				defaults.set(self.command.isOn, forKey: "commandIsOn")
				defaults.synchronize()
			}))
			present(alert, animated: true, completion: nil)
		}
	}
	
	func tryToJailbreakUntilSuccess() {
		switch jb_go() {
			case 123456789:
				UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
			case 987654321:
				UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
					exit(0)
				}
			default:
				attemptsCount += 1
				NSLog("Jailbreak failed. Starting attempt #" + String(attemptsCount) + "...")
				tryToJailbreakUntilSuccess()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if UserDefaults.standard.string(forKey: "commandValue") == "" {
			let defaults = UserDefaults.standard
			defaults.set(false, forKey: "commandIsOn")
			defaults.synchronize()
		}
		command.isOn = UserDefaults.standard.bool(forKey: "commandIsOn")
		daemons.isOn = UserDefaults.standard.bool(forKey: "loadDaemons")
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}
