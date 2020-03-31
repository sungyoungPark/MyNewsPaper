//
//  NewsItemViewModel.swift
//  MyNewsPaper
//
//  Created by 박성영 on 22/03/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import Foundation

protocol NewsItemProtocol {
    var link : URL? { get }
    var title : String { get }
    var keyWord : String { get }
    
    var linkDidChange: ((NewsItemProtocol) -> ())? { get set }
    init(news : NewsModel)
}

public class NewsItemViewModel : NewsItemProtocol{
 
    var title: String
    
    var keyWord: String
    
    var selectedNewsURL = ""
    
    required  init(news : NewsModel) {
        link = news.link
        title = news.title!
        if news.keyWord!.count != 0{
            var keywords = ""
            for i in news.keyWord!{
                keywords.append(i + "   ")
            }
            keyWord = keywords
        }
        else{
            keyWord = ""
        }
    }
    
    var link: URL?{
        didSet {
            print("변경")
            self.linkDidChange?(self)
        }
    }
    
    var linkDidChange: ((NewsItemProtocol) -> ())?
    
    
    
    
}
