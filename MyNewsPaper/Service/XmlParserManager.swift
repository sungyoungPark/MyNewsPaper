//
//  XmlParserManager.swift
//  MyNewsPaper
//
//  Created by 박성영 on 20/03/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

//import Foundation
import UIKit
import SwiftSoup

class XmlParserManager : NSObject , XMLParserDelegate{
    
    var parser = XMLParser()
    var htmlParser = HtmlParserManager()
    private var rssItems : [NewsModel] = []
    
    var feeds = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var ftitle = NSMutableString()
    var link = NSMutableString()
    var img : [String] = []
    var fdescription = NSMutableString()
    var fdate = NSMutableString()
    
    var thumbnail = ""
    
    func allFeeds() -> NSMutableArray {
        return feeds
    }
    
    private var parserCompletionHandler: (([NewsModel]) ->Void)?
    
    func parseFeed( url : String, completionHandler: (([NewsModel]) -> Void)?) {
        
        self.parserCompletionHandler = completionHandler
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data,  response, error) in
            guard let data = data else{
                if let error = error{
                    print(error.localizedDescription)
                }
                return
            }
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        task.cancel()
        print("wait",rssItems.count)
        var urlPath = ""
        for num in 0...rssItems.count-1{
            urlPath = rssItems[num].link!
            let url = NSURL(string: urlPath)
            
            let session = URLSession.shared
            
            let task2 = session.dataTask(with: url! as URL, completionHandler: {
                (data, response, error) -> Void in
                
                if error == nil {
                    let urlContent = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    urlContent?.trimmingCharacters(in: .whitespaces)
                    if urlContent != nil{
                        self.rssItems[num].thumbnail = self.parseHtml(urlContent!)
                    }
                    else{
                        print("no Contents")
                    }
                }else{
                    print("error occured")
                }
                semaphore.signal()
            })
            task2.resume()
            semaphore.wait()
            task2.cancel()
        }
        
        parserCompletionHandler?(rssItems)
    }
    
    func parseHtml(_ urlContent : NSString) -> String {
        do {
            
            let doc : Document = try SwiftSoup.parse(urlContent as String)
            
            let meta : [Element] = try doc.select("meta").array()
            for i in meta{
                let property = try i.attr("property")
                if property == "og:image"{
                    let img = (try i.attr("content").addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))!
                    return img
                }
            }
            
        }catch {
            print(error.localizedDescription)
            
        }
        return ""
    }
    
    
    //xmlParserDelegate 함수
    // XML 파서가 시작 테그를 만나면 호출됨
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName as NSString
        if (element as NSString).isEqual(to: "item") {
            elements =  NSMutableDictionary()
            elements = [:]
            ftitle = NSMutableString()
            ftitle = ""
            link = NSMutableString()
            link = ""
            fdescription = NSMutableString()
            fdescription = ""
            fdate = NSMutableString()
            fdate = ""
        }
        else if (element as NSString).isEqual(to: "meta"){
            if attributeDict["property"] == "og:image"{
                //print(attributeDict)
                thumbnail = attributeDict["content"]!
            }
        }
    }
    
    // 현재 테그에 담겨있는 문자열 전달
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //print("String", string)
        if element.isEqual(to: "title") {
            ftitle.append(string)
        } else if element.isEqual(to: "link") {
            link.append(string)
        } else if element.isEqual(to: "pubDate") {
            fdate.append(string)
        }
    }
    
    // XML 파서가 종료 테그를 만나면 호출됨
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        //print("element",elementName)
        if (elementName as NSString).isEqual(to: "item") {
            thumbnail = ""
            let rssItem = NewsModel(thumbnail: thumbnail, title: ftitle as String, date: fdate as String, link: link as String)
            self.rssItems.append(rssItem)
        }
    }
    
    //    func parserDidEndDocument(_ parser: XMLParser) {
    //        parserCompletionHandler?(rssItems)
    //    }
    
    //    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
    //        print(parseError.localizedDescription)
    //    }
    
}

