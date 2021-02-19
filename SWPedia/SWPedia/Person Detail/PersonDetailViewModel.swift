//
//  PersonDetailViewModel.swift
//  SWPedia
//
//  Created by Emilio Pavia on 19/02/21.
//

import UIKit
import RxSwift
import RxRelay
import SWPediaKit

class PersonDetailViewModel {
    
    let client: HTTPClient
    let person: Person
    
    var layout: UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<PersonDetailSection, PersonDetailItem>?
    
    private var disposeBag: DisposeBag?
    
    init(client: HTTPClient, person: Person) {
        self.client = client
        self.person = person
    }
    
    func bind(to personDetailView: PersonDetailView) {
        let disposeBag = DisposeBag()
        defer { self.disposeBag = disposeBag }
        
        dataSource = PersonDetailDataSource(collectionView: personDetailView.collectionView)
        updateData(with: person)
    }
    
    private func updateData(with person: Person) {
        guard let dataSource = dataSource else { return }
        
        var snapshot: NSDiffableDataSourceSnapshot<PersonDetailSection, PersonDetailItem>
        snapshot = NSDiffableDataSourceSnapshot()
        
        snapshot.appendSections([.avatar])
        snapshot.appendItems([
            .avatar(person.avatar)
        ])
        
        snapshot.appendSections([.general])
        snapshot.appendItems([
            .info("Name", person.name),
            .info("Birth Year", person.birthYear),
            .info("Eye Color", person.eyeColor),
            .info("Gender", person.gender),
            .info("Hair Color", person.hairColor),
            .info("Height", person.height),
            .info("Mass", person.mass),
            .info("Skin Color", person.skinColor),
        ])
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
