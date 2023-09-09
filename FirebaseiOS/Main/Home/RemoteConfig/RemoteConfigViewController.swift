//
//  RemoteConfigViewController.swift
//  FirebaseiOS
//
//  Created by Zokirjon Mamadjonov on 30/06/2023.
//

import UIKit
import FirebaseRemoteConfig
import FirebaseAnalytics

class RemoteConfigViewController: UIViewController {

    @IBOutlet private weak var appVersionTextField: UITextField!
    @IBOutlet private weak var developerNameTextField: UITextField!
    @IBOutlet private weak var developerWebsiteTextField: UITextField!
    @IBOutlet private weak var contactEmailTextField: UITextField!
    
    private var remoteConfig: RemoteConfig!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        remoteConfig = RemoteConfig.remoteConfig()
        setupRemoteConfigDefaults()
        updateViews()
    }
    
    private func setupRemoteConfigDefaults() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
    }
    
    private func updateViews() {
        appVersionTextField.text = remoteConfig.configValue(forKey: RCConstants.APP_VERSION).stringValue
        developerNameTextField.text = remoteConfig.configValue(forKey: RCConstants.DEVELOPER_NAME).stringValue
        developerWebsiteTextField.text = remoteConfig.configValue(forKey: RCConstants.DEVELOPER_WEBSITE).stringValue
        contactEmailTextField.text = remoteConfig.configValue(forKey: RCConstants.CONTACT_EMAIL).stringValue
    }
    
    @IBAction private func fetchRemoteConfigButtonClicked(_ sender: UIButton) {
        fetchRemoteConfig()
        logAnalytics(name: AnalyticsConstants.FETCH_REMOTE_CONFIG_BUTTON_CLICKED, parameters: nil)
    }
    
    private func fetchRemoteConfig() {
        remoteConfig.fetch(withExpirationDuration: 0) { status, error in
          if status == .success {
            self.remoteConfig.activate { changed, error in
                DispatchQueue.main.async {
                    self.updateViews()
                }
            }
          }
        }
    }
    
    @IBAction private func copyAppVersionButtonClicked(_ sender: UIButton) {
        guard let text = appVersionTextField.text else { return }
        copyTextToPasteboard(text)
        logAnalytics(name: AnalyticsConstants.COPY_APP_VERSION_BUTTON_CLICKED, parameters: [AnalyticsConstants.APP_VERSION_KEY: text])
    }
    
    @IBAction private func copyDeveloperNameButtonClicked(_ sender: UIButton) {
        guard let text = developerNameTextField.text else { return }
        copyTextToPasteboard(text)
        logAnalytics(name: AnalyticsConstants.COPY_DEVELOPER_NAME_BUTTON_CLICKED, parameters: [AnalyticsConstants.DEVELOPER_NAME_KEY: text])
    }
    
    @IBAction private func copyDeveloperWebsiteButtonClicked(_ sender: UIButton) {
        guard let text = developerWebsiteTextField.text else { return }
        copyTextToPasteboard(text)
        logAnalytics(name: AnalyticsConstants.COPY_DEVELOPER_WEBSITE_BUTTON_CLICKED, parameters: [AnalyticsConstants.DEVELOPER_WEBSITE_KEY: text])
    }
    
    @IBAction private func copyContactEmailButtonClicked(_ sender: UIButton) {
        guard let text = contactEmailTextField.text else { return }
        copyTextToPasteboard(text)
        logAnalytics(name: AnalyticsConstants.COPY_CONTACT_EMAIL_BUTTON_CLICKED, parameters: [AnalyticsConstants.CONTACT_EMAIL_KEY: text])
    }
    
    private func copyTextToPasteboard(_ string: String) {
        UIPasteboard.general.string = string
    }
    
    private func logAnalytics(name: String, parameters: [String : Any]?) {
        Analytics.logEvent(name, parameters: parameters)
    }
}
