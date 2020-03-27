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
    
    var result : [String:String] = [:]
    // let urlPath : String?
    // let url : NSURL?
    private var parserCompletionHandler: (([String:String]) ->Void)?
    func parseFeed(_ link : String , completionHandler: (([String:String]) -> Void)?){
        self.parserCompletionHandler = completionHandler
        
        let url = NSURL(string: link)
        
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 5
        session.configuration.timeoutIntervalForResource = 5
        let task = session.dataTask(with: url! as URL,completionHandler: {(data, response, error) -> Void in
            if error == nil {
                let urlContent = NSString(data: data! , encoding: String.Encoding.utf8.rawValue)
                print("확인//////")
                if urlContent != nil {
                    let thumbnail = self.parseHtml(urlContent!)
                    let description = self.parseDescription(urlContent!)
                    self.result.updateValue(thumbnail, forKey: "thumbnail")
                    self.result.updateValue(description, forKey: "description")
                }
                else {
                    print("불러오기 실패")
                }
            }else{
                print(error?.localizedDescription as Any)
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
    
    
    func parseDescription(_ urlContent : NSString) ->String{
        do {
            let doc : Document = try! SwiftSoup.parse(urlContent as String)
            
            let meta : [Element] = try doc.select("meta").array()
            for i in meta{
                let property = try i.attr("property")
                if property == "og:description"{
                    let description = try i.attr("content")
                    return description
                }
            }
        }catch {
            print(error.localizedDescription)
            
        }
        return ""
    }
    
}
