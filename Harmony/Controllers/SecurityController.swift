//
//  SecurityController.swift
//  Harmony
//
//  Created by Wiktor Wójcik on 19/02/2021.
//

import Cocoa

class SecurityController: NSViewController {

    @IBOutlet var blockJScheckbox: NSButton!
    
    var isBlockingJS = false
    
    @IBAction func blockJS(_ sender: NSButton) {
        if sender.state.rawValue == 1 {
            isBlockingJS = true
            UserDefaults.standard.setValue(isBlockingJS, forKey: "BlockJS")
        } else {
            isBlockingJS = false
            UserDefaults.standard.setValue(isBlockingJS, forKey: "BlockJS")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "BlockJS") == nil {
            UserDefaults.standard.setValue(true, forKey: "BlockJS")
        }
        
        isBlockingJS = UserDefaults.standard.bool(forKey: "BlockJS")
        
        if isBlockingJS {
            blockJScheckbox.state = .on
        } else {
            blockJScheckbox.state = .off
        }
    }
    
}
