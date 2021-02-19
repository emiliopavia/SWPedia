//
//  PersonDetailDataSource.swift
//  SWPedia
//
//  Created by Emilio Pavia on 19/02/21.
//

import UIKit
import SWPediaKit

enum PersonDetailSection: CaseIterable {
    case avatar
    case general
    case films
    case vehicles
}

enum PersonDetailItem: Hashable {
    case avatar(URL?)
    case info(_ key: String, _ value: String)
}

class PersonDetailDataSource: UICollectionViewDiffableDataSource<PersonDetailSection, PersonDetailItem> {
    init(collectionView: UICollectionView) {
        let avatarCell = UICollectionView.CellRegistration<AvatarCell, URL> { (cell, indexPath, item) in
            cell.avatar = item
        }
        
        let infoCell = UICollectionView.CellRegistration<UICollectionViewListCell, (String, String)> { (cell, indexPath, item) in
            var configuration = UIListContentConfiguration.valueCell()
            configuration.text = item.0
            configuration.secondaryText = item.1
            cell.contentConfiguration = configuration
        }
        
        super.init(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .avatar(let url):
                return collectionView.dequeueConfiguredReusableCell(using: avatarCell, for: indexPath, item: url)
            case .info(let key, let value):
                return collectionView.dequeueConfiguredReusableCell(using: infoCell, for: indexPath, item: (key, value))
            default: return nil
            }
        }
    }
}
