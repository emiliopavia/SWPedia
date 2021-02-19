//
//  AvatarCell.swift
//  SWPedia
//
//  Created by Emilio Pavia on 19/02/21.
//

import UIKit
import Kingfisher

class AvatarCell: UICollectionViewCell {
    
    var avatar: URL? {
        didSet {
            reloadData()
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = RoundedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: 200)
        widthConstraint.priority = .required-1
        widthConstraint.isActive = true
        
        let aspectRatioConstraint = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        aspectRatioConstraint.priority = .required-1
        aspectRatioConstraint.isActive = true
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatar = nil
    }
    
    private func clear() {
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
    
    private func reloadData() {
        guard let url = avatar else {
            clear()
            return
        }
        
        imageView.kf.setImage(with: url, placeholder: UIImage.avatarPlaceholder,
                              options: [.transition(.fade(0.25))])
    }
}
