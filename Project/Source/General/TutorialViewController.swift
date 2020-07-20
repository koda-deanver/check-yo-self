//
//  TutorialViewController.swift
//  check-yo-self
//
//  Created by AA10 on 17/07/2020.
//  Copyright © 2020 ThematicsLLC. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lastImgView: UIImageView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var pageCtrl: UIPageControl!
    @IBOutlet weak var contentScrollWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tutorialScroll: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    
        container.layer.cornerRadius = 5
        container.layer.masksToBounds = true
        
        btnNext.layer.cornerRadius = 5
        btnNext.layer.masksToBounds = true
        
        contentScrollWidthConstraint.constant = lastImgView.frame.size.width + lastImgView.frame.origin.x
        tutorialScroll.contentSize.width = contentScrollWidthConstraint.constant
    }

    @IBAction func tapNext(_ sender: Any) {
        let currentpage = pageCtrl.currentPage + 1
        var scrollviewFrame = tutorialScroll.frame
        pageCtrl.currentPage = currentpage;
        
        if currentpage == pageCtrl.numberOfPages {
            DefaultsManager.shared.setShowTutorial(value: true)
            dismiss(animated: false, completion: nil)
            return
        }
        
        scrollviewFrame.origin.x = scrollviewFrame.size.width * CGFloat(currentpage)
        tutorialScroll.scrollRectToVisible(scrollviewFrame, animated: false)
    }
}

extension TutorialViewController : UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageCtrl.currentPage = page
    }
}
