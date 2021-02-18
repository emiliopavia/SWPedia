//
//  PeopleListCell.swift
//  SWPedia
//
//  Created by Emilio Pavia on 18/02/21.
//

import UIKit
import Kingfisher
import SWPediaKit

class PeopleListCell: UICollectionViewListCell {
    
    var people: People? {
        didSet {
            reloadData()
        }
    }
    
    private let imageDownloader = KingfisherManager.shared
    private var downloadTask: DownloadTask?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        people = nil
    }
    
    private func clear() {
        contentConfiguration = nil
        downloadTask?.cancel()
        downloadTask = nil
    }
    
    private func reloadData() {
        guard let people = people else {
            clear()
            return
        }
        
        var configuration = defaultContentConfiguration()
        configuration.text = "\(people.name)"
        configuration.image = UIImage(named: "placeholder")
        configuration.imageProperties.maximumSize = CGSize(width: 60, height: 60)
        configuration.imageProperties.cornerRadius = 30
        contentConfiguration = configuration
        
        if let url = people.avatar {
            downloadTask = imageDownloader.retrieveImage(with: url, options: [
                .transition(.fade(0.25))
            ]) { [weak self] result in
                if case .success(let value) = result {
                    configuration.image = value.image
                    self?.contentConfiguration = configuration
                }
                self?.downloadTask = nil
            }
        }
    }
}
