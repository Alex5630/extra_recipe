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
	
	@IBAction func jailbreakAction(_ sender: Any) {
		NSLog("Substrate will " + (substrate.isOn ? "be enabled." : "not be enabled."))
		NSLog("Starting jailbreak...")
		tryToJailbreakUntilSuccess()
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
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}
