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
 
    
    @IBOutlet weak var tv: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = makeModel()
        viewModel = NewsTableViewModel(news: model)
       // configure()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func configure(){
         print("잘됨")
    }
    
    func makeModel()->[NewsModel]{
        let myParser = XmlParserManager().initWithURL(URL(string: "https://news.google.com/rss")!) as! XmlParserManager
        let feeds = myParser.feeds
        var title : String?
        var date : String?
        var link : String?
        var news = [NewsModel]()
        for i in 0...feeds.count-1{
            title = (feeds.object(at: i) as AnyObject).object(forKey: "title") as? String
            date = (feeds.object(at: i) as AnyObject).object(forKey: "pubDate") as? String
            link = (feeds.object(at: i) as AnyObject).object(forKey: "link") as? String
            news.append(NewsModel(title: title, Date: date, link: link))
        }
        return news
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {  //테이블 셀 갯수
        // #warning Incomplete implementation, return the number of rows
        return model.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath)
        // Configure the cell...
        //테이블 셀에 들어갈 값
        return viewModel!.cellInstance(tableView, indexPath: indexPath)
    }

    // MARK: - Navigation

       // In a storyboard-based application, you will often want to do a little preparation before navigation
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openPage" {
            let newsItemVC = segue.destination as? NewsItemViewController
            let indexPath = tv.indexPathForSelectedRow
            newsItemVC?.viewModel = NewsItemViewModel(url: model[indexPath!.row].link!)
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
