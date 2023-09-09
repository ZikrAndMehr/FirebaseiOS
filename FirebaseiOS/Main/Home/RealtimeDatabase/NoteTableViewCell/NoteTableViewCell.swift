//
//  PostTableViewCell.swift
//  FirebaseiOS
//
//  Created by Zokirjon Mamadjonov on 26/06/2023.
//

import UIKit

protocol NoteCellDelegate: AnyObject {
    func onDeleteButtonClicked(noteId: String)
}

struct NoteItem {
    let noteId: String
    let uid: String
    let username: String
    let title: String
    let description: String
}

class NoteTableViewCell: UITableViewCell {

    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    static let reuseIdentifier = "NoteTableViewCell"
    
    private var noteId: String?
    var delegate: NoteCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 16
    }
    
    func bind(item: NoteItem) {
        noteId = item.noteId
        usernameLabel.text = item.username
        titleLabel.text = item.title
        descriptionLabel.text = item.description
    }
    
    @IBAction private func deleteButtonClicked(_ sender: UIButton) {
        guard let noteId = noteId else { return }
        delegate?.onDeleteButtonClicked(noteId: noteId)
    }
}
