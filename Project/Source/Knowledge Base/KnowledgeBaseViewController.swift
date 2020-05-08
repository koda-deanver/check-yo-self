//
//  KnowledgeBaseViewController.swift
//  check-yo-self
//
//  Created by phil on 1/5/17.
//  Copyright © 2016 ThematicsLLC. All rights reserved.
//

import WebKit

/// Displays WebView with related CollabRJabbR info.
final class KnowledgeBaseViewController: SkinnedViewController {
    
    // MARK: - Private Members -
    
    private let knowledgeBaseURLString = "https://www.collab101.com"
    
    // MARK: - Outlets -
    
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupWebview()
    }
    
    // MARK: - Private Methods -
    
    ///
    /// Load knowledge base into webview using URL specified in database.
    ///
    private func setupWebview() {
        
        guard let knowledgeBaseURL = URL(string: knowledgeBaseURLString) else {
            showAlert(BSGCustomAlert(message: "Could not load Knowledge Base"))
            return
        }
        
        webView.alpha = 0.0
        webView.navigationDelegate = self
        showProgressHUD()
        
        let request = URLRequest(url: knowledgeBaseURL)
        webView.load(request)
    }
}

// MARK: - Extension: WKNavigationDelegate -

extension KnowledgeBaseViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.alpha = 1.0
        hideProgressHUD()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        handle(error.localizedDescription)
    }
}

// MARK: - Actions -

extension KnowledgeBaseViewController {
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
