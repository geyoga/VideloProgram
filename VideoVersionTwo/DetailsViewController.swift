//
//  DetailsViewController.swift
//  Test 1
//
//  Created by Dionisius Ario Nugroho on 15/07/19.
//  Copyright © 2019 Dionisius Ario Nugroho. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var lessonNumP: UILabel!
    @IBOutlet weak var lessonImgP: UIImageView!
    @IBOutlet weak var lessonTitleP: UILabel!
    @IBOutlet weak var lessonBodyP: UILabel!
    @IBOutlet weak var lessonCourseTitleP: UILabel!
    
    var lessonDetail: Lessons!
    
    
    @IBOutlet weak var LessonProgress: UIProgressView!
    
    @IBOutlet weak var progressView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.hidesBarsOnSwipe = true
        
        lessonNumP.text = String(lessonDetail.id) //mainLessonNum
        lessonImgP.image = UIImage(named: lessonDetail.image!) //mainLessonImg
        lessonTitleP.text = String(lessonDetail.name!)
        lessonBodyP.text = String(lessonDetail.longDesc!)
    
        
        for case let technique as Techniques in lessonDetail.learn_use! {
            print("\(technique.id) - \(technique.name)")
        }
        
        progressView.backgroundColor = UIColor(white: 1, alpha: 0.3)
        
        progressView.layer.cornerRadius = 5.0
        progressView.clipsToBounds = true
        
        self.tabBarController?.tabBar.isHidden = true
        
        lessonImgP.layer.cornerRadius = 5.0
        
        
        if (lessonDetail.type != "Lesson"){
            lessonCourseTitleP.text = String("What You'll Use")
        }
    }
    
    @IBAction func startLesson(_ sender: UIButton) {
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
