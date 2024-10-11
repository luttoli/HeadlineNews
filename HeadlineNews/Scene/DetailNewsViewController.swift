//
//  DetailNewsViewController.swift
//  HeadlineNews
//
//  Created by 김지훈 on 10/10/24.
//

import UIKit

import SnapKit
import WebKit

class DetailNewsViewController: UIViewController, WKNavigationDelegate {
    // MARK: - Properties
    var url: URL?
    var newsTitle: String?
    
    // MARK: - Components
    private var webView: WKWebView!
    
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
        
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.allowsPictureInPictureMediaPlayback = true
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.navigationDelegate = self
        
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        navigationUI()
        setUp()
    }
}

// MARK: - Navigation
extension DetailNewsViewController {
    func navigationUI() {
        navigationController?.navigationBar.barTintColor = .background.white

        let titleLabel = CustomLabel(title: self.newsTitle ?? "", size: Constants.size.size14, weight: .SemiBold, color: .text.black)
        navigationItem.titleView = titleLabel
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .text.black
    }
}

// MARK: - SetUp
private extension DetailNewsViewController {
    func setUp() {
        view.addSubview(webView)
        
        webView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
