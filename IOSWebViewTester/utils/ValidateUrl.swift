//
//  ValidateUrl.swift
//  IOSWebViewTester
//
//  Created by Prue Phillips on 28/3/2022.
//

import Foundation
import UIKit

func validateUrl (urlString: String?) -> Bool {
    if let urlString = urlString {
        if let url = URL(string: urlString) {
            return UIApplication.shared.canOpenURL(url)
        }
    }
    return false
}
