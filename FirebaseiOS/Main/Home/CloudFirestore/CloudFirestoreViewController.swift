//
//  CloudFirestoreViewController.swift
//  FirebaseiOS
//
//  Created by Zokirjon Mamadjonov on 28/06/2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAnalytics

class CloudFirestoreViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var quoteTextLabel: UILabel!
    @IBOutlet private weak var quoteAuthorLabel: UILabel!
    @IBOutlet private weak var quoteTextField: UITextField!
    @IBOutlet private weak var authorTextField: UITextField!
    
    private var quoteRef: DocumentReference!
    private var quoteListener: ListenerRegistration!

    override func viewDidLoad() {
        super.viewDidLoad()
        quoteRef = Firestore.firestore()
            .collection(CFConstants.COLLECTION_GLOBAL)
            .document(CFConstants.DOCUMENT_QUOTE)
        quoteTextField.delegate = self
        authorTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addQuoteListener()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeQuoteListener()
    }
    
    private func addQuoteListener() {
        quoteListener = quoteRef.addSnapshotListener { docSnapshot, error in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
            guard let quoteData = docSnapshot.data() else { return }
            
            self.quoteTextLabel.text = quoteData[CFConstants.KEY_QUOTE_TEXT] as? String
            self.quoteAuthorLabel.text = quoteData[CFConstants.KEY_QUOTE_AUTHOR] as? String
        }
    }
    
    private func removeQuoteListener() {
        quoteListener.remove()
    }
    
    @IBAction private func updateButtonClicked(_ sender: UIButton) {
        guard let quote = quoteTextField.text, !quote.isEmpty else { return }
        guard let author = authorTextField.text, !author.isEmpty else { return }
        
        let quoteData = [
            CFConstants.KEY_QUOTE_TEXT: quote,
            CFConstants.KEY_QUOTE_AUTHOR: author
        ]
        
        quoteRef.setData(quoteData) { error in
                if error != nil {
                    self.showUpdateQuoteErrorAlert()
                }
            }
        logAnalytics(name: AnalyticsConstants.UPDATE_QUOTE_BUTTON_CLICKED, parameters: nil)
    }
    
    private func showUpdateQuoteErrorAlert() {
        let errorMessage = NSLocalizedString("update_quote_error", comment: "")
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

extension CloudFirestoreViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
