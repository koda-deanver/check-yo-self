//
//  CustomTabBar.swift
//  Check_Yo_Self
//
//  Created by phil on 1/10/17.
//  Copyright © 2017 Brook Street Games. All rights reserved.
//

import UIKit

class CustomTabBar: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        /*self.tabBar.tintColor = PlayerData.sharedInstance.cubeColor.uiColor
        if PlayerData.sharedInstance.isAdult{
            self.tabBar.barTintColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
            self.tabBar.unselectedItemTintColor = UIColor.white
        }else{
            self.tabBar.barTintColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
            self.tabBar.unselectedItemTintColor = UIColor.black
        }*/
    }
    
}

extension UITabBarController{
    //********************************************************************
    // setTabsActive
    // Description: Turn off or on touch on all tabs
    //********************************************************************
    func setTabsActive(_ flag: Bool){
        if let tabBarItems = self.tabBar.items{
            for tabBarItem in tabBarItems{
                tabBarItem.isEnabled = flag
            }
        }
    }
}

extension UIImage{
    
    func alpha(value:CGFloat)->UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
    
    func resizeWith(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    func resizeWith(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
