//
//  NewsViewController.swift
//  HeadlineNews
//
//  Created by 김지훈 on 10/8/24.
//

import UIKit

import SnapKit

class NewsViewController: UIViewController {
    // MARK: - Properties
    
    
    // MARK: - Components
    var newsItems = Array(1...37).map { "\($0)" }

    let newsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let newsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        newsCollectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.identifier)
        newsCollectionView.backgroundColor = .yellow
        return newsCollectionView
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - LifeCycle
extension NewsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background.white
        
        navigationUI()
        setUp()
    }
}

// MARK: - Navigation
extension NewsViewController {
    func navigationUI() {
        navigationController?.navigationBar.barTintColor = .background.white
        
        let viewTitle = CustomLabel(title: "News", size: Constants.size.size24, weight: .SemiBold, color: .text.black)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: viewTitle)
    }
}

// MARK: - SetUp
private extension NewsViewController {
    func setUp() {
        view.addSubview(newsCollectionView)
        
        newsCollectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self
    }
}

// MARK: - Method
private extension NewsViewController {
    
}

// MARK: - Delegate
extension NewsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsItems.count
    }
    
    // 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = .lightGray
        
        let numberText = "\(indexPath.row + 1)"
        cell.label.text = numberText
        
        return cell
    }
}
