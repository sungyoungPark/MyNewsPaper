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
        self.detailTextLabel?.text = viewModel.newsFeed?.date
        if viewModel.newsFeed?.thumbnail != "" {
            let url = URL(string: (viewModel.newsFeed?.thumbnail!)!)
            let data = try? Data(contentsOf: url!)
            self.imageView?.image = UIImage(data: data!)
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
