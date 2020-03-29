//
//  NewsTableViewCell.swift
//  MyNewsPaper
//
//  Created by 박성영 on 19/03/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    func setUp(_ viewModel : NewsTableViewModel){
        self.textLabel?.text = viewModel.newsFeed?.title
        self.detailTextLabel?.text = viewModel.newsFeed?.description
        if viewModel.newsFeed?.thumbnail != nil {
//            print(viewModel.newsFeed?.thumbnail)
//            let url = URL(string: (viewModel.newsFeed?.thumbnail!)!)
//            print(url)
//            let data = try? Data(contentsOf: url!)
            self.imageView?.image = viewModel.newsFeed?.thumbnail
//                        let url = URL(string: (viewModel.newsFeed?.thumbnail!)!)
//                        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//                            if error != nil {
//                                print(error!)
//                                return
//                            }
//                            DispatchQueue.main.async {
//                                self.imageView!.image = UIImage(data: data!)
//                            }
//                        }).resume()
            }
            
    }
    
    //    override func awakeFromNib() {
    //        super.awakeFromNib()
    //        // Initialization code
    //    }
    //
    //    override func setSelected(_ selected: Bool, animated: Bool) {
    //        super.setSelected(selected, animated: animated)
    //
    //        // Configure the view for the selected state
    //    }
    
}
