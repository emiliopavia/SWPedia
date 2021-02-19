//
//  PeopleGridCell.swift
//  SWPedia
//
//  Created by Emilio Pavia on 18/02/21.
//

import UIKit
import Kingfisher
import SWPediaKit

class PeopleGridCell: UICollectionViewCell {

    var person: Person? {
        didSet {
            reloadData()
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = RoundedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let aspectRatioConstraint = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        aspectRatioConstraint.priority = .required-1
        aspectRatioConstraint.isActive = true
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = UIColor.label
        label.textAlignment = .center
        return label
    }()
    
    private let imageDownloader = KingfisherManager.shared
    private var downloadTask: DownloadTask?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(nameLabel)
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        person = nil
    }
    
    private func clear() {
        downloadTask?.cancel()
        downloadTask = nil
        imageView.image = nil
        nameLabel.text = nil
    }
    
    private func reloadData() {
        guard let person = person else {
            clear()
            return
        }
        
        imageView.image = UIImage.avatarPlaceholder
        nameLabel.text = person.name
        
        if let url = person.avatar {
            downloadTask = imageDownloader.retrieveImage(with: url, options: [
                .transition(.fade(0.25))
            ]) { [weak self] result in
                if case .success(let value) = result {
                    self?.imageView.image = value.image
                }
                self?.downloadTask = nil
            }
        }
    }
}
