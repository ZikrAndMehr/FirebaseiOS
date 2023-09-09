//
//  HomeCollectionViewCell.swift
//  FirebaseiOS
//
//  Created by Zokirjon Mamadjonov on 22/06/2023.
//

import UIKit

struct HomeItem {
    let image: UIImage
    let title: String
    let description: String
}

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    static let reuseIdentifier = "HomeCollectionViewCell"
    static let cellHeight = 300.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 16
    }
    
    func bind(item: HomeItem) {
        iconImageView.image = item.image
        titleLabel.text = item.title
        descriptionLabel.text = item.description
    }
}
