//
//  ViewController.swift
//  WebKitExample
//
//  Created by MilanPanchal on 12/09/17.
//  Copyright © 2017 JeenalInfotech. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView! {
        
        didSet {
            progressView.progress = 0
        }
    }
    
    var webView : WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init and load request in webview.
        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: "https://jeenalinfotech.com")!))
        //        webView.allowsBackForwardNavigationGestures = true
        //        webView.sizeToFit()
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.view.insertSubview(webView, belowSubview: progressView)
        self.view.sendSubview(toBack: webView)
        
        self.title = "WebKitExample"
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // Updates the progress view as the value of estimatedProgress changes & hides it when loading completes.
        print("Progress :\(webView.estimatedProgress)")
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        
        progressView.setProgress(0.0, animated: false)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        progressView.setProgress(0.0, animated: false)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == WKNavigationType.linkActivated /* && !navigationAction.request.url!.host!.lowercased().hasPrefix("www.google.com")) */{
            
            print("User click on the link.")
            
            // Redirected to browser. No need to open it locally
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(navigationAction.request.url!, options: [:])
            } else {
                UIApplication.shared.openURL(navigationAction.request.url!)
            }
            
            decisionHandler(WKNavigationActionPolicy.cancel)
        } else {
            decisionHandler(WKNavigationActionPolicy.allow)
        }
        
    }
    
}

