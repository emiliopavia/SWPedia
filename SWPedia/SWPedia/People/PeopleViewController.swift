//
//  PeopleViewController.swift
//  SWPedia
//
//  Created by Emilio Pavia on 18/02/21.
//

import UIKit
import RxSwift
import RxCocoa
import SWPediaKit

class PeopleViewController: UIViewController {

    let client: HTTPClient
    
    lazy var peopleView = PeopleView(layout: viewModel.layout)
    
    lazy var switchModeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: nil,
                                     style: .plain,
                                     target: self,
                                     action: #selector(switchMode(_:)))
        return button
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .primaryActionTriggered)
        return refreshControl
    }()
    
    lazy var viewModel = PeopleViewModel(client: client, baseURL: URL(string: "https://swapi.dev/api/people/")!)
    
    private lazy var disposeBag = DisposeBag()
    
    init(client: HTTPClient) {
        self.client = client
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = peopleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Star Wars"
        navigationItem.rightBarButtonItem = switchModeButton
        
        bindViewModel()
        
        peopleView.collectionView.delegate = self
        peopleView.collectionView.refreshControl = refreshControl
        
        peopleView.searchBar.delegate = self
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        coordinator.animate { _ in
            self.peopleView.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.refreshIfNeeded()
    }
    
    @objc private func switchMode(_ sender: UIBarButtonItem) {
        viewModel.switchMode()
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        viewModel.refresh(animated: false)
    }
    
    private func bindViewModel() {
        viewModel.bind(to: peopleView)
        
        viewModel.isLoading
            .filter { [unowned self] in !$0 && self.refreshControl.isRefreshing }
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        viewModel.layoutMode
            .map { mode -> UIImage? in
                switch mode {
                case .grid: return UIImage(systemName: "list.dash")
                case .list: return UIImage(systemName: "square.grid.2x2")
                }
            }
            .bind(to: switchModeButton.rx.image)
            .disposed(by: disposeBag)
    }
}

extension PeopleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.willDisplayCell(at: indexPath)
    }
}

extension PeopleViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
