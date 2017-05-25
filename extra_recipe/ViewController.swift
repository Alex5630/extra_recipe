//
//  ViewController.swift
//  extra_recipe
//
//  Created by Ian Beer on 1/23/17.
//  Copyright © 2017 Ian Beer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	var attempts = 1;
	
	@IBAction func jb_button(_ sender: Any) {
		NSLog("Starting jailbreak...");
		tryToJailbreakUntilSuccess()
	}
	
	func tryToJailbreakUntilSuccess() {
		let result = jb_go()
		attempts += 1
		if result != 123456789 {
			NSLog("Jailbreak failed. Starting attempt #" + String(attempts) + "...");
			tryToJailbreakUntilSuccess()
		}
	}
	
	@IBOutlet weak var jb_button_label: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
}
