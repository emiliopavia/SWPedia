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
    
    enum Section: CaseIterable {
        case main
    }
    
    let client: HTTPClient
    
    var layout: UICollectionViewLayout { PeopleLayoutBuilder.layout(with: layoutMode.value) }
    var dataSource: UICollectionViewDiffableDataSource<Section, People>?
    
    private let layoutMode = BehaviorRelay<PeopleLayoutBuilder.Mode>(value: .grid)
    
    private var disposeBag: DisposeBag?
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func bind(to peopleView: PeopleView) {
        let disposeBag = DisposeBag()
        defer { self.disposeBag = disposeBag }
        
        layoutMode
            .observe(on: MainScheduler.instance)
            .subscribe { peopleView.collectionView.collectionViewLayout = PeopleLayoutBuilder.layout(with: $0) }
            .disposed(by: disposeBag)
    }
    
    func refreshIfNeeded() {
        
    }
}
