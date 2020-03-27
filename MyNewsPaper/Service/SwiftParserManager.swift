//
//  SwiftSoupParserManager.swift
//  MyNewsPaper
//
//  Created by 박성영 on 26/03/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import Foundation
import SwiftSoup

class SwiftSoupParserManager {
    
   // let urlPath : String?
   // let url : NSURL?
    
    //init(_ urlPath : String) {
    func parseFeed(_ news : NewsModel, completionHandler: ((NewsModel) -> Void)?){
        var news = news
        let urlPath = news.link
        let url = NSURL(string: urlPath!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: url! as URL,completionHandler: {(data, response, error) -> Void in
            if error == nil {
                let urlContent = NSString(data: data! , encoding: String.Encoding.utf8.rawValue)
                print("확인//////")
                if urlContent != nil {
                    news.thumbnail = self.parseHtml(urlContent!)
                    print(news.thumbnail)
                }
                else {
                    print("불러오기 실패")
                }
            }else{
                print(error?.localizedDescription)
                print("error occured")
            }
            
        })
        task.resume()
    }
    
    
    func parseHtml(_ urlContent : NSString) -> String {
        do {
           
            let doc : Document = try SwiftSoup.parse(urlContent as String)
            
            let meta : [Element] = try doc.select("meta").array()
            for i in meta{
                let property = try i.attr("property")
                if property == "og:image"{
                    let img = try i.attr("content")
                    return img
                }
            }
            
        }catch {
            print(error.localizedDescription)
            
        }
        return ""
    }
    
    
    func parseDescription(_ urlContent : NSString){
        do {
            let doc : Document = try! SwiftSoup.parse(urlContent as String)
            
            let meta : [Element] = try doc.select("meta").array()
            for i in meta{
                let property = try i.attr("property")
                if property == "og:description"{
                    let description = try i.attr("content")
                    print(description)
                    return
                }
                
            }
            
        }catch {
            print(error.localizedDescription)
            
        }
    }
    
}
