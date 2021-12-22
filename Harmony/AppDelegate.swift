//
//  AppDelegate.swift
//  Harmony
//
//  Created by Wiktor Wójcik on 03/11/2020.
//

import Cocoa

extension Notification.Name {
    static let isAskedToOpen = Notification.Name("isAskedToOpen")
}

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    
    @IBAction func checkForNewVersion(_ sender: NSMenuItem) {
        let installedVersion = 6
        
        if let url = URL(string: "https://wiktor.thedev.id/HarmonyVersion.txt") {
            do {
                let currentVersionString = try String(contentsOf: url)
                
				let scanInteger = Scanner(string: currentVersionString)
                let currentVersion = scanInteger.scanInt()
                
                if (currentVersion! > installedVersion) {
                    let newVersion = NSAlert()
                    newVersion.messageText = "New version of Harmony (" + String(currentVersion!) + ") is now available. Your current version is " + String(installedVersion) + "."
                    newVersion.addButton(withTitle: "Update")
                    newVersion.addButton(withTitle: "Cancel")
                    if (newVersion.runModal() == .alertFirstButtonReturn) {
                        NSWorkspace.shared.open(URL(string: "https://github.com/wiktorwojcik112/HarmonyBrowser/releases/download/latest/Harmony.app.zip")!)
                    }
                } else {
                    let noNewVersion = NSAlert()
                    noNewVersion.messageText = "Harmony is up to date."
                    noNewVersion.runModal()
                }

            } catch {
                let couldntAccesWebsite = NSAlert()
                couldntAccesWebsite.messageText = "App couldn't acces updates website. Check your network connection and try again. If error still persists, contact the developer."
                couldntAccesWebsite.addButton(withTitle: "Try again")
                couldntAccesWebsite.addButton(withTitle: "Cancel")
                if (couldntAccesWebsite.runModal() == .alertFirstButtonReturn) {
                    checkForNewVersion(NSMenuItem())
                }
                
            }
        } else {
            let couldntAccesWebsite = NSAlert()
            couldntAccesWebsite.messageText = "Updates website's url is wrong. Please, contact the developer."
            couldntAccesWebsite.runModal()
        }
    }
}

