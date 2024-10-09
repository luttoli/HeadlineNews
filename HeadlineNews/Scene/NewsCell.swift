//
//  NewsCell.swift
//  HeadlineNews
//
//  Created by 김지훈 on 10/8/24.
//

import UIKit

class NewsCell: UICollectionViewCell {
    // MARK: - Components
    var label = CustomLabel(title: "", size: Constants.size.size14, weight: .Regular, color: .text.black)
    
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
        contentView.addSubview(label)
        
        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
