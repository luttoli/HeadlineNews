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
    
    let detailNewsViewController = DetailNewsViewController()
    detailNewsViewController.url = url
    detailNewsViewController.newsTitle = newsTitle
    
    viewController.navigationController?.pushViewController(detailNewsViewController, animated: true)
}
