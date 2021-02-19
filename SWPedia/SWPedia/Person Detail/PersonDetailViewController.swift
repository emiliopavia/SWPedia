//
//  PersonDetailViewController.swift
//  SWPedia
//
//  Created by Emilio Pavia on 19/02/21.
//

import UIKit
import RxSwift
import RxCocoa
import SWPediaKit

class PersonDetailViewController: UIViewController {
    
    let client: HTTPClient
    let person: Person
    
    lazy var personDetailView = PersonDetailView(layout: viewModel.layout)
    
    lazy var viewModel = PersonDetailViewModel(client: client, person: person)
    
    private lazy var disposeBag = DisposeBag()
    
    init(client: HTTPClient, person: Person) {
        self.client = client
        self.person = person
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = personDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = person.name
        
        personDetailView.collectionView.delegate = self
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        personDetailView.collectionView.deselectItems(transitionCoordinator: transitionCoordinator)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.refreshIfNeeded()
    }
    
    private func bindViewModel() {
        viewModel.bind(to: personDetailView)
    }
    
    private func showOpeningCrawl(for film: Film) {
        let vc = OpeningCrawlViewController(openingCrawl: film.openingCrawl)
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    private func show(_ vehicle: Vehicle) {

    }
}

extension PersonDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        viewModel.shouldSelectItem(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch viewModel.item(at: indexPath) {
        case .film(let film):
            showOpeningCrawl(for: film)
        case .vehicle(let vehicle):
            show(vehicle)
        default:
            break
        }
    }
}
