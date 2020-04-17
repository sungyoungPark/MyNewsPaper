//
//  LaunchScreenController.swift
//  MyNewsPaper
//
//  Created by 박성영 on 01/04/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

class LaunchScreenController: UIViewController {
    
    override func viewDidAppear(_ animated : Bool) {
        super.viewDidAppear(animated)
        sleep(UInt32(1.3))
        let newsNaviVC = self.storyboard?.instantiateViewController(withIdentifier: "newsNavigation") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = newsNaviVC
        // Do any additional setup after loading the view.
    }

}
