//
//  NewsTableViewModel.swift
//  MyNewsPaper
//
//  Created by 박성영 on 19/03/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

protocol NewsTableProtocol {
    var newsFeed : NewsModel? { get }
    var newsFeedDidChange: ((NewsTableProtocol) -> ())? { get set }
    
    init(news: [NewsModel])
    //func back(completion:@escaping () -> Swift.Void)  //뒤로가기 버튼 누를시 출력
    
    func cellInstance(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    
    func getNews(indexPath : IndexPath)
    
}

public class NewsTableViewModel : NewsTableProtocol{
    var news : [NewsModel] = []
    
    var newsFeed: NewsModel? {
        didSet {
            print("model 바뀜")
            self.newsFeedDidChange?(self)
        }
    }
    
    var newsFeedDidChange: ((NewsTableProtocol) -> ())?
    
    func getNews(indexPath: IndexPath) {
        newsFeed = news[indexPath.row]
    }
    
    required init(news : [NewsModel]){
        self.news = news
    }
    
//    func back(completion: @escaping () -> Void) { //뒤로가기 누르면 출력
//        print(#function)
//        completion()
//    }
    
    
    func cellInstance(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell
        let cellImageLayer: CALayer?  = cell.thumbnailImageView.layer
        cell.accessibilityIdentifier = "newsCell_\(indexPath.row)"
        //이미지를 동그라미로 표현하기 위함
        cellImageLayer!.cornerRadius = 35
        cellImageLayer!.masksToBounds = true
        getNews(indexPath: indexPath)
        cell.setUp(self)
        return cell
    }
    
}
