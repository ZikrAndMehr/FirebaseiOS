//
//  ViewController.swift
//  FirebaseiOS
//
//  Created by Zokirjon Mamadjonov on 20/06/2023.
//

import UIKit
import FirebaseAnalytics

class ViewController: UIViewController {
    
    @IBAction private func signInButtonClicked(_ sender: UIButton) {
        logAnalytics(name: AnalyticsConstants.SIGN_IN_BUTTON_CLICKED, parameters: nil)
    }
    
    @IBAction private func signUpButtonClicked(_ sender: UIButton) {
        logAnalytics(name: AnalyticsConstants.SIGN_UP_BUTTON_CLICKED, parameters: nil)
    }
    
    private func logAnalytics(name: String, parameters: [String : Any]?) {
        Analytics.logEvent(name, parameters: parameters)
    }
}
