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
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.headerMode = .supplementary
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<PersonDetailSection, PersonDetailItem>?
    
    private var films: [Film]?
    
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
    
    func refreshIfNeeded() {
        refreshFilmsIfNeeded()
        refreshVehiclesIfNeeded()
    }
    
    func refreshFilmsIfNeeded() {
        guard films == nil else { return }
        guard let disposeBag = self.disposeBag else { return }
        
        let films = person.films.map { getFilm(from: $0) }
        Observable.zip(films)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.updateData(with: $0)
            }, onError: { [weak self] _ in
                self?.updateData(with: [])
            }) {
                
            }
            .disposed(by: disposeBag)
    }
    
    func refreshVehiclesIfNeeded() {
        
    }
    
    func film(at indexPath: IndexPath) -> Film? {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else {
            return nil
        }
        
        switch item {
        case .film(let film):
            return film
        default:
            return nil
        }
    }
    
    private func getFilm(from url: URL) -> Observable<Film> {
        client.send(FilmRequest(url: url))
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
        
        snapshot.appendSections([.films])
        snapshot.appendItems([.loading("films")])
        
        snapshot.appendSections([.vehicles])
        snapshot.appendItems([.loading("vehicles")])
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func updateData(with films: [Film]) {
        self.films = films
        
        guard let dataSource = dataSource else { return }
        
        var snapshot = dataSource.snapshot()
        snapshot.deleteSections([.films])
        snapshot.insertSections([.films], afterSection: .general)
        snapshot.appendItems(films.map { PersonDetailItem.film($0) },
                             toSection: .films)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
