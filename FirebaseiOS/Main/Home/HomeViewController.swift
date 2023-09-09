//
//  HomeViewController.swift
//  FirebaseiOS
//
//  Created by Zokirjon Mamadjonov on 20/06/2023.
//

import UIKit
import FirebaseAnalytics

class HomeViewController: UIViewController {

    @IBOutlet private weak var homeCollectionView: UICollectionView!
    
    private var homeCVDataSource: [HomeItem] = []
    private var homeCellsDestinations: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        populateDataSource()
        populateCellsDestinations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func populateCellsDestinations() {
        homeCellsDestinations.append(AuthenticationViewController(nibName: "AuthenticationViewController", bundle: nil))
        homeCellsDestinations.append(RealtimeDatabaseViewController(nibName: "RealtimeDatabaseViewController", bundle: nil))
        homeCellsDestinations.append(CloudFirestoreViewController(nibName: "CloudFirestoreViewController", bundle: nil))
        homeCellsDestinations.append(StorageViewController(nibName: "StorageViewController", bundle: nil))
        homeCellsDestinations.append(MessagingViewController(nibName: "MessagingViewController", bundle: nil))
        homeCellsDestinations.append(CrashlyticsViewController(nibName: "CrashlyticsViewController", bundle: nil))
        homeCellsDestinations.append(RemoteConfigViewController(nibName: "RemoteConfigViewController", bundle: nil))
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    private func configureCollectionView() {
        homeCollectionView.layer.cornerRadius = 16
        homeCollectionView.clipsToBounds = true
        let nib = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
        homeCollectionView.register(nib, forCellWithReuseIdentifier: HomeCollectionViewCell.reuseIdentifier)

        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
    }
    
    private func populateDataSource() {
        homeCVDataSource.append(
            HomeItem(
                image: UIImage(named: "Authentication")!,
                title: NSLocalizedString("auth_title", comment: ""),
                description: NSLocalizedString("auth_desc", comment: "")
            )
        )
        homeCVDataSource.append(
            HomeItem(
                image: UIImage(named: "RealtimeDatabase")!,
                title: NSLocalizedString("realtime_database_title", comment: ""),
                description: NSLocalizedString("realtime_database_desc", comment: "")
            )
        )
        homeCVDataSource.append(
            HomeItem(
                image: UIImage(named: "CloudFirestore")!,
                title: NSLocalizedString("cloud_firestore_title", comment: ""),
                description: NSLocalizedString("cloud_firestore_desc", comment: "")
            )
        )
        homeCVDataSource.append(
            HomeItem(
                image: UIImage(named: "Storage")!,
                title: NSLocalizedString("storage_title", comment: ""),
                description: NSLocalizedString("storage_desc", comment: "")
            )
        )
        homeCVDataSource.append(
            HomeItem(
                image: UIImage(named: "Messaging")!,
                title: NSLocalizedString("messaging_title", comment: ""),
                description: NSLocalizedString("messaging_desc", comment: "")
            )
        )
        homeCVDataSource.append(
            HomeItem(
                image: UIImage(named: "Crashlytics")!,
                title: NSLocalizedString("crashlytics_title", comment: ""),
                description: NSLocalizedString("crashlytics_desc", comment: "")
            )
        )
        homeCVDataSource.append(
            HomeItem(
                image: UIImage(named: "RemoteConfig")!,
                title: NSLocalizedString("remote_config_title", comment: ""),
                description: NSLocalizedString("remote_config_desc", comment: "")
            )
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        homeCVDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.reuseIdentifier, for: indexPath) as! HomeCollectionViewCell
        
        let item = homeCVDataSource[indexPath.item]
        
        cell.bind(item: item)
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        
        switch indexPath.item {
        case 0: logAnalytics(name: AnalyticsConstants.AUTHENTICATION_CLICKED, parameters: nil)
        case 1: logAnalytics(name: AnalyticsConstants.REALTIME_DATABASE_CLICKED, parameters: nil)
        case 2: logAnalytics(name: AnalyticsConstants.CLOUD_FIRESTORE_CLICKED, parameters: nil)
        case 3: logAnalytics(name: AnalyticsConstants.STORAGE_CLICKED, parameters: nil)
        case 4: logAnalytics(name: AnalyticsConstants.MESSAGING_CLICKED, parameters: nil)
        case 5: logAnalytics(name: AnalyticsConstants.CRASHLYTICS_CLICKED, parameters: nil)
        case 6: logAnalytics(name: AnalyticsConstants.REMOTE_CONFIG_CLICKED, parameters: nil)
        default: break
        }
        
        let viewController = homeCellsDestinations[indexPath.item]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func logAnalytics(name: String, parameters: [String : Any]?) {
        Analytics.logEvent(name, parameters: parameters)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.bounds.width, height: HomeCollectionViewCell.cellHeight)
    }
}
