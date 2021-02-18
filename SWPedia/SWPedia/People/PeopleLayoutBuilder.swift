//
//  PeopleLayoutBuilder.swift
//  SWPedia
//
//  Created by Emilio Pavia on 18/02/21.
//

import UIKit

enum LayoutMode {
    case list
    case grid
}

class PeopleLayoutBuilder {
    class func layout(with mode: LayoutMode) -> UICollectionViewLayout {
        switch mode {
        case .list:
            return listLayout()
        case .grid:
            return gridLayout()
        }
    }
    
    private class func listLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private class func gridLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let contentSize = layoutEnvironment.container.effectiveContentSize
            let columns = contentSize.width > 400 ? 4 : 2
            let spacing = CGFloat(30)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .estimated(100))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            group.interItemSpacing = .fixed(spacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 40, trailing: 20)

            return section
        }
        return layout
    }
}
