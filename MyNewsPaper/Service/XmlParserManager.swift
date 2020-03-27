//
//  XmlParserManager.swift
//  MyNewsPaper
//
//  Created by 박성영 on 20/03/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

//import Foundation
import UIKit

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
        print("wait",rssItems.count)
        for num in 0...rssItems.count-1{
            let request2 = URLRequest(url: URL(string: rssItems[num].link!)!)
            let task2 = urlSession.dataTask(with: request2) { (data,  response, error) in
                guard let data = data else{
                    if let error = error{
                        print(error.localizedDescription)
                    }
                    return
                }
                let url = NSURL(string: self.rssItems[num].link!)
                let parser = XMLParser(contentsOf: url! as URL)!
                parser.delegate = self
                parser.parse()
                self.rssItems[num].thumbnail = self.thumbnail
                self.thumbnail = ""
                semaphore.signal()
            }
            task2.resume()
            semaphore.wait()
        }
        
        parserCompletionHandler?(rssItems)
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
                print(attributeDict)
                thumbnail = attributeDict["content"]!
            }
        }
    }
    
    // 현재 테그에 담겨있는 문자열 전달
    func parser(_ parser: XMLParser, foundCharacters string: String) {
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
        
        if (elementName as NSString).isEqual(to: "item") {
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

