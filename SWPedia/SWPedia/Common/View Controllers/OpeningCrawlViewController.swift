//
//  OpeningCrawlViewController.swift
//  SWPedia
//
//  Created by Emilio Pavia on 19/02/21.
//

import UIKit

class OpeningCrawlViewController: UIViewController {

    let openingCrawl: String
    
    private lazy var textView: UITextView = {
        let textView = UITextView(frame: .zero, textContainer: nil)
        textView.textColor = .yellow
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isSelectable = false
        textView.font = UIFont(name: "News Gothic Std", size: 20)
        textView.textContainerInset.bottom = 260 // magic number to scroll the text even further
        
        var transform: CATransform3D = CATransform3DIdentity
        transform.m34 = -1 / 250
        transform = CATransform3DRotate(transform, 45 * CGFloat.pi / 180.0, 1.0, 0.0, 0.0);
        textView.layer.transform = transform
        
        return textView
    }()
    
    private lazy var textViewHeightConstraint: NSLayoutConstraint = {
        let constraint = textView.heightAnchor.constraint(equalToConstant: 0)
        return constraint
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    init(openingCrawl: String) {
        self.openingCrawl = openingCrawl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textViewHeightConstraint
        ])
        
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
        textView.text = openingCrawl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 15.0,
                       delay: 0,
                       options: [.curveLinear]) {
            let size = self.textView.sizeThatFits(CGSize(width: self.view.bounds.width,
                                                         height: CGFloat.greatestFiniteMagnitude))
            self.textViewHeightConstraint.constant = size.height
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(nil)
        }
    }
    
    @objc func dismiss(_ sender: UIButton?) {
        dismiss(animated: true, completion: nil)
    }
}
