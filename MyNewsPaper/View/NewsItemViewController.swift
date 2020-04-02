//
//  NewsItemViewController.swift
//  MyNewsPaper
//
//  Created by 박성영 on 22/03/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit
import WebKit
//protocol NewsItemViewControllerProtocol {
//    var viewModel: NewsItemViewModel { get set }
//
//}

class NewsItemViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    @IBOutlet var webViewTitle: UILabel!
    @IBOutlet var webViewKeyWord: UILabel!
    
    var viewModel : NewsItemViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello")
        print((viewModel?.link) as Any )
        webView.load(URLRequest(url: viewModel!.link!))
        webViewTitle.text = viewModel?.title
        webViewKeyWord.text = viewModel?.keyWord
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated )
    }
    
}
