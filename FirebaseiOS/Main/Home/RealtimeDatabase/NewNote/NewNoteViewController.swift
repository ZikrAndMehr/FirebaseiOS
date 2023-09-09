//
//  NewNoteViewController.swift
//  FirebaseiOS
//
//  Created by Zokirjon Mamadjonov on 27/06/2023.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseAnalytics

class NewNoteViewController: UIViewController {
    
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var descriptionTextField: UITextField!
    
    private var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        titleTextField.delegate = self
        descriptionTextField.delegate = self
    }
    
    @IBAction private func saveButtonClicked(_ sender: UIButton) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userRef = ref.child(RDConstants.NODE_USERS).child(uid)
        
        guard let title = titleTextField.text, !title.isEmpty else { return }
        guard let description = descriptionTextField.text, !description.isEmpty else { return }
        
        userRef.observeSingleEvent(of: .value) { snapshot in
            guard let userData = snapshot.value as? [String: Any] else { return }
            guard let username = userData[RDConstants.KEY_USERNAME] as? String  else { return }
            self.writeNewNote(uid: uid, username: username, title: title, description: description)
        }
        logAnalytics(name: AnalyticsConstants.SAVE_NEW_NOTE_BUTTON_CLICKED, parameters: nil)
    }
    
    private func writeNewNote(uid: String, username: String, title: String, description: String) {
        let userNotesRef = ref.child(RDConstants.NODE_USER_NOTES).child(uid)
        let newNoteRef = userNotesRef.childByAutoId()
        
        let newNote: [String: Any] = [
            RDConstants.KEY_UID: uid,
            RDConstants.KEY_USERNAME: username,
            RDConstants.KEY_TITLE: title,
            RDConstants.KEY_DESCRIPTION: description
        ]
        
        newNoteRef.setValue(newNote) { error, ref in
            if error == nil {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func logAnalytics(name: String, parameters: [String : Any]?) {
        Analytics.logEvent(name, parameters: parameters)
    }
}

extension NewNoteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
