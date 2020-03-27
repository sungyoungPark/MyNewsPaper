//
//  HtmlParserManager.swift
//  MyNewsPaper
//
//  Created by 박성영 on 24/03/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import Foundation

extension String {
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

class HtmlParserManager{
    
    func parseFeed(_ link : String, completionHandler: ((NewsModel) -> Void)?){
        let url = NSURL(string: link)
        let session = URLSession.shared
        
        let task = session.dataTask(with: url! as URL,completionHandler: {(data, response, error) -> Void in
            if error == nil {
                let urlContent = NSString(data: data! , encoding: String.Encoding.utf8.rawValue)
                print("확인//////")
                if urlContent != nil {
                    print(urlContent)
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
    
    
    
    
    func parseHtml(_ url : String) ->String{
        let itemListURL = URL(string: url)
        let itemListHTML = try? String(contentsOf: itemListURL!, encoding: .utf8)
        if itemListHTML?.contains("og:image\" content=\"") == true {
            let itemURL = URL(string: itemListHTML!.slice(from: "og:image\" content=\"", to: "\"")!)!
            return itemURL.absoluteString
        }
        return ""
    }
    
    
}

