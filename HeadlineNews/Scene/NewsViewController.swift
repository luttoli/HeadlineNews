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
            // 가로 모드
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(Constants.size.size300), heightDimension: .absolute(Constants.size.size120))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(Constants.size.size300 * 5 + 20), heightDimension: .absolute(Constants.size.size120))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(5)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0)
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        } else {
            // 세로 모드
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 5)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
    
    func fetchNewsData() {
        let urls = "https://newsapi.org/v2/top-headlines?country=us&apiKey=9c786eb5cd5a4ea48ebf3dcc22bc1884"
        guard let url = URL(string: urls) else { return }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print("Error fetching news: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data found")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let newsResponse = try decoder.decode(News.self, from: data)
                
                DispatchQueue.main.async {
                    self?.newsItems = newsResponse.articles
                    self?.newsCollectionView.reloadData()
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        dataTask.resume()
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
        
        let article = newsItems[itemIndex]    
        
        cell.title.text = article.title
        cell.name.text = article.source.name ?? "Unknown Author"
        cell.publishedAt.text = article.publishedAt?.toDate()?.toStringDetail()

        // 이미지 로딩
        if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        if let updateCell = collectionView.cellForItem(at: indexPath) as? NewsCell {
                            updateCell.urlImage.image = UIImage(data: data)
                        }
                    }
                }
            }.resume()
        } else {
            cell.urlImage.image = UIImage(systemName: "newspaper")
        }
        
        if selectedIndexPaths.contains(indexPath) {
            cell.title.textColor = .text.red
        } else {
            cell.title.textColor = .text.black
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPaths.insert(indexPath)
        collectionView.reloadItems(at: [indexPath])
        
        let itemIndex = indexPath.section * 5 + indexPath.row
        let article = newsItems[itemIndex]
        webView(from: self, urlString: article.url ?? "", newsTitle: article.title ?? "")
    }
}
