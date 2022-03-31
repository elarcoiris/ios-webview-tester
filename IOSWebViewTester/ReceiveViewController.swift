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
class ReceiveViewController: UIViewController, WKNavigationDelegate, URLSessionDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    var urlString: String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        

        guard let url = URL(string: urlString!) else {return}
        let request = URLRequest(url: url)
        webView.navigationDelegate = self
        webView.load(request)
    }
    
    func loadWebRequest(path: String, completion: @escaping (Result<[Data]>) -> Void) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: URLSessionPinningDelegate(), delegateQueue: OperationQueue.main)
        
        guard let url = URL (string: urlString ?? "https://www.thisworldthesedays.com/example-page.html") else {return}
        
        let task = session.dataTask(with: url) { responseBody, response, error in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(.Error(error!))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                if (200...299).contains(httpResponse.statusCode) {
                    guard let data = responseBody else {
                        print("no data")
                        return
                    }
                    OperationQueue.main.addOperation {
                        completion(.Success(data))
                    }
                }
            }
        }
        task.resume()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("did finish navigation")
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start load")
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

        let bundleCertData = SecCertificateCopyData(bundleCert as! SecCertificate) as NSData
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
