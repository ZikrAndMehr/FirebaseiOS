//
//  SignInViewController.swift
//  FirebaseiOS
//
//  Created by Zokirjon Mamadjonov on 20/06/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FirebaseAnalytics

class SignInViewController: UIViewController {

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        emailTextField.text = "new01@new.com"
        passwordTextField.text = "Welcome1."
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction private func signInButtonClicked(_ sender: UIButton) {
        showActivityIndicator(show: true)
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error != nil {
                self.showSignInErrorAlert()
            } else {
                self.navigateToHomeVC()
            }
            self.showActivityIndicator(show: false)
        }
        
        logAnalytics(name: AnalyticsConstants.SIGN_IN_WITH_EMAIL_BUTTON_CLICKED, parameters: nil)
    }
    
    private func showActivityIndicator(show: Bool) {
        activityIndicatorView.isHidden = !show
    }
    
    private func showSignInErrorAlert() {
        let errorMessage = NSLocalizedString("sign_in_error", comment: "")
        let ok = NSLocalizedString("ok", comment: "")

        let alertController = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)

        let okAction = UIAlertAction(title: ok, style: .default, handler: nil)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction private func signInWithGoogleButtonClicked(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            
            guard error == nil else { return }
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            signInToFirebaseWithGoogle(credential: credential)
        }
        logAnalytics(name: AnalyticsConstants.SIGN_IN_WITH_GOOGLE_BUTTON_CLICKED, parameters: nil)
    }
    
    private func signInToFirebaseWithGoogle(credential: AuthCredential) {
        showActivityIndicator(show: true)
        Auth.auth().signIn(with: credential) { result, error in
            if error != nil {
                self.showSignInWithGoogleErrorAlert()
            } else {
                self.navigateToHomeVC()
            }
            self.showActivityIndicator(show: false)
        }
    }
    
    private func showSignInWithGoogleErrorAlert() {
        let errorMessage = NSLocalizedString("sign_in_with_google_error", comment: "")
        let ok = NSLocalizedString("ok", comment: "")

        let alertController = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)

        let okAction = UIAlertAction(title: ok, style: .default, handler: nil)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction private func signInWithAppleButtonClicked(_ sender: Any) {
        // TODO: apple sign in should be implemented (apple developer account needed)
        logAnalytics(name: AnalyticsConstants.SIGN_IN_WITH_APPLE_BUTTON_CLICKED, parameters: nil)
    }
    
    private func navigateToHomeVC() {
        let viewController = HomeViewController(nibName: "HomeViewController", bundle: nil)
        self.navigationController?.setViewControllers([viewController], animated: true)
    }
    
    private func logAnalytics(name: String, parameters: [String : Any]?) {
        Analytics.logEvent(name, parameters: parameters)
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
