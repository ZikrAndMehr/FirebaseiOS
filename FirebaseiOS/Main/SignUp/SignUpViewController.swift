//
//  SignUpViewController.swift
//  FirebaseiOS
//
//  Created by Zokirjon Mamadjonov on 20/06/2023.
//

import UIKit
import FirebaseAuth
import FirebaseAnalytics

class SignUpViewController: UIViewController {

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction private func signUpButtonClicked(_ sender: UIButton) {
        showActivityIndicator(show: true)
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                self.showSignUpErrorAlert()
            } else {
                self.sendVerificationEmail()
                self.navigateToHomeVC()
            }
            self.showActivityIndicator(show: false)
        }
        logAnalytics(name: AnalyticsConstants.SIGN_UP_WITH_EMAIL_BUTTON_CLICKED, parameters: nil)
    }
    
    private func showActivityIndicator(show: Bool) {
        activityIndicatorView.isHidden = !show
    }
    
    private func showSignUpErrorAlert() {
        let errorMessage = NSLocalizedString("sign_up_error", comment: "")
        let ok = NSLocalizedString("ok", comment: "")

        let alertController = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)

        let okAction = UIAlertAction(title: ok, style: .default, handler: nil)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
    
    private func sendVerificationEmail() {
        Auth.auth().currentUser?.sendEmailVerification { error in
          //handle error if necessary
        }
    }
    
    private func navigateToHomeVC() {
        let viewController = HomeViewController(nibName: "HomeViewController", bundle: nil)
        self.navigationController?.setViewControllers([viewController], animated: true)
    }
    
    private func logAnalytics(name: String, parameters: [String : Any]?) {
        Analytics.logEvent(name, parameters: parameters)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
