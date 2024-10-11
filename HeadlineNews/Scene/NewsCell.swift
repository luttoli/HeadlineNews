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
    var title = CustomLabel(title: "", size: Constants.size.size14, weight: .Regular, color: .text.black)
    var name = CustomLabel(title: "", size: Constants.size.size12, weight: .Regular, color: .text.darkGray)
    var publishedAt = CustomLabel(title: "", size: Constants.size.size12, weight: .Regular, color: .text.darkGray)
    
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
        contentView.addSubview(title)
        contentView.addSubview(name)
        contentView.addSubview(publishedAt)
        
        urlImage.snp.makeConstraints {
            $0.centerY.equalTo(contentView.safeAreaLayoutGuide)
            $0.leading.equalTo(contentView.safeAreaLayoutGuide).offset(Constants.spacing.px10)
            $0.width.height.equalTo(Constants.size.size120)
            $0.height.equalTo(Constants.size.size100)
        }
        urlImage.tintColor = .image.darkGray
        urlImage.clipsToBounds = true
        urlImage.layer.cornerRadius = Constants.radius.px6
        urlImage.contentMode = .scaleAspectFill
        
        title.snp.makeConstraints {
            $0.top.equalTo(urlImage.snp.top).offset(Constants.spacing.px4)
            $0.leading.equalTo(urlImage.snp.trailing).offset(Constants.spacing.px10)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-Constants.spacing.px10)
        }
        title.numberOfLines = 3
        
        name.snp.makeConstraints {
            $0.leading.equalTo(urlImage.snp.trailing).offset(Constants.spacing.px10)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-Constants.spacing.px10)
            $0.bottom.equalTo(publishedAt.snp.top)
        }
        
        publishedAt.snp.makeConstraints {
            $0.bottom.equalTo(urlImage.snp.bottom).offset(-Constants.spacing.px4)
            $0.leading.equalTo(urlImage.snp.trailing).offset(Constants.spacing.px10)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-Constants.spacing.px10)
        }
    }
}
