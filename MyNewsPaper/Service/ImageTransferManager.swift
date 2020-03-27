//
//  ImageTransferProtocol.swift
//  MyNewsPaper
//
//  Created by 박성영 on 28/03/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

class ImageTransferManager : NSObject{
    func resizeImage(image:UIImage, toTheSize size:CGSize)->UIImage{

        let scale = CGFloat(max(size.width/image.size.width,
                                size.height/image.size.height))
        let width:CGFloat  = image.size.width * scale
        let height:CGFloat = image.size.height * scale;

        let rr:CGRect = CGRect(x: 0, y: 0, width: width, height: height)

        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        image.draw(in: rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage!
    }
}
