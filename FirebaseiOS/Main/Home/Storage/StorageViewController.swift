//
//  StorageViewController.swift
//  FirebaseiOS
//
//  Created by Zokirjon Mamadjonov on 28/06/2023.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseAnalytics

class StorageViewController: UIViewController {

    @IBOutlet private weak var favoriteImageView: UIImageView!
    @IBOutlet private weak var uploadProgressView: UIProgressView!
    @IBOutlet private weak var urlStackView: UIStackView!
    @IBOutlet private weak var urlTextField: UITextField!
    
    private var ref: StorageReference!
    private var userUid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Storage.storage().reference()
        userUid = Auth.auth().currentUser?.uid
        
        uploadProgressView.isHidden = true
        urlStackView.isHidden = true
        fetchFavoriteImage()
    }
    
    private func fetchFavoriteImage() {
        guard let imageRef = getFavoriteImageRef() else { return }
        
        imageRef.getData(maxSize: SConstants.FILE_MAX_SIZE) { data, error in
            if let data = data {
                self.favoriteImageView.image = UIImage(data: data)
                self.setFavoriteImageUrl()
            }
        }
    }
    
    private func getFavoriteImageRef() -> StorageReference? {
        guard let uid = userUid else { return nil }
        let path = String(format: SConstants.FILE_PATH_FAVORITE_IMAGE, uid)
        
        return ref.child(path)
    }
    
    private func setFavoriteImageUrl() {
        guard let imageRef = getFavoriteImageRef() else { return }
        
        imageRef.downloadURL { url, error in
            self.urlStackView.isHidden = false
            self.urlTextField.text = url?.absoluteString
        }
    }
    
    @IBAction private func selectImageButtonClicked(_ sender: UIButton) {
        selectImage()
        logAnalytics(name: AnalyticsConstants.SELECT_IMAGE_BUTTON_CLICKED, parameters: nil)
    }
    
    @IBAction private func copyImageUrlButtonClicked(_ sender: UIButton) {
        UIPasteboard.general.string = urlTextField.text
        logAnalytics(name: AnalyticsConstants.COPY_IMAGE_URL_BUTTON_CLICKED, parameters: nil)
    }
    
    @IBAction private func uploadButtonClicked(_ sender: UIButton) {
        guard let imageRef = getFavoriteImageRef() else { return }
        guard let imageData = favoriteImageView.image?.jpegData(compressionQuality: SConstants.COMPRESSION_QUALITY) else { return }
        
        uploadProgressView.isHidden = false
        let uploadRef = imageRef.putData(imageData) { storageMetadata, error in
            if error != nil {
                self.showUploadFavoriteImageErrorAlert()
            } else {
                self.setFavoriteImageUrl()
            }
            self.uploadProgressView.isHidden = true
        }
        
        uploadRef.observe(.progress) { snapshot in
            guard let uploadProgress = snapshot.progress?.fractionCompleted else { return }
            self.uploadProgressView.progress = Float(uploadProgress)
        }
        logAnalytics(name: AnalyticsConstants.UPLOAD_IMAGE_BUTTON_CLICKED, parameters: nil)
    }
    
    private func showUploadFavoriteImageErrorAlert() {
        let errorMessage = NSLocalizedString("upload_favorite_image_error", comment: "")
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

extension StorageViewController: UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        dismiss(animated: true)

        favoriteImageView.image = image
        uploadProgressView.isHidden = true
        urlStackView.isHidden = true
    }
}

extension StorageViewController: UIImagePickerControllerDelegate {
    
    private func selectImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
}
