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
    var linkDidChange: ((NewsItemProtocol) -> ())? { get set }
    init(url : URL)
}

public class NewsItemViewModel : NewsItemProtocol{
    var selectedNewsURL = ""
    
    required init(url: URL) {
//        selectedNewsURL = url.replacingOccurrences(of: " ", with:"")
//        selectedNewsURL = selectedNewsURL.replacingOccurrences(of: "\n", with:"")
//        link = URL(string: selectedNewsURL as String)!
        link = url
    }
    
    var link: URL?{
        didSet {
            print("변경")
            self.linkDidChange?(self)
        }
    }
    
    var linkDidChange: ((NewsItemProtocol) -> ())?
    
    
    
    
}
