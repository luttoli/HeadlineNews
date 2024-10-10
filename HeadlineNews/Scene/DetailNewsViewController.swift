//
//  DetailNewsViewController.swift
//  HeadlineNews
//
//  Created by 김지훈 on 10/10/24.
//

import UIKit

import SnapKit

class DetailNewsViewController: UIViewController {
    // MARK: - Properties
    
    
    // MARK: - Components
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - LifeCycle
extension DetailNewsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationUI()
        setUp()
    }
}

// MARK: - Navigation
extension DetailNewsViewController {
    func navigationUI() {
        navigationController?.navigationBar.barTintColor = .background.white
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .text.black
    }
}

// MARK: - SetUp
private extension DetailNewsViewController {
    func setUp() {
        
    }
}

// MARK: - Method
private extension DetailNewsViewController {

}

// MARK: - Delegate
extension DetailNewsViewController {
    
}

