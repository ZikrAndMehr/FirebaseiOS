//
//  CrashlyticsViewController.swift
//  FirebaseiOS
//
//  Created by Zokirjon Mamadjonov on 29/06/2023.
//

import UIKit
import FirebaseAuth
import FirebaseCrashlytics

class CrashlyticsViewController: UIViewController {

    //    1.Run app from Xcode to install it on the simulator or your device
    //    2.Press the Stop button in Xcode to quit it
    //    3.Launch app from the home screen to run it without the debugger
    //    4.Press the “Make a manual Crash #” button to trigger the crash
    //    5.Run app again from Xcode so it can deliver the recorded crash to Crashlytics
    //    6.Within a few minutes, you should see the crash appear on your Firebase Crashlytics Console.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userUid = Auth.auth().currentUser?.uid, let userEmail = Auth.auth().currentUser?.email else { return }
        
        let userData = [
            CConstants.USER_UID: userUid,
            CConstants.USER_EMAIL: userEmail
        ]
        
        Crashlytics.crashlytics().setCustomKeysAndValues(userData)
    }
    
    @IBAction private func makeCrash1ButtonClicked(_ sender: UIButton) {
        let numbers = [0]
        let _ = numbers[1]
    }

    @IBAction private func makeCrash2ButtonClicked(_ sender: UIButton) {
        fatalError("This was fatal crash.")
    }
    
    @IBAction private func makeCrash3ButtonClicked(_ sender: UIButton) {
        let string: String? = nil
        _ = string!
    }
}
