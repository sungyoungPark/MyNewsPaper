//
//  NewsTableViewCell.swift
//  MyNewsPaper
//
//  Created by 박성영 on 19/03/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var newsTitle: UILabel!
    @IBOutlet var newsDescription: UILabel!
    @IBOutlet var newsKeyword: UILabel!
    
    
    
    func setUp(_ viewModel : NewsTableViewModel){
        newsTitle?.text = viewModel.newsFeed?.title
        newsDescription?.text = viewModel.newsFeed?.description
        if viewModel.newsFeed?.thumbnail != nil {
            self.thumbnailImageView?.image = viewModel.newsFeed?.thumbnail
        }
        if viewModel.newsFeed?.keyWord?.count != 0 {
            var keyword = "/  "
            for i in (viewModel.newsFeed?.keyWord)!{
                keyword.append(i + "  /  ")
            }
            newsKeyword.text = keyword
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
