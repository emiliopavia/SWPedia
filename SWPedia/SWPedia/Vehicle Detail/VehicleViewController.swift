//
//  VehicleViewController.swift
//  SWPedia
//
//  Created by Emilio Pavia on 19/02/21.
//

import UIKit
import SWPediaKit

class VehicleViewController: UICollectionViewController {

    let vehicle: Vehicle
    
    private lazy var dataSource = VehicleDataSource(collectionView: collectionView)
    
    init(vehicle: Vehicle) {
        self.vehicle = vehicle
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        super.init(collectionViewLayout: UICollectionViewCompositionalLayout.list(using: config))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = vehicle.name
        collectionView.allowsSelection = false
        
        reloadData()
    }
    
    private func reloadData() {
        var snapshot: NSDiffableDataSourceSnapshot<VehicleSection, VehicleItem>
        snapshot = NSDiffableDataSourceSnapshot()
        
        snapshot.appendSections([.main])
        snapshot.appendItems([
            .info("Name", vehicle.name),
            .info("Model", vehicle.model),
            .info("Vehicle Class", vehicle.vehicleClass),
            .info("Manufacturer", vehicle.manufacturer),
            .info("Length", vehicle.length),
            .info("Cost In Credits", vehicle.costInCredits),
            .info("Crew", vehicle.crew),
            .info("Passengers", vehicle.passengers),
            .info("Max Atmosphering Speed", vehicle.maxAtmospheringSpeed),
            .info("Cargo Capacity", vehicle.cargoCapacity),
            .info("Consumables", vehicle.consumables)
        ])
       
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
