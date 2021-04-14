//
//  WindowController.swift
//  Harmony
//
//  Created by Wiktor Wójcik on 03/11/2020.
//

import Cocoa

class WindowController: NSWindowController {
    
    @IBAction override func newWindowForTab(_ sender: Any?) {
        let newWindowController = self.storyboard!.instantiateInitialController() as! WindowController
        let newWindow = newWindowController.window!
        newWindow.windowController = self
        self.window!.addTabbedWindow(newWindow, ordered: .above)
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
    }

}

