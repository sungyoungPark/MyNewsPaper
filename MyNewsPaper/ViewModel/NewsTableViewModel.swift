//
//  NewsTableViewModel.swift
//  MyNewsPaper
//
//  Created by 박성영 on 19/03/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

protocol NewsTableProtocol {
    
    var title: String? { get }
    var titleDidChange: ((NewsTableProtocol) -> ())? { get set }
    
    var date : String? { get }
    var dateDidChange: ((NewsTableProtocol) -> ())? { get set }
    
    var thumbnail : String? { get }
    var thumbnailDidChange: ((NewsTableProtocol) -> ())? { get set }
    
    var newsFeed : NewsModel? { get }
    var newsFeedDidChange: ((NewsTableProtocol) -> ())? { get set }
    
    init(news: [NewsModel])
    func back(completion:@escaping () -> Swift.Void)  //뒤로가기 버튼 누를시 출력
    
    func cellInstance(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    
    func changeTitle(indexPath : IndexPath)
    
    func changeDate(indexPath : IndexPath)
    
    func changeNews(indexPath : IndexPath)
    
    func changeThumbnail(indexPath : IndexPath)
}

public class NewsTableViewModel : NewsTableProtocol{
    
    var newsFeed: NewsModel? {
        didSet {
            self.newsFeedDidChange?(self)
        }
    }
    
    var newsFeedDidChange: ((NewsTableProtocol) -> ())?
    
    func changeNews(indexPath: IndexPath) {
        newsFeed = news[indexPath.row]
    }
    

    var news : [NewsModel] = []
    
    required init(news : [NewsModel]){
        self.news = news
    }
    
    var title: String?{
        didSet {
            self.titleDidChange?(self)
        }
    }
    
    var titleDidChange: ((NewsTableProtocol) -> ())?
    
    var date: String? {
        didSet {
            self.dateDidChange?(self)
        }
    }
    
    var dateDidChange: ((NewsTableProtocol) -> ())?
    
    var thumbnail: String?{
        didSet{
            self.thumbnailDidChange?(self)
        }
    }
    
    var thumbnailDidChange: ((NewsTableProtocol) -> ())?
    
    func back(completion: @escaping () -> Void) { //뒤로가기 누르면 출력
        print(#function)
        completion()
    }
    
    func changeTitle(indexPath: IndexPath) {
        self.title = news[indexPath.row].title
    }
    
    func changeDate(indexPath: IndexPath) {
        self.date = news[indexPath.row].date
       }
    
    func changeThumbnail(indexPath: IndexPath) {
        self.thumbnail = news[indexPath.row].thumbnail
       }
    
    func cellInstance(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell
        //changeTitle(indexPath: indexPath)
        //changeDate(indexPath: indexPath)
        //changeThumbnail(indexPath: indexPath)
        changeNews(indexPath: indexPath)
        cell.setUp(self)
        return cell
    }
    
}
