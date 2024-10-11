//
//  NewsService.swift
//  HeadlineNews
//
//  Created by 김지훈 on 10/11/24.
//

import UIKit

import Alamofire

class NewsService {
    static let shared = NewsService()
    
    private init() {}
    
    func fetchNewsData(completion: @escaping (Result<[Article], Error>) -> Void) {
        let url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=9c786eb5cd5a4ea48ebf3dcc22bc1884"
        
        AF.request(url, method: .get).responseDecodable(of: News.self) { response in
            switch response.result {
            case .success(let newsResponse):
                completion(.success(newsResponse.articles))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
