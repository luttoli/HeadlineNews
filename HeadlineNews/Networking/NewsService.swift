//
//  NewsService.swift
//  HeadlineNews
//
//  Created by 김지훈 on 10/11/24.
//

import UIKit

import Alamofire
import RealmSwift

class NewsService {
    static let shared = NewsService()
    
    private init() {}
    
    let realm = try! Realm()
    
    func fetchNewsData(completion: @escaping (Result<[Article], Error>) -> Void) {
        let url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=9c786eb5cd5a4ea48ebf3dcc22bc1884"
        
        AF.request(url, method: .get).responseDecodable(of: News.self) { response in
            switch response.result {
            case .success(let newsRespon):
                completion(.success(newsRespon.articles))
                self.saveArticlesToRealm(articles: newsRespon.articles)
                
            case .failure(let error):
                let savedArticles = self.loadArticlesFromRealm()
                if !savedArticles.isEmpty {
                    completion(.success(savedArticles))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func saveArticlesToRealm(articles: [Article]) {
        try! realm.write {
            for article in articles {
                let newsArticle = NewsArticle()
                newsArticle.title = article.title
                newsArticle.urlToImage = article.urlToImage
                newsArticle.publishedAt = article.publishedAt
                newsArticle.url = article.url
                newsArticle.sourceName = article.source.name
                newsArticle.imageData = article.urlToImage?.data(using: .utf8)

                realm.add(newsArticle, update: .modified)
            }
        }
    }
    
    private func loadArticlesFromRealm() -> [Article] {
        let newsArticles = realm.objects(NewsArticle.self)
        return newsArticles.map { newsArticleToArticle($0) }
    }
    
    private func newsArticleToArticle(_ newsArticle: NewsArticle) -> Article {
        return Article(
            title: newsArticle.title,
            urlToImage: newsArticle.urlToImage,
            publishedAt: newsArticle.publishedAt,
            url: newsArticle.url,
            source: Source(name: newsArticle.sourceName)
        )
    }
}
