//
//  ReceiveViewController.swift
//  IOSWebViewTester
//
//  Created by Prue Phillips on 27/3/2022.
//

import Foundation
import UIKit
import WebKit

class ReceiveViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    var url: URL?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: url!))
    }
}
