//
//  InnerHtmlParserManager.swift
//  MyNewsPaper
//
//  Created by 박성영 on 30/03/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit
import SwiftSoup


class InnerHtmlParserManager {
    
    let imageTransfer = ImageTransferManager()
    let keyWordsMaker = KeyWordsManager()
    
    func innerParsing(_ elements : NSMutableDictionary) -> NewsModel?{
        var rssItem : NewsModel?
        var urlPath = (elements.object(forKey: "link") as? String)!
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let title = (elements.object(forKey: "title") as? String)!
     
        
        if let url = URL(string: urlPath){
            do{
                let data = try Data(contentsOf: url)
                var urlContent = String(data: data, encoding: .utf8)
                if urlContent != nil {
                    print("make News")
                    urlContent = urlContent?.trimmingCharacters(in: .whitespaces)
                    let parseResult = self.parseHtml(urlContent! as NSString)
                    
                    let thumbnailURL = (parseResult!.object(forKey: "thumbnail") as! String)
                    let description = (parseResult!.object(forKey: "description") as! String)
                    let keyWords = (parseResult!.object(forKey: "keywords") as! [String])
                    
                    let thumbnail = self.imageTransfer.makeUIImage(thumbnailURL)
                    rssItem = NewsModel(thumbnail: thumbnail, title: title, link: url, description: description, keyWord: keyWords)
                    return rssItem
//                    if thumbnailURL != "" {
//                        let thumbnailURL = URL(string: thumbnailURL)
//                        var thumbnail = UIImage()
//                        do {
//                            let data = try Data(contentsOf: thumbnailURL!)
//                            thumbnail = UIImage(data: data)!
//                            thumbnail = self.imageTransfer.resizeImage(image: thumbnail, toTheSize: CGSize(width: 70, height: 70))
//                        } catch{
//                            print("thumbnail URL 오류")
//                            rssItem = NewsModel(thumbnail: UIImage(), title: title, link: url as URL?, description: description, keyWord: keyWords)
//                        }
//                        rssItem = NewsModel(thumbnail: thumbnail, title: title, link: url as URL?, description: description, keyWord: keyWords)
//                        return rssItem!
//                    }
//                    else {
//                        rssItem = NewsModel(thumbnail: UIImage(), title: title, link: url as URL?, description: description, keyWord: keyWords)
//                        return rssItem!
//                    }
                }
                else{
                    //print(url)
                    print("no Contents")
                    rssItem = NewsModel(thumbnail: UIImage(), title: title, link: url as URL?, description: "", keyWord: [])
                    return rssItem!
                }
            }catch {
                print(error)
            }
        }
        return nil
    }
    

    func parseHtml(_ urlContent : NSString) -> NSMutableDictionary? {
        let result = NSMutableDictionary()
        var img = ""
        var description = ""
        var keyWords : [String] = []
        do {
            let doc : Document = try SwiftSoup.parse(urlContent as String)
            let meta : [Element] = try doc.select("meta").array()
            var thumbnailFlag = 0
            var descriptionFlag = 0
            for i in meta{
                let property = try i.attr("property")
                if property == "og:image" && thumbnailFlag == 0{
                    thumbnailFlag = 1
                     img = (try i.attr("content").addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))!
//                    print("img",img)
//                    print(urlContent)
                    result.setObject(img, forKey: "thumbnail" as NSCopying)
                }
                else if property == "og:description" && descriptionFlag == 0{
                    descriptionFlag = 1
                    description = try i.attr("content").trimmingCharacters(in: .whitespacesAndNewlines)
                    if description != ""{
                        keyWords = keyWordsMaker.makeKeyWords(description)
                        result.setObject(description, forKey: "description" as NSCopying)
                        result.setObject(keyWords, forKey: "keywords" as NSCopying)
                    }
                }
//                if result.count == 3{
////                    print("전달")
//                    return result
//                }
            }
            
        }catch {
            print(error.localizedDescription)
            
        }
        result.setObject(description, forKey: "description" as NSCopying)
        result.setObject(keyWords, forKey: "keywords" as NSCopying)
        result.setObject(img, forKey: "thumbnail" as NSCopying)
        
        return result
    }
    
    
    
    
    
}
