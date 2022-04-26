//
//  ViewController.swift
//  Messages
//
//  Created by Raymond Hsu on April 26, 2022.
//

import Cocoa
import WebKit
import Foundation

typealias Callback = (NSEvent) -> ()

class ViewController: NSViewController, WKUIDelegate {
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration ();
        webConfiguration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs");
        webView = WKWebView (frame: CGRect(x:0, y:0, width:1920, height:1080), configuration:webConfiguration);
        webView.navigationDelegate = self
        self.view = webView;
        self.webView.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: "https://messages.google.com/web/") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // Check for links.
        if navigationAction.targetFrame == nil {
            // Make sure the URL is set.
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }
            // Check for the scheme component.
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            if components?.scheme == "http" || components?.scheme == "https" {
                // Open the link in the external browser.
                NSWorkspace.shared.open(url)
                // Cancel the decisionHandler because we managed the navigationAction.
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
        
    }
}


