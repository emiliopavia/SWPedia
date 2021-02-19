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
    
    private lazy var films: Observable<[Film]> = {
        let films = person.films.map {
            getFilm(from: $0).share(replay: 1, scope: .forever)
        }
        return Observable.zip(films)
    }()
    
    private lazy var vehicles: Observable<[Vehicle]> = {
        let vehicles = person.vehicles.map {
            getVehicle(from: $0).share(replay: 1, scope: .forever)
        }
        return Observable.zip(vehicles)
    }()
    
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
        guard let disposeBag = self.disposeBag else { return }
        
        films
            .catchAndReturn([])
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.updateData(withFilms: $0)
            })
            .disposed(by: disposeBag)
    }
    
    func refreshVehiclesIfNeeded() {
        guard let disposeBag = self.disposeBag else { return }
        
        vehicles
            .catchAndReturn([])
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.updateData(withVehicles: $0)
            })
            .disposed(by: disposeBag)
    }
    
    func shouldSelectItem(at indexPath: IndexPath) -> Bool {
        switch item(at: indexPath) {
        case .film, .vehicle: return true
        default: return false
        }
    }
    
    func item(at indexPath: IndexPath) -> PersonDetailItem? {
        dataSource?.itemIdentifier(for: indexPath)
    }
    
    private func getFilm(from url: URL) -> Observable<Film> {
        client.send(FilmRequest(url: url))
    }
    
    private func getVehicle(from url: URL) -> Observable<Vehicle> {
        client.send(VehicleRequest(url: url))
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
        
        if !person.films.isEmpty {
            snapshot.appendSections([.films])
            snapshot.appendItems([.loading("films")])
        }
        
        if !person.vehicles.isEmpty {
            snapshot.appendSections([.vehicles])
            snapshot.appendItems([.loading("vehicles")])
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func updateData(withFilms films: [Film]) {
        guard let dataSource = dataSource else { return }
        
        var snapshot = dataSource.snapshot()
        snapshot.deleteSections([.films])
        snapshot.insertSections([.films], afterSection: .general)
        snapshot.appendItems(films.map { PersonDetailItem.film($0) },
                             toSection: .films)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func updateData(withVehicles vehicles: [Vehicle]) {
        guard let dataSource = dataSource else { return }
        
        var snapshot = dataSource.snapshot()
        snapshot.deleteSections([.vehicles])
        snapshot.insertSections([.vehicles], afterSection: .films)
        snapshot.appendItems(vehicles.map { PersonDetailItem.vehicle($0) },
                             toSection: .vehicles)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
