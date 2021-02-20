//
//  PeopleView.swift
//  SWPedia
//
//  Created by Emilio Pavia on 18/02/21.
//

import UIKit

class PeopleView: UIView {

    let collectionView: UICollectionView
    let searchBar: UISearchBar
    
    init(layout: UICollectionViewLayout) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        searchBar = UISearchBar()
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor.systemBackground
        
        addSearchBar()
        addCollectionView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.contentInset.top = searchBar.frame.height - 1
        collectionView.verticalScrollIndicatorInsets.top = searchBar.frame.height - 1
    }
    
    private func addCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.keyboardDismissMode = .interactive
        insertSubview(collectionView, belowSubview: searchBar)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func addSearchBar() {
        addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -1),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        searchBar.sizeToFit()
    }
}
