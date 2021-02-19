//
//  VehicleDataSource.swift
//  SWPedia
//
//  Created by Emilio Pavia on 19/02/21.
//

import UIKit

enum VehicleSection: CaseIterable {
    case main
}

enum VehicleItem: Hashable {
    case info(_ key: String, _ value: String)
}

class VehicleDataSource: UICollectionViewDiffableDataSource<VehicleSection, VehicleItem> {
    init(collectionView: UICollectionView) {
        let infoCell = UICollectionView.CellRegistration<UICollectionViewListCell, (String, String)> { (cell, indexPath, item) in
            var configuration = UIListContentConfiguration.valueCell()
            configuration.text = item.0
            configuration.secondaryText = item.1
            cell.contentConfiguration = configuration
        }
        super.init(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .info(let key, let value):
                return collectionView.dequeueConfiguredReusableCell(using: infoCell, for: indexPath, item: (key, value))
            }
        }
    }
}
