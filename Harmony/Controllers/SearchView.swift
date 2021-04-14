//
//  SearchView.swift
//  Harmony
//
//  Created by Wiktor Wójcik on 14/01/2021.
//

import Cocoa

class SearchView: NSViewController {
    @IBOutlet var searchEngine: NSComboBox!
    
    @IBAction func changeSearchEngine(_ sender: NSComboBox) {
        
        var url: String = ""
        
        if (searchEngine.stringValue == "Google") {
            url = "https://www.google.com/search?q="
        } else if (searchEngine.stringValue == "Alles Search") {
            url = "https://search.alles.cx/"
        } else if (searchEngine.stringValue == "DuckDuckGo") {
            url = "https://duckduckgo.com/?q="
        } else if (searchEngine.stringValue == "Bing") {
            url = "https://www.bing.com/search?q="
        }

        UserDefaults.standard.set(url, forKey: "SearchEngine")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchEngineSaved: String = UserDefaults.standard.string(forKey: "SearchEngine") ?? "Google"
        var text: String = ""
        
        if (searchEngineSaved == "https://www.google.com/search?q=") {
            text = "Google"
        } else if (searchEngineSaved == "https://search.alles.cx/") {
            text = "Alles Search"
        } else if (searchEngineSaved == "https://duckduckgo.com/?q=") {
            text = "DuckDuckGo"
        } else if (searchEngineSaved == "https://www.bing.com/search?q=") {
            text = "Bing"
        }
        
        searchEngine.stringValue = text
    }
    
}
