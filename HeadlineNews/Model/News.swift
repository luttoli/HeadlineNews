//
//  News.swift
//  HeadlineNews
//
//  Created by 김지훈 on 10/10/24.
//

import UIKit

struct News: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let title: String?
    let urlToImage: String?
    let publishedAt: String?
    let url: String?
    let source: Source
}

struct Source: Codable {
    let name: String?
}
