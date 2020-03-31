//
//  ImageTransferProtocol.swift
//  MyNewsPaper
//
//  Created by 박성영 on 28/03/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

class ImageTransferManager : NSObject{
    
    func makeUIImage(_ thumbnailURL : String)->UIImage?{
        if thumbnailURL != "" {
            let thumbnailURL = URL(string: thumbnailURL)
            var thumbnail = UIImage()
            do {
                let data = try Data(contentsOf: thumbnailURL!)
                print(thumbnailURL)
                thumbnail = UIImage(data: data)!
                thumbnail = resizeImage(image: thumbnail, toTheSize: CGSize(width: 70, height: 70))
            } catch{
                print("thumbnail URL 오류")
                return nil
            }
            return thumbnail   //썸네일 이미지 생성
        }
        else {    //썸네일 이미지 URL로 공백이 들어왔을떄
            return nil
        }
    }
    
    
    
    
    
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
