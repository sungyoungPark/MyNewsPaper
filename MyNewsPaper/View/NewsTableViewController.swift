//
//  NewsTableViewController.swift
//  MyNewsPaper
//
//  Created by 박성영 on 19/03/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

protocol NewsTableViewControllerProtocol {
    var viewModel: NewsTableViewModel { get set }
    func configure()
}

class NewsTableViewController: UITableViewController {
    
    var model = [NewsModel]()
    var viewModel : NewsTableViewModel?
    var count = 1
    
    @IBOutlet weak var tv: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = NewsTableViewModel(news: model)
        fetchData()
        //print("다됨")
    }
    
    func fetchData(){
        let feedParser = XmlParserManager()
        feedParser.parseFeed(url: "https://news.google.com/rss") { (rssItems) in
            self.model = rssItems
            print(rssItems.count)
            OperationQueue.main.addOperation {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
            }
        }
    }
    
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
            print(model[indexPath!.row].thumbnail)
            // newsItemVC.viewModle = NewsItemViewModel()
            // print(model[indexPath!.row])
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
