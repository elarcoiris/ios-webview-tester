//
//  ReceiveViewController.swift
//  IOSWebViewTester
//
//  Created by Prue Phillips on 27/3/2022.
//

import Foundation
import UIKit
import WebKit

enum Result <T> {
    case Success(Data)
    case Error(Error)
}
class ReceiveViewController: UIViewController, WKNavigationDelegate, URLSessionDelegate, WKUIDelegate, UISearchControllerDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    var urlString: String?
    
    var webViewObserver: NSKeyValueObservation?

    @IBOutlet weak var navItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.toolbar.isHidden = false

        if let urlString = urlString {
            guard let url = URL(string: urlString) else {return}
            let request = URLRequest(url: url)
            webView.navigationDelegate = self
            webView.allowsBackForwardNavigationGestures = true
            webViewObserver = webView?.observe(\.url, options: .new, changeHandler: {
                (webView, _) in
                guard let url = webView.url else {return}
                print("webViewObserver: ", url)
//                DispatchQueue.main.async {
//                    self.navigationItem.title = url.absoluteString
//                }

            })
            webView.load(request)
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webViewObserver?.invalidate()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.toolbar.isHidden = true
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("decidePolicyFor navigationAction: ")

        if navigationAction.navigationType == .linkActivated {
            guard let url = navigationAction.request.url else {return}
            webView.load(URLRequest(url: url))
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        print("createWebViewWith")
        if navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame == false {
            if let navUrl = navigationAction.request.url {
                print("navigation url: ", navUrl)

            }
            webView.load(navigationAction.request)
        }
        return nil
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("webView didStartProvisionalNavigation")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webView didFinish navigation")
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            
            guard let serverTrust = challenge.protectionSpace.serverTrust else {
                completionHandler(.performDefaultHandling, nil)
                return
            }
            
            var secresult = SecTrustResultType.invalid
            let status = SecTrustEvaluate(serverTrust, &secresult)
                
            if (errSecSuccess == status) {
                    
                if checkValidity(of: serverTrust) {
                    let credential = URLCredential(trust: serverTrust)
                    completionHandler(.useCredential, credential)
                }
                else {
                    completionHandler(.cancelAuthenticationChallenge, nil)
                }
            }
        }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("Webview withError: ", error.localizedDescription)
    }
    
    func checkValidity(of: SecTrust) -> Bool {

        let bundleCert = Certificates.localhost
        let serverCert = SecTrustGetCertificateAtIndex(of, 0)

        let bundleCertData = SecCertificateCopyData(bundleCert ) as NSData
        let serverCertData = SecCertificateCopyData(serverCert!) as NSData

        if !serverCertData.isEqual(to: bundleCertData as Data) {
            return false
        }

        return true
    }
    
    }
}

struct Certificates {

    static let localhost = Certificates.certificate(filename: "localhost")

    private static func certificate(filename: String) -> SecCertificate {

        let filePath = Bundle.main.path(forResource: filename, ofType: "der")
        let data = try! Data(contentsOf: URL(fileURLWithPath: filePath!))
        let certificate = SecCertificateCreateWithData(nil, data as CFData)!

        return certificate
    }
}
