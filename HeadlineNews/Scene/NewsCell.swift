//
//  NewsCell.swift
//  HeadlineNews
//
//  Created by 김지훈 on 10/8/24.
//

import UIKit

class NewsCell: UICollectionViewCell {
    // MARK: - Components
    var urlImage = UIImageView()
    var titleLabel = CustomLabel(title: "", size: Constants.size.size14, weight: .Regular, color: .text.black)
    var nameLabel = CustomLabel(title: "", size: Constants.size.size12, weight: .Regular, color: .text.darkGray)
    var publishedAtLabel = CustomLabel(title: "", size: Constants.size.size12, weight: .Regular, color: .text.darkGray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension NewsCell {
    func setUp() {
        contentView.addSubview(urlImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(publishedAtLabel)
        
        urlImage.snp.makeConstraints {
            $0.centerY.equalTo(contentView.safeAreaLayoutGuide)
            $0.leading.equalTo(contentView.safeAreaLayoutGuide).offset(Constants.spacing.px10)
            $0.width.equalTo(Constants.size.size120)
            $0.height.equalTo(Constants.size.size100)
        }
        urlImage.tintColor = .image.darkGray
        urlImage.clipsToBounds = true
        urlImage.layer.cornerRadius = Constants.radius.px6
        urlImage.contentMode = .scaleAspectFill
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(urlImage.snp.top).offset(Constants.spacing.px4)
            $0.leading.equalTo(urlImage.snp.trailing).offset(Constants.spacing.px10)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-Constants.spacing.px10)
        }
        titleLabel.numberOfLines = 3
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(urlImage.snp.trailing).offset(Constants.spacing.px10)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-Constants.spacing.px10)
            $0.bottom.equalTo(publishedAtLabel.snp.top)
        }
        nameLabel.numberOfLines = 1
        
        publishedAtLabel.snp.makeConstraints {
            $0.bottom.equalTo(urlImage.snp.bottom).offset(-Constants.spacing.px4)
            $0.leading.equalTo(urlImage.snp.trailing).offset(Constants.spacing.px10)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-Constants.spacing.px10)
        }
    }
}

// MARK: - Method
extension NewsCell {
    func configure(with article: Article) {
        titleLabel.text = article.title
        nameLabel.text = article.source.name ?? ""
        publishedAtLabel.text = article.publishedAt?.toDate()?.toStringDetail()

        if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        self.urlImage.image = UIImage(data: data)
                    }
                }
            }.resume()
        } else {
            urlImage.image = UIImage(systemName: "newspaper")
        }
    }
}
