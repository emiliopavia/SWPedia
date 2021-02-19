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
    case loading(String)
    case film(Film)
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
        
        let loadingCell = UICollectionView.CellRegistration<LoadingCell, String> { cell, _, _ in
            cell.start()
        }
        
        let filmCell = UICollectionView.CellRegistration<UICollectionViewListCell, Film> { (cell, indexPath, item) in
            var configuration = UIListContentConfiguration.subtitleCell()
            configuration.text = item.title
            configuration.secondaryText = item.releaseYear
            cell.contentConfiguration = configuration
            cell.accessories = [.disclosureIndicator()]
        }
        
        super.init(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .avatar(let url):
                return collectionView.dequeueConfiguredReusableCell(using: avatarCell, for: indexPath, item: url)
            case .info(let key, let value):
                return collectionView.dequeueConfiguredReusableCell(using: infoCell, for: indexPath, item: (key, value))
            case .loading(let key):
                return collectionView.dequeueConfiguredReusableCell(using: loadingCell, for: indexPath, item: key)
            case .film(let film):
                return collectionView.dequeueConfiguredReusableCell(using: filmCell, for: indexPath, item: film)
            }
        }
        
        let header = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { [unowned self] view, elementKind, indexPath in
            let section = self.snapshot().sectionIdentifiers[indexPath.section]
            
            var configuration = view.defaultContentConfiguration()
            switch section {
            case .films:
                configuration.text = "Films"
            case .vehicles:
                configuration.text = "Vehicles"
            default:
                break
            }
            view.contentConfiguration = configuration
        }
        
        supplementaryViewProvider = { collectionView, elementKind, indexPath -> UICollectionReusableView? in
            if elementKind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueConfiguredReusableSupplementary(using: header, for: indexPath)
            }
            
            return nil
        }
    }
}
