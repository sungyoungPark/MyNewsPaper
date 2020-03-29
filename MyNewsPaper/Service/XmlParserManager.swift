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

class XmlParserManager : NSObject , XMLParserDelegate {
    
    var parser = XMLParser()
    var imageTransfer = ImageTransferManager()
    private var rssItems : [NewsModel] = []
    
    var feeds = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var ftitle = NSMutableString()
    var link = NSMutableString()
    var img : [String] = []
    var fdescription = NSMutableString()
    var fdate = NSMutableString()
    
    var innerXmlImageURL = ""
    
    func allFeeds() -> NSMutableArray {
        return feeds
    }
    
    private var parserCompletionHandler: (([NewsModel]) ->Void)?
    
    func parseFeed( url : String, completionHandler: (([NewsModel]) -> Void)?) {
        
        self.parserCompletionHandler = completionHandler
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        //        urlSession.configuration.timeoutIntervalForRequest = 2
        //        urlSession.configuration.timeoutIntervalForResource = 2
        let task = urlSession.dataTask(with: request) { (data,  response, error) in
            guard let data = data else{
                if let error = error{
                    print(error.localizedDescription)
                }
                return
            }
            let parser = XMLParser(data: data)
            parser.shouldProcessNamespaces = true
            parser.shouldReportNamespacePrefixes = true
            parser.delegate = self
            parser.parse()
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        task.cancel()
        print("wait",feeds.count)
        var urlPath = ""
        for num in 0...feeds.count-1{
            urlPath = ((feeds.object(at: num) as AnyObject).object(forKey: "link") as? String)!
            urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
            urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let url = URL(string: urlPath)
            let title = (feeds.object(at: num) as AnyObject).object(forKey: "title") as? String
            let date = (feeds.object(at: num) as AnyObject).object(forKey: "pubDate") as? String
            
            let session = URLSession.shared
            
            let task2 = session.dataTask(with: url! as URL, completionHandler: {
                (data, response, error) -> Void in
                if error == nil {
                    let urlContent = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    if urlContent != nil{
                        urlContent?.trimmingCharacters(in: .whitespaces)
                        let parseResult = self.parseHtml(urlContent!)
                        if parseResult["thumbnail"] != nil {
                            let thumbnailURL = URL(string: parseResult["thumbnail"]!)
                            var thumbnail = UIImage()
                            do {
                                let data = try Data(contentsOf: thumbnailURL!)
                                thumbnail = UIImage(data: data)!
                                thumbnail = self.imageTransfer.resizeImage(image: thumbnail, toTheSize: CGSize(width: 70, height: 70))
                            } catch{
                                print("thumbnail URL 오류")
                            }
                            
                            let rssItem = NewsModel(thumbnail: thumbnail, title: title, date: date, link: url as URL?, description: parseResult["description"])
                            self.rssItems.append(rssItem)
                        }
                        else {
                            //                            print(urlPath)
                            //                            print(title ," no Thumbnail")
                            let rssItem = NewsModel(thumbnail: UIImage(), title: title, date: date, link: url as URL?, description: parseResult["description"])
                            self.rssItems.append(rssItem)
                        }
                    }
                    else{
                        print(urlPath)
                        print("no Contents")
                        //                        let rssItem = NewsModel(thumbnail: UIImage(), title: title, date: date, link: url as URL?)
                        //                        self.rssItems.append(rssItem)
                        //                        let parser = XMLParser(data: data!)
                        //                        parser.delegate = self
                        //                        parser.parse()
                        //                        if self.innerXmlImageURL != ""{
                        //                            let thumbnailURL = URL(string: self.innerXmlImageURL)
                        //                            let data = try? Data(contentsOf: thumbnailURL!)
                        //                            var thumbnail = UIImage(data: data!)
                        //                            thumbnail = self.imageTransfer.resizeImage(image: thumbnail!, toTheSize: CGSize(width: 70, height: 70))
                        //
                        //                            let rssItem = NewsModel(thumbnail: UIImage(), title: title, date: date, link: url as URL?)
                        //                            self.rssItems.append(rssItem)
                        //                            self.innerXmlImageURL = ""
                        //                        }
                        //                        else{
                        //                            let rssItem = NewsModel(thumbnail: UIImage(), title: title, date: date, link: url as URL?)
                        //                            self.rssItems.append(rssItem)
                        //                        }
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
    
    func parseHtml(_ urlContent : NSString) -> [String:String] {
        var result : [String:String] = [:]
        do {
            let doc : Document = try SwiftSoup.parse(urlContent as String)
            let meta : [Element] = try doc.select("meta").array()
            for i in meta{
                let property = try i.attr("property")
                if property == "og:image"{
                    let img = (try i.attr("content").addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))!
                    result.updateValue(img, forKey: "thumbnail")
                }
                else if property == "og:description"{
                    let description = try i.attr("content")
                    result.updateValue(description, forKey: "description")
                }
                if result.count == 2{
                    return result
                }
            }
            
        }catch {
            print(error.localizedDescription)
            
        }
        return result
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
                print("meta image 찾음")
                innerXmlImageURL = attributeDict["content"]!
                parser.abortParsing()
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
            if ftitle != "" {
                elements.setObject(ftitle, forKey: "title" as NSCopying)
            }
            if link != "" {
                elements.setObject(link, forKey: "link" as NSCopying)
            }
            if fdate != "" {
                elements.setObject(fdate, forKey: "pubDate" as NSCopying)
            }
            feeds.add(elements)
        }
    }
    
    //    func parserDidEndDocument(_ parser: XMLParser) {
    //        parserCompletionHandler?(rssItems)
    //    }
    
    //    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
    //        print(parseError.localizedDescription)
    //    }
    
}
