//
//  PeopleDataSource.swift
//  SWPedia
//
//  Created by Emilio Pavia on 18/02/21.
//

import UIKit
import Kingfisher
import SWPediaKit

enum PeopleSection: CaseIterable {
    case main
}

enum PeopleItem: Hashable {
    case list(People)
    case grid(People)
}

class PeopleDataSource: UICollectionViewDiffableDataSource<PeopleSection, PeopleItem> {
    init(collectionView: UICollectionView) {
        let listCell = UICollectionView.CellRegistration<PeopleListCell, People> { (cell, indexPath, item) in
            cell.people = item
        }
        
        let gridCell = UICollectionView.CellRegistration<PeopleGridCell, People> { (cell, indexPath, item) in
            cell.people = item
        }
        
        super.init(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .list(let people):
                return collectionView.dequeueConfiguredReusableCell(using: listCell, for: indexPath, item: people)
            case .grid(let people):
                return collectionView.dequeueConfiguredReusableCell(using: gridCell, for: indexPath, item: people)
            }
        }
    }
}
