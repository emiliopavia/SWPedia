//
//  PeopleViewModel.swift
//  SWPedia
//
//  Created by Emilio Pavia on 18/02/21.
//

import UIKit
import RxSwift
import RxRelay
import SWPediaKit

class PeopleViewModel {
    
    let client: HTTPClient
    let baseURL: URL
    
    var layoutMode: Observable<LayoutMode> { _layoutMode.asObservable() }
    var isLoading: Observable<Bool> { _isLoading.asObservable() }
    
    var layout: UICollectionViewLayout { PeopleLayoutBuilder.layout(with: _layoutMode.value) }
    
    private var dataSource: UICollectionViewDiffableDataSource<PeopleSection, PeopleItem>?
    private var data = [Person]()
    private var nextURL: URL?
    private var searchString: String?
    
    private var currentRequest: Disposable? {
        didSet {
            oldValue?.dispose()
        }
    }
    
    private let _layoutMode = BehaviorRelay<LayoutMode>(value: .grid)
    private var _isLoading = BehaviorRelay<Bool>(value: false)
    
    private var disposeBag: DisposeBag?
    
    init(client: HTTPClient, baseURL: URL) {
        self.client = client
        self.baseURL = baseURL
    }
    
    deinit {
        currentRequest?.dispose()
    }
    
    func bind(to peopleView: PeopleView) {
        let disposeBag = DisposeBag()
        defer { self.disposeBag = disposeBag }
        
        layoutMode
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.updateLayout(to: peopleView.collectionView, with: $0)
            })
            .disposed(by: disposeBag)
        
        peopleView.searchBar.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.search($0)
            })
            .disposed(by: disposeBag)
        
        dataSource = PeopleDataSource(collectionView: peopleView.collectionView)
    }
    
    func switchMode() {
        currentRequest = nil
        
        switch _layoutMode.value {
        case .list:
            _layoutMode.accept(.grid)
        case .grid:
            _layoutMode.accept(.list)
        }
    }
    
    func refreshIfNeeded() {
        guard data.isEmpty else { return }
        refresh(animated: false)
    }
    
    func refresh(animated: Bool) {
        data.removeAll()
        nextURL = baseURL
        loadNext(animated: animated)
    }
    
    func willDisplayCell(at indexPath: IndexPath) {
        if indexPath.item == data.count - 1 {
            loadNext(animated: true)
        }
    }
    
    func person(at indexPath: IndexPath) -> Person? {
        if let item = dataSource?.itemIdentifier(for: indexPath) {
            switch item {
            case .grid(let person),
                 .list(let person):
                return person
            }
        }
        return nil
    }
    
    private func search(_ name: String) {
        searchString = name
        refresh(animated: true)
    }
    
    private func loadNext(animated: Bool) {
        guard let url = nextURL else { return }
        
        _isLoading.accept(true)
        
        currentRequest = client.send(PeopleRequest(url: url, query: searchString))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.updateData(with: $0, animated: animated)
            },
            onError: { _ in
                // TODO: handle error
            },
            onDisposed: { [weak self] in
                self?._isLoading.accept(false)
            })
    }
    
    private func updateLayout(to collectionView: UICollectionView, with mode: LayoutMode) {
        collectionView.setCollectionViewLayout(PeopleLayoutBuilder.layout(with: mode), animated: false)
        var snapshot = NSDiffableDataSourceSnapshot<PeopleSection, PeopleItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data.peopleItems(with: mode))
        dataSource?.apply(snapshot, animatingDifferences: false)
        collectionView.scrollToTop()
    }
    
    private func updateData(with page: APIPaginatedResponse<Person>, animated: Bool) {
        guard let dataSource = dataSource else { return }
        
        data.append(contentsOf: page.results)
        nextURL = page.next
        
        var snapshot: NSDiffableDataSourceSnapshot<PeopleSection, PeopleItem>
        if page.previous == nil {
            // replace
            snapshot = NSDiffableDataSourceSnapshot()
            snapshot.appendSections([.main])
        } else {
            // append
            snapshot = dataSource.snapshot()
        }
        
        snapshot.appendItems(page.results.peopleItems(with: _layoutMode.value),
                             toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

extension Array where Element == Person {
    func peopleItems(with mode: LayoutMode) -> [PeopleItem] {
        map { person -> PeopleItem in
            switch mode {
            case .list:
                return .list(person)
            case .grid:
                return .grid(person)
            }
        }
    }
}
