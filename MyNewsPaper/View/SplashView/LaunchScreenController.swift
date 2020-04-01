//
//  LaunchScreenController.swift
//  MyNewsPaper
//
//  Created by 박성영 on 01/04/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

class LaunchScreenController: UIViewController {
    @IBOutlet var LogoImage: UIImageView!
    
    override func viewDidAppear(_ animated : Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.3, animations: {
            self.LogoImage.layer.cornerRadius = self.LogoImage.frame.width/2
            self.view.backgroundColor = .white
            
        })
        {(success) in
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateInitialViewController()
            UIApplication.shared.keyWindow?.rootViewController = vc
            
        }
            
        // Do any additional setup after loading the view.
    }
    

}
