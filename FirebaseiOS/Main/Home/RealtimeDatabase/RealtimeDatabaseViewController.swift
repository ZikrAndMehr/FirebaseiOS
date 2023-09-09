//
//  RealtimeDatabaseViewController.swift
//  FirebaseiOS
//
//  Created by Zokirjon Mamadjonov on 26/06/2023.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseAnalytics

class RealtimeDatabaseViewController: UIViewController {
        
    @IBOutlet private weak var noteTableView: UITableView!

    private var user: User!
    private var ref: DatabaseReference!
    private var notes: [NoteItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = Auth.auth().currentUser
        ref = Database.database().reference()
        checkUserData()
        configureNoteTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserNotes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let userNotesRef = ref.child(RDConstants.NODE_USER_NOTES).child(user.uid)
        userNotesRef.removeAllObservers()
    }
    
    func fetchUserNotes() {
        let userNotesRef = ref.child(RDConstants.NODE_USER_NOTES).child(user.uid)
        
        userNotesRef.observe(DataEventType.value, with: { snapshot in
            guard let notesData = snapshot.value as? [String: [String: Any]] else { return }
            
            var updatedNotes: [NoteItem] = []
            
            for (noteId, noteData) in notesData {
                if let uid = noteData[RDConstants.KEY_UID] as? String,
                   let username = noteData[RDConstants.KEY_USERNAME] as? String,
                   let title = noteData[RDConstants.KEY_TITLE] as? String,
                   let description = noteData[RDConstants.KEY_DESCRIPTION] as? String {
                    let note = NoteItem(noteId: noteId, uid: uid, username: username, title: title, description: description)
                    updatedNotes.append(note)
                }
            }
            
            self.notes = updatedNotes
            self.noteTableView.reloadData()
        })
    }
    
    private func checkUserData() {
        let userUid = user.uid
        
        ref.child(RDConstants.NODE_USERS).child(userUid).observeSingleEvent(of: .value) { snapshot in
            if !snapshot.exists() {
                let userData = [
                    RDConstants.KEY_EMAIL : self.user.email ?? "",
                    RDConstants.KEY_USERNAME : self.usernameFromEmail(self.user.email ?? "")
                ]
                self.ref.child(RDConstants.NODE_USERS).child(userUid).setValue(userData)
            }
        }
    }
    
    private func usernameFromEmail(_ email: String) -> String {
        if email.contains("@") {
            let components = email.components(separatedBy: "@")
            return components.first ?? ""
        } else {
            return email
        }
    }
    
    @IBAction private func addNewNoteButtonClicked(_ sender: UIButton) {
        logAnalytics(name: AnalyticsConstants.ADD_NEW_NOTE_BUTTON_CLICKED, parameters: nil)

        let viewController = NewNoteViewController(nibName: "NewNoteViewController", bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func logAnalytics(name: String, parameters: [String : Any]?) {
        Analytics.logEvent(name, parameters: parameters)
    }
}

extension RealtimeDatabaseViewController: UITableViewDataSource {
    
    private func configureNoteTableView() {
        let nib = UINib(nibName: "NoteTableViewCell", bundle: nil)
        noteTableView.register(nib, forCellReuseIdentifier: NoteTableViewCell.reuseIdentifier)
        
        noteTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier, for: indexPath) as! NoteTableViewCell
        
        let item = notes[indexPath.item]
        
        cell.delegate = self
        cell.bind(item: item)
        
        return cell
    }
}

extension RealtimeDatabaseViewController: NoteCellDelegate {
    
    func onDeleteButtonClicked(noteId: String) {
        let userNotesRef = ref.child(RDConstants.NODE_USER_NOTES).child(user.uid)
        userNotesRef.child(noteId).removeValue { error, ref in
            if error != nil {
                
            }
        }
        logAnalytics(name: AnalyticsConstants.DELETE_NOTE_BUTTON_CLICKED, parameters: [AnalyticsConstants.NOTE_ID_KEY: noteId])
    }
}
