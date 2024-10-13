//
//  NewsArticle.swift
//  HeadlineNews
//
//  Created by 김지훈 on 10/12/24.
//

import UIKit

import RealmSwift

class NewsArticle: Object {
    @Persisted var title: String? = nil
    @Persisted var urlToImage: String? = nil
    @Persisted var publishedAt: String? = nil
    @Persisted var url: String? = nil
    @Persisted var sourceName: String? = nil
    @Persisted var imageData: Data? = nil
    
    override static func primaryKey() -> String? {
        return "url"
    }
}
