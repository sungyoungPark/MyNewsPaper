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
        self.newsTitle?.text = viewModel.newsFeed?.title
        //newsTitle.numberOfLines = 0
       // newsTitle.sizeToFit()
        self.newsDescription?.text = viewModel.newsFeed?.description
        if viewModel.newsFeed?.thumbnail != nil {
            self.thumbnailImageView?.image = viewModel.newsFeed?.thumbnail
            }
        newsKeyword.text = viewModel.newsFeed?.keyWord?.first
            
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
