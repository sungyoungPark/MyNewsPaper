//
//  NewsTableViewController.swift
//  MyNewsPaper
//
//  Created by 박성영 on 19/03/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit
import WebKit

protocol NewsTableViewControllerProtocol {
    var viewModel: NewsTableViewModel { get set }
    func configure()
}

class NewsTableViewController: UITableViewController {
    
    var model = [NewsModel]()

    var web = WKWebView()
    var retryURL = ""
    //var retryModel = [NewsModel]()
    
    var innerHtmlParser = InnerHtmlParserManager()
    var imageTransfer = ImageTransferManager()
    var viewModel : NewsTableViewModel?
    var refreshControler = UIRefreshControl()
    let sema = DispatchSemaphore.init(value: 0)

    
    private var parserCompletionHandler: ((NewsModel) ->Void)?
    
    @IBOutlet weak var tv: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        web.navigationDelegate = self
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControler
        } else {
            tableView.addSubview(refreshControler)
        }
        refreshControler.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControler.attributedTitle = NSAttributedString(string: "새로고침")
        
        viewModel = NewsTableViewModel(news: model)
        
        fetchData(){ (result) in  //result는 [NewsModel] 최종적인 뉴스피드들 집합
            
            self.model = result
            
            OperationQueue.main.addOperation {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
                print(self.model.count)
            }
            
        }
        
        
    }
    
    
    @objc func refresh(){
        print("refresh")
        
        tableView.reloadData()
        self.refreshControler.endRefreshing()
    }
    
    
    func fetchData( completionHandler: (([NewsModel]) -> Void)?) {

        var result : [NewsModel] = []
//        completionHandler!(result)
        let feedParser = XmlParserManager()
        let url = "https://news.google.com/rss"
        let urlPath = URL(string: url)
        let request = URLRequest(url: urlPath!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data,  response, error) in
            guard let data = data else{
                if let error = error{
                    print(error.localizedDescription)
                }
                return
            }
            feedParser.parseFeed(data)
            print("짱짱맨")
            result = feedParser.completeParsing
            let failLink = feedParser.failLink
            let failTitle = feedParser.failTitle
            for i in 0...failLink.count-1{
                let request2 = URLRequest(url: URL(string: failLink[i])! )
                let task2 = urlSession.dataTask(with: request2) { (data , response, error) in   //webkit 업무
                    guard data != nil else{
                        if let error = error{
                            print(error.localizedDescription)
                        }
                        return
                    }
//                    URLCache.shared.removeAllCachedResponses()
//                    URLCache.shared.diskCapacity = 0
//                    URLCache.shared.memoryCapacity = 0
                    DispatchQueue.main.async {
                        self.web.load(request2)
                    }
                    self.sema.wait()
                    print("빡빡맨")
                    completionHandler!(result)
                }
                print("너굴맨")
                task2.resume()
                print("근육맨")
            }
            print("쾌걸")
        }
        task.resume()
        
    }
    
    //            feedParser.parseFeed(url: "https://news.google.com/rss") { (rssItem) in
    //                // self.model.append(rssItem)
    //                if rssItem.description != ""{
    //                    self.model.append(rssItem)
    //                }
    //                else{
    //                    self.reTry(rssItem)
    //                }
    //
    //
    //                DispatchQueue.main.async {
    //
    //                    //                if rssItem.description == "" && rssItem.keyWord == []{
    //                    //                    print(rssItem.title)
    //                    //                    let request = URLRequest(url: rssItem.link!)
    //                    //                    self.web.load(request)
    //                    //                }
    //                    self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
    //                }
    //            }
    //
    //
    //            print("fetch")
    //        }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {  //테이블 셀 갯수
        // #warning Incomplete implementation, return the number of rows
        viewModel?.news = model
        return model.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel!.cellInstance(tableView, indexPath: indexPath)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openPage" {
            let newsItemVC = segue.destination as? NewsItemViewController
            let indexPath = tv.indexPathForSelectedRow
            newsItemVC?.viewModel = NewsItemViewModel(url: model[indexPath!.row].link!)
            print(model[indexPath!.row].description)
        }
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
}

extension NewsTableViewController : WKNavigationDelegate{
        
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //print("웹뷰 로드 끝")
        print(webView.url)
        retryURL = webView.url!.absoluteString
        let retryNews = self.innerHtmlParser.retryParsing(self.retryURL, webView.title!)
        if retryNews != nil {
            model.append(retryNews!)
        }
        
        sema.signal()
    }
    
    
}
