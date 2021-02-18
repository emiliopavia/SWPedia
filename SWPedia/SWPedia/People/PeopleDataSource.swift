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
    case list(Person)
    case grid(Person)
}

class PeopleDataSource: UICollectionViewDiffableDataSource<PeopleSection, PeopleItem> {
    init(collectionView: UICollectionView) {
        let listCell = UICollectionView.CellRegistration<PeopleListCell, Person> { (cell, indexPath, item) in
            cell.person = item
        }
        
        let gridCell = UICollectionView.CellRegistration<PeopleGridCell, Person> { (cell, indexPath, item) in
            cell.person = item
        }
        
        super.init(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .list(let person):
                return collectionView.dequeueConfiguredReusableCell(using: listCell, for: indexPath, item: person)
            case .grid(let person):
                return collectionView.dequeueConfiguredReusableCell(using: gridCell, for: indexPath, item: person)
            }
        }
    }
}
