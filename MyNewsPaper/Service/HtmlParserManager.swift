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
    
    func parseHtml(_ url : String) ->String{
        let itemListURL = URL(string: url)
        let itemListHTML = try? String(contentsOf: itemListURL!, encoding: .isoLatin1)
        if itemListHTML?.contains("og:image\" content=\"") == true {
            let itemURL = URL(string: itemListHTML!.slice(from: "og:image\" content=\"", to: "\"")!)!
            return itemURL.absoluteString
        }
        return ""
    }
    
    
}

