//
//  GeneralController.swift
//  Harmony
//
//  Created by Wiktor Wójcik on 23/01/2021.
//

import Cocoa

class GeneralController: NSViewController {
    @IBOutlet var homepageField: NSTextField!
    
    @IBAction func changeHomepage(_ sender: NSButton) {
        let address = homepageField.stringValue
        
        if address != "" && !address.contains(" "){
        let url = URL(string: address)
            
        if let isWorking = try? String(contentsOf: url!) {
            UserDefaults.standard.setValue(url, forKey: "homepage")
        } else {
            let withHTTPS = URL(string: "https://" + url!.absoluteString)
            if let isWorking = try? String(contentsOf: withHTTPS!) {
                UserDefaults.standard.setValue(withHTTPS, forKey: "homepage")
            } else {
                let alert = NSAlert()
                alert.messageText = "Unable to set this page as homepage. Please, check your network connection and if address is correct."
                alert.runModal()
            }
        }
        } else {
            let alert = NSAlert()
            alert.messageText = ""
            alert.runModal()
        }
    }
    
    @IBAction func reset(_ sender: NSButton) {
        //UserDefaults.standard.setValue("https://www.google.com", forKey: "homepage")
        UserDefaults.standard.setValue(Bundle.main.url(forResource: "index", withExtension: "html"), forKey: "homepage")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
