//
//  DetailsViewController.swift
//  Test 1
//
//  Created by Dionisius Ario Nugroho on 15/07/19.
//  Copyright © 2019 Dionisius Ario Nugroho. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var lessonNumP: UILabel!
    @IBOutlet weak var lessonImgP: UIImageView!
    
    var mainLessonNum : String!
    var mainLessonImg : UIImage!
    
    
    
    @IBOutlet weak var LessonProgress: UIProgressView!
    
    @IBOutlet weak var progressView: UIView!
    
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.hidesBarsOnSwipe = true
        
        lessonNumP.text = mainLessonNum
        lessonImgP.image = mainLessonImg
        
        
        progressView.backgroundColor = UIColor(white: 1, alpha: 0.3)
        
        progressView.layer.cornerRadius = 5.0
        progressView.clipsToBounds = true
        
        self.tabBarController?.tabBar.isHidden = true
        
        lessonImgP.layer.cornerRadius = 5.0
        
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        count+=2
        if (count<=10){
            self.LessonProgress.progress = Float(count) / 10.0
        }
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
