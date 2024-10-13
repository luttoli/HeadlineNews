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
    var newsItems: [Article] = []
    var selectedIndexPaths: Set<IndexPath> = []
    
    // MARK: - Components
    let newsCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            return NewsViewController.createSectionLayout(for: environment)
        }
        let newsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        newsCollectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.identifier)
        newsCollectionView.backgroundColor = .clear
        newsCollectionView.showsVerticalScrollIndicator = false
        newsCollectionView.showsHorizontalScrollIndicator = false
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
        fetchNewsData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        newsCollectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - Navigation
extension NewsViewController {
    func navigationUI() {
        navigationController?.navigationBar.barTintColor = .background.white
        
        let viewTitle = CustomLabel(title: "News", size: Constants.size.size28, weight: .SemiBold, color: .text.black)
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
    static func createSectionLayout(for environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let isLandscape = environment.container.effectiveContentSize.width > environment.container.effectiveContentSize.height
        
        if isLandscape {
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(Constants.size.size300), heightDimension: .absolute(Constants.size.size120))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(Constants.size.size300 * 5 + 10 * 4), heightDimension: .absolute(Constants.size.size120))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(10)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
            section.orthogonalScrollingBehavior = .continuous
            return section
        } else {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(Constants.size.size130))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(Constants.size.size130))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
    
    func fetchNewsData() {
        NewsService.shared.fetchNewsData { [weak self] result in
            switch result {
            case .success(let articles):
                self?.newsItems = articles
                DispatchQueue.main.async {
                    self?.newsCollectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching news: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Delegate
extension NewsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Int(ceil(Double(newsItems.count) / 5.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let startIndex = section * 5
        let endIndex = min(startIndex + 5, newsItems.count)
        return endIndex - startIndex
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else { return UICollectionViewCell() }
        
        let itemIndex = indexPath.section * 5 + indexPath.row
        cell.backgroundColor = .cell.lightGray
        cell.layer.cornerRadius = Constants.radius.px10
        
        cell.configure(with: newsItems[itemIndex])
        
        if selectedIndexPaths.contains(indexPath) {
            cell.titleLabel.textColor = .text.red
        } else {
            cell.titleLabel.textColor = .text.black
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPaths.insert(indexPath)
        collectionView.reloadItems(at: [indexPath])
        
        let itemIndex = indexPath.section * 5 + indexPath.row

        if newsItems[itemIndex].title == "[Removed]" && newsItems[itemIndex].source.name == "[Removed]" {
            let alert = UIAlertController(title: "알림", message: "이 뉴스는 삭제되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            webView(from: self, urlString: newsItems[itemIndex].url ?? "", newsTitle: newsItems[itemIndex].title ?? "")
        }
    }
}
