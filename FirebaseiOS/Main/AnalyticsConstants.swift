//
//  AnalyticsConstants.swift
//  FirebaseiOS
//
//  Created by Zokirjon Mamadjonov on 03/07/2023.
//

import Foundation

class AnalyticsConstants {
    
    static let ERROR_NAME_LENGTH = 40
    static let ERROR = "------------------ERROR------------------"
    static let ERROR_KEY = "error_key"
    
    //ViewController
    static let SIGN_IN_BUTTON_CLICKED = "sign_in_button_clicked"
    static let SIGN_UP_BUTTON_CLICKED = "sign_up_button_clicked"
    
    //SignInViewController
    static let SIGN_IN_WITH_EMAIL_BUTTON_CLICKED = "sign_in_with_email_button_clicked"
    static let SIGN_IN_WITH_EMAIL_ERROR = "sign_in_with_email_error"
    static let SIGN_IN_WITH_GOOGLE_BUTTON_CLICKED = "sign_in_with_google_button_clicked"
    static let SIGN_IN_WITH_GOOGLE_ERROR = "sign_in_with_google_error"
    static let SIGN_IN_WITH_APPLE_BUTTON_CLICKED = "sign_in_with_apple_button_clicked"
    static let SIGN_IN_WITH_APPLE_ERROR = "sign_in_with_apple_error"
    
    //SignUpViewController
    static let SIGN_UP_WITH_EMAIL_BUTTON_CLICKED = "sign_up_with_email_button_clicked"
    
    //HomeViewController
    static let AUTHENTICATION_CLICKED = "authentication_clicked"
    static let REALTIME_DATABASE_CLICKED = "realtime_database_clicked"
    static let CLOUD_FIRESTORE_CLICKED = "cloud_firestore_clicked"
    static let STORAGE_CLICKED = "storage_clicked"
    static let MESSAGING_CLICKED = "messaging_clicked"
    static let CRASHLYTICS_CLICKED = "crashlytics_clicked"
    static let REMOTE_CONFIG_CLICKED = "remote_config_clicked"
    
    //AuthenticationViewController
    static let SIGN_OUT_BUTTON_CLICKED = "sign_out_button_clicked"
    static let DELETE_ACCOUNT_BUTTON_CLICKED = "delete_account_button_clicked"
    
    //RealtimeDatabaseViewController
    static let DELETE_NOTE_BUTTON_CLICKED = "delete_note_button_clicked"
    static let NOTE_ID_KEY = "note_id"
    static let ADD_NEW_NOTE_BUTTON_CLICKED = "add_new_note_button_clicked"
    
    //NewNoteViewController
    static let SAVE_NEW_NOTE_BUTTON_CLICKED = "save_new_note_button_clicked"
    
    //CloudFirestoreViewController
    static let UPDATE_QUOTE_BUTTON_CLICKED = "update_quote_button_clicked"
    
    //StorageViewController
    static let SELECT_IMAGE_BUTTON_CLICKED = "select_image_button_clicked"
    static let COPY_IMAGE_URL_BUTTON_CLICKED = "copy_image_url_button_clicked"
    static let UPLOAD_IMAGE_BUTTON_CLICKED = "upload_image_button_clicked"
    
    //RemoteConfigViewController
    static let COPY_APP_VERSION_BUTTON_CLICKED = "copy_app_version_button_clicked"
    static let APP_VERSION_KEY = "app_version"
    static let COPY_DEVELOPER_NAME_BUTTON_CLICKED = "copy_developer_name_button_clicked"
    static let DEVELOPER_NAME_KEY = "developer_name"
    static let COPY_DEVELOPER_WEBSITE_BUTTON_CLICKED = "copy_developer_website_button_clicked"
    static let DEVELOPER_WEBSITE_KEY = "developer_website"
    static let COPY_CONTACT_EMAIL_BUTTON_CLICKED = "copy_contact_email_button_clicked"
    static let CONTACT_EMAIL_KEY = "contact_email"
    static let FETCH_REMOTE_CONFIG_BUTTON_CLICKED = "fetch_remote_config_button_clicked"
    
    private init() {}
}
