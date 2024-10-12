//
//  WebView.swift
//  HeadlineNews
//
//  Created by 김지훈 on 10/10/24.
//

import UIKit

func webView(from viewController: UIViewController, urlString: String, newsTitle: String) {
    guard let url = URL(string: urlString) else {
        return
    }
    
    let detailNewsViewController = DetailNewsViewController(url: url, title: newsTitle)
    viewController.navigationController?.pushViewController(detailNewsViewController, animated: true)
}
