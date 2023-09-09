//
//  AuthenticationViewController.swift
//  FirebaseiOS
//
//  Created by Zokirjon Mamadjonov on 23/06/2023.
//

import UIKit
import FirebaseAuth
import FirebaseAnalytics

class AuthenticationViewController: UIViewController {
    
    @IBOutlet private weak var uidLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var anonymousLabel: UILabel!
    @IBOutlet private weak var emailVerifiedLabel: UILabel!
    
    private var handle: AuthStateDidChangeListenerHandle!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            self.uidLabel.text = user?.uid
            self.emailLabel.text = user?.email
            self.anonymousLabel.text = user?.isAnonymous ?? false ? "YES" : "NO"
            self.emailVerifiedLabel.text = user?.isEmailVerified ?? false ? "YES" : "NO"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    @IBAction private func signOutButtonClicked(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigateToLandingPageVC()
        } catch {
            showSignOutOrDeleteAccountErrorAlert()
        }
        logAnalytics(name: AnalyticsConstants.SIGN_OUT_BUTTON_CLICKED, parameters: nil)
    }
    
    @IBAction private func deleteAccountButtonClicked(_ sender: UIButton) {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if error != nil {
                self.showSignOutOrDeleteAccountErrorAlert()
            } else {
                self.navigateToLandingPageVC()
            }
        }
        logAnalytics(name: AnalyticsConstants.DELETE_ACCOUNT_BUTTON_CLICKED, parameters: nil)
    }
    
    private func navigateToLandingPageVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController else { return }
        self.navigationController?.setViewControllers([viewController], animated: true)
    }
    
    private func showSignOutOrDeleteAccountErrorAlert() {
        let errorMessage = NSLocalizedString("sign_out_error", comment: "")
        let ok = NSLocalizedString("ok", comment: "")

        let alertController = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)

        let okAction = UIAlertAction(title: ok, style: .default, handler: nil)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
    
    private func logAnalytics(name: String, parameters: [String : Any]?) {
        Analytics.logEvent(name, parameters: parameters)
    }
}
