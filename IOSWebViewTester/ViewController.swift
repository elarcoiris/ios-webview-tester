//
//  ViewController.swift
//  IOSWebViewTester
//
//  Created by Prue Phillips on 26/3/2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var webViewButton: UIButton!
    @IBOutlet weak var textInputBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initWebView()
        initTextInput()
    }
    
    func initWebView () {
        webViewButton.layer.cornerRadius = 10
        webViewButton.layer.shadowColor = UIColor.gray.cgColor
        webViewButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        webViewButton.layer.shadowOpacity = 0.25
        webViewButton.layer.shadowRadius = 0
    }
    
    func initTextInput() {
        textInputBox?.layer.shadowColor = UIColor.gray.cgColor
        textInputBox?.layer.shadowOffset = CGSize(width: 1, height: 2)
        textInputBox?.layer.shadowOpacity = 0.10
        textInputBox?.layer.shadowRadius = 0
    }
    
    @IBAction func textInput(_ sender: UITextField) {
    }
    
    @IBAction func webViewButton(_ sender: UIButton) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webViewSegue" {
            if let vc = segue.destination as? ReceiveViewController {
                if textInputBox.hasText {
                    let urlString = textInputBox.text!
                    guard let url = URL(string: urlString) else { return }
                    vc.url = url
                }
                else {
                    guard let url = URL(string: "https://www.thisworldthesedays.com/example-page.html") else { return }
                    vc.url = url
                }
            }
        }
    }
}

