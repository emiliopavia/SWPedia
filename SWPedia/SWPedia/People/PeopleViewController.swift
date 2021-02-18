//
//  PeopleViewController.swift
//  SWPedia
//
//  Created by Emilio Pavia on 18/02/21.
//

import UIKit
import SWPediaKit

class PeopleViewController: UIViewController {

    let client: HTTPClient
    
    lazy var peopleView = PeopleView(layout: viewModel.layout)
    lazy var viewModel = PeopleViewModel(client: client)
    
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
        
        viewModel.bind(to: peopleView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.refreshIfNeeded()
    }
}
