//
//  ViewController.swift
//  Harmony
//
//  Created by Wiktor Wójcik on 03/11/2020.
//

import Cocoa
import WebKit

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}

extension Notification.Name {
    static let willChangeBlockJS = Notification.Name("willChangeBlockJS")
}

class BrowserController: NSViewController {

    
    @IBOutlet var addresBarBackground: NSBox!
    @IBOutlet var safetyIcon: NSTextField!
    @IBOutlet var addresBar: NSSearchField!
    @IBOutlet var webView: WKWebView!
    @IBOutlet var goHome: NSButton!
    @IBOutlet var reloadButton: NSButton!
    @IBOutlet var loading: NSProgressIndicator!
    @IBOutlet var goForward: NSButton!
    @IBOutlet var goBack: NSButton!
    @IBOutlet var visualEffect: NSVisualEffectView!
    
    var didExecuteSite = false
    var hide = false
    var isLoading = false
    
    var observeJSBlock = NotificationCenter.default.addObserver(forName: .none, object: nil, queue: nil, using: {_ in})
    
    var startpage = ""
    var homepage = URL(string: "https://google.com")!
    //URL(string: "https://google.com")!
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            loading.isHidden = false
            loading.doubleValue = webView.estimatedProgress * 100
            didExecuteSite = false
            isLoading = true
            reloadButton.image = NSImage(systemSymbolName: "xmark", accessibilityDescription: "")
            self.reloadButton.tag = 1
        }
        
        if keyPath == "doubleValue" {
            if (loading.doubleValue == 100.0 && !didExecuteSite) {
                isLoading = false
                loading.isHidden = true
                loading.doubleValue = 0.0
                if (webView.hasOnlySecureContent) {
                    safetyIcon.stringValue = "􀎡"
                    safetyIcon.textColor = .systemGreen
                } else {
                    safetyIcon.stringValue = "􀎥"
                    safetyIcon.textColor = .systemRed
                }
                
                self.view.window?.title = webView.title!
                
                if (webView.url!.absoluteString == "https://www.google.com/" || webView.url!.absoluteString == "https://www.google.com/webhp" || webView.url!.absoluteString == "https://search.alles.cx/" || webView.url!.absoluteString == "https://search.alles.cx/?auth" || webView.url!.absoluteString.contains("/Resources/index.html")) {
                    addresBar.stringValue = ""
                } else if (webView.url!.absoluteString.hasPrefix("https://www.google.com/search?q=") || webView.url!.absoluteString.hasPrefix("https://search.alles.cx/")) {
                    var text = webView.url?.absoluteString
                    text = text?.replacingOccurrences(of: "https://www.google.com/search?q=", with: "")
                    text = text?.replacingOccurrences(of: "https://search.alles.cx/", with: "")
                    text = text?.replacingOccurrences(of: "+", with: " ")
                    addresBar.stringValue = text!
                } else {
                    addresBar.stringValue = webView.url!.absoluteString
                }
                
                if (webView.canGoBack) {
                    goBack.isEnabled = true
                } else {
                    goBack.isEnabled = false
                }
                
                if (webView.canGoForward) {
                    goForward.isEnabled = true
                } else {
                    goForward.isEnabled = false
                }
                DispatchQueue.main.async {
                    self.reloadButton.image = NSImage(systemSymbolName: "arrow.clockwise", accessibilityDescription: "")
                    self.reloadButton.tag = 0
                }
                didExecuteSite = true
            }
        }
    }
    
    @IBAction func hideBar(_ sender: NSButton) {
        if (hide) {
            hide = false
        } else {
            hide = true
        }
        
        addresBar.isHidden = hide
        goHome.isHidden = hide
        goForward.isHidden = hide
        visualEffect.isHidden = hide
        loading.isHidden = hide
        reloadButton.isHidden = hide
        goBack.isHidden = hide
    }
    
    @IBAction func home(_ sender: NSButton) {
        let url = homepage
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
    
    @IBAction func search(_ sender: NSSearchFieldCell) {

        let url = addresBar.stringValue
        
        if (url.isValidURL) {
            var url:URL
            if (addresBar.stringValue.contains("https://") || addresBar.stringValue.contains("http://")) {
                url = URL(string: addresBar.stringValue)!
            } else {
                url = URL(string: "https://" + addresBar.stringValue)!
            }
            let urlRequest = URLRequest(url: url)
            
            let testConnection = try? String(contentsOf: url)
            
            if (testConnection != nil) {
            webView.load(urlRequest)
            } else {
                webView.loadHTMLString("""
<!DOCTYPE html>
    <html>
        <head>
           <meta http-equiv="content-type" content="text/html; charset=utf-8" />
       </head>
        <body>
            <H1>Harmony is not able to open this website. Please, check your network connection and if this website exists.</H1>
        </body>
    </html>
""", baseURL: nil)
            }

        } else {
            let query = addresBar.stringValue
            var url = startpage + query
            url = url.replacingOccurrences(of: " ", with: "+")
            let urlCon = URL(string: url)
            let urlRequest = URLRequest(url: urlCon!)
            
            let testConnection = try? String(contentsOf: urlCon!)
            
            if (testConnection != nil) {
                
            webView.load(urlRequest)
            } else {
            webView.loadHTMLString("""
<!DOCTYPE html>
    <html>
        <head>
            <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        </head>
        <body>
            <H1>Harmony is not able to open this website. Please, check your network connection and if this website exists.</H1>
        </body>
    </html>
""", baseURL: nil)
            }
        }
        
        addresBar.resignFirstResponder()
    }
    
    @IBAction func addresBar(_ sender: NSButton) {
        addresBar.becomeFirstResponder()
    }
    
    @IBAction func printWebsite(_ sender: NSMenuItem) {
        webView.printView(self)
    }
    
    @IBAction func saveWebsite(_ sender: NSButton) {

    }
    
    @IBAction func reloadWebsite(_ sender: NSButton) {
        if sender.tag == 1 {
            webView.stopLoading()
        } else {
            webView.reload()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UserDefaults.standard.bool(forKey: "firstTime") {
            UserDefaults.standard.set(true, forKey: "firstTime")
            UserDefaults.standard.set("https://www.google.com/search?q=", forKey: "SearchEngine")
            UserDefaults.standard.set(URL(string: "https://www.google.com/search?q="), forKey: "homepage")
        }
        
        homepage = UserDefaults.standard.url(forKey: "homepage") ?? URL(string: UserDefaults.standard.string(forKey: "SearchEngine") ?? "https://www.google.com/search?q=")!
        startpage = UserDefaults.standard.string(forKey: "SearchEngine") ?? "https://www.google.com/search?q="
        
        observeJSBlock = NotificationCenter.default.addObserver(forName: .willChangeBlockJS, object: nil, queue: nil) { _ in
            
        }
        
        addresBarBackground.wantsLayer = true
        addresBarBackground.layer?.opacity = 0.6
        addresBarBackground.layer?.masksToBounds = true
        
        if let cell = self.addresBar.cell as? NSSearchFieldCell {
            cell.searchButtonCell?.isTransparent = true
        }
        
            visualEffect.wantsLayer = true
            visualEffect.layer?.cornerRadius = 10.0
            visualEffect.layer?.masksToBounds = true
        
            let url = homepage
            let urlRequest = URLRequest(url: (url))
            webView.load(urlRequest)
        
            webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
            loading.addObserver(self, forKeyPath: #keyPath(NSProgressIndicator.doubleValue), options: .new, context: nil)
        
            
    }
    
        deinit {
            webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
            loading.removeObserver(self, forKeyPath: #keyPath(NSProgressIndicator.doubleValue))
            NotificationCenter.default.removeObserver(observeJSBlock)
        }

    }






