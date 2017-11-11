//********************************************************************
//  KnowledgeBaseViewController.swift
//  Check Yo Self
//  Created by Phil on 1/5/17
//
//  Description: Used to view webpage with related info
//********************************************************************

import UIKit

class KnowledgeBaseViewController: GeneralViewController {

    @IBOutlet weak var webView: UIWebView!
    
    //********************************************************************
    // Action: backButton
    // Description: Dismiss current screen and go back to Cube
    //********************************************************************
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //********************************************************************
    // viewDidLoad
    // Description: Load webpage into webView
    //********************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        let knowledgeURL = URL(string: "https://www.collab101.com/terms")
        let webRequest = URLRequest(url: knowledgeURL!)
        self.webView.loadRequest(webRequest)
        // Do any additional setup after loading the view.
    }
}
