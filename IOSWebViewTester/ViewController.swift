//
//  ViewController.swift
//  IOSWebViewTester
//
//  Created by Prue Phillips on 26/3/2022.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var webViewButton: UIButton!
    @IBOutlet weak var textInputBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.toolbar.isHidden = true
        textInputBox.delegate = self
        initWebView()
        initTextInput()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
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
        textInputBox?.layer.shadowOffset = CGSize(width: 1, height: 1)
        textInputBox?.layer.shadowOpacity = 0.25
        textInputBox?.layer.shadowRadius = 0
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func textInput(_ sender: UITextField) {
    }
    
    @IBAction func webViewButton(_ sender: UIButton) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textInputBox {
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webViewSegue" {
            if let vc = segue.destination as? ReceiveViewController {
                if textInputBox.hasText {
                    let urlString = textInputBox.text!
                    let validUrl = validateUrl(urlString: urlString)
                    print("valid url: ", validUrl)
                    if validUrl {
                        vc.urlString = urlString
                    }
                }
            }
        }
    }
}

