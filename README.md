# HeadlineNews

### Tech stack
- SnapKit
- Alamofire
- Realm

### 세로모드, 가로모드 UI 설정하기

- 한 개의 collectionView를 사용하여 가로모드 시 UICollectionViewCompositionalLayout 사용하여 섹션마다 다른 레이아웃 구성
- 가로모드 시 cell 크기 300 * 120 설정
- title, urlToImage, publishedAt, name을 사용하여 UI 구성
    * title: 세줄 이상 시 말줄임 처리
    * urlToImage: 이미지 url 표시, 이미지 없는 경우 기본 이미지 추가
    * publishedAt: ko date로 변환 후 원하는 dateFormat로 출력
    * name: 가로모드 + 세로모드에서도 긴 경우가 있어 한 줄 이상 시 말줄임 처리 

<img src="https://github.com/user-attachments/assets/1d9bc8ef-fd59-4bb7-a3d3-4b00d9b6ff1a" height="300"/>

![IMG_0984](https://github.com/user-attachments/assets/76ecb59e-96ba-4e63-ad21-565439de0b63)

```swift
if isLandscape {
    let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(Constants.size.size300), heightDimension: .absolute(Constants.size.size120))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(Constants.size.size300 * 5 + 10 * 4), heightDimension: .absolute(Constants.size.size120))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    group.interItemSpacing = .fixed(10)
    
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
    section.orthogonalScrollingBehavior = .continuous
    return section
```

### alamofire 사용해서 데이터 받아오기 < Realm 사용해서 오프라인 시 저장된 데이터 사용하기

```swift
func fetchNewsData(completion: @escaping (Result<[Article], Error>) -> Void) {
    let url = "https://newsapi.org/v2/top-headlines?country=us&apiKey={apikey}"
    
    AF.request(url, method: .get).responseDecodable(of: News.self) { response in
        switch response.result {
        case .success(let newsResponse):
            completion(.success(newsResponse.articles))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
```

```swift
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
```
<img src="https://github.com/user-attachments/assets/f3cc066e-6023-4f5e-b112-f2fefe40f248" height="300"/>

### 한번 진입했던 cell의 title text 컬러 red로 변경하기 (DetailNewsVC < WebView, Navibar 세팅)

```swift
if selectedIndexPaths.contains(indexPath) {
    cell.titleLabel.textColor = .text.red
} else {
    cell.titleLabel.textColor = .text.black
}
```
<img src="https://github.com/user-attachments/assets/0a53daa2-01bb-4b10-a11e-aa10f51d3a92" height="300"/>

### Removed된 데이터 접근 시 얼럿 노출 설정하기 

```swift
if newsItems[itemIndex].title == "[Removed]" && newsItems[itemIndex].source.name == "[Removed]" {
    let alert = UIAlertController(title: "알림", message: "이 뉴스는 삭제되었습니다.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
} else {
    webView(from: self, urlString: newsItems[itemIndex].url ?? "", newsTitle: newsItems[itemIndex].title ?? "")
}
```
<img src="https://github.com/user-attachments/assets/e75b715a-695f-4de0-abea-1bcf830f4120" height="300"/>

### project setting
- light 모드 설정
- PretendardVariable font 적용
- CustomLabel, Constants 설정으로 코드 수정 용이
- Extension 세팅
