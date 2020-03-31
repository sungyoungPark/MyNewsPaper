//
//  XmlParserManager.swift
//  MyNewsPaper
//
//  Created by 박성영 on 20/03/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

//import Foundation
import UIKit
import WebKit

class XmlParserManager : NSObject , XMLParserDelegate {
    
    var parser = XMLParser()
    var innerHtmlParser = InnerHtmlParserManager()
    let web = WKWebView()
    
    var elements = NSMutableDictionary()
    var element = NSString()
    var ftitle = NSMutableString()
    var link = NSMutableString()
    var fdate = NSMutableString()
    
    var completeParsing : [NewsModel] = []
    var failParsing = NSMutableArray() 
    var failLink : [String] = []
    var failTitle : [String] = []
    
    private var rssItems : [NewsModel] = []
    //var count = 1
    
    
    private var parserCompletionHandler: ((NewsModel) ->Void)?
    
    func parseFeed(_ data : Data){
            let parser = XMLParser(data: data)
            parser.shouldProcessNamespaces = true
            parser.shouldReportNamespacePrefixes = true
            parser.delegate = self
            print("파싱 시작")
            parser.parse()
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
            fdate = NSMutableString()
            fdate = ""
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
            //print(count)
            //count += 1
            if ftitle != "" {
                elements.setObject(ftitle, forKey: "title" as NSCopying)
            }
            if link != "" {
                elements.setObject(link, forKey: "link" as NSCopying)
            }
            if fdate != "" {
                elements.setObject(fdate, forKey: "pubDate" as NSCopying)
            }
            let rssItem = self.innerHtmlParser.innerParsing(elements)
            if rssItem != nil {
                completeParsing.append(rssItem!)
                parserCompletionHandler?(rssItem!)
            }
            else{
                //failParsing.add(elements)
                failLink.append(link as String)
                failTitle.append(link as String)
            }
            
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("xml parsing finish")
        //parserCompletionHandler?(rssItem)
    }
    
}
