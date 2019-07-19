//
//  DetailsViewController.swift
//  Test 1
//
//  Created by Dionisius Ario Nugroho on 15/07/19.
//  Copyright © 2019 Dionisius Ario Nugroho. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var buttonBegin: UIButton!
    @IBOutlet weak var lessonNumP: UILabel!
    @IBOutlet weak var lessonImgP: UIImageView!
    @IBOutlet weak var lessonTitleP: UILabel!
    @IBOutlet weak var lessonBodyP: UILabel!
    @IBOutlet weak var lessonCourseTitleP: UILabel!
    @IBOutlet weak var learnCollectionView: UICollectionView!
    
    @IBOutlet weak var buttonBegin2: UIButton!
    var lessonDetail: Lessons!

    @IBOutlet weak var LessonProgress: UIProgressView!
    
    @IBOutlet weak var progressView: UIView!
    var technique: [Techniques] = []
    
    private  var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonBegin.setBackgroundImage(UIImage(named: "Button Start"), for: .normal)
        buttonBegin.setBackgroundImage(UIImage(named: "Start Lesson Press"), for: .selected)
        
        // Do any additional setup after loading the view.
        
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.hidesBarsOnSwipe = true
        
        lessonNumP.text = String(lessonDetail.id) //mainLessonNum
        lessonImgP.image = UIImage(named: lessonDetail.image!) //mainLessonImg
        lessonTitleP.text = String(lessonDetail.name!)
        lessonBodyP.text = String(lessonDetail.longDesc!)
    
        //for i in 0..<lessonDetail.learn_use!.count {
        technique = Array(lessonDetail.learn_use!) as! [Techniques]
        //}
        
        //for case let techn as Techniques in lessonDetail.learn_use! {
            //print("\(technique.id) - \(technique.name)")
            //technique = Array(lessonDetail.learn_use!) as! [Techniques]
        //}
        
        progressView.backgroundColor = UIColor(white: 1, alpha: 0.3)
        
        progressView.layer.cornerRadius = 5.0
        progressView.clipsToBounds = true
        
        self.tabBarController?.tabBar.isHidden = true
        
        lessonImgP.layer.cornerRadius = 5.0
        
        
        
        
        if (lessonDetail.type == "Lesson"){
            lessonCourseTitleP.text = String("What You'll Learn")
        }
        else if (lessonDetail.type == "Course"){
            lessonCourseTitleP.text = String("What You'll Use")
        }
        else if (lessonDetail.type == "Tutorial"){
            lessonCourseTitleP.text = ""
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return technique.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let learnCell:DetailCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "learnCell", for: indexPath) as! DetailCollectionViewCell
      
        learnCell.learnName.text = technique[indexPath.row].name
        learnCell.learnImg.image = UIImage(named: technique[indexPath.row].icon!)
        print(technique[indexPath.row].name)
        
        return learnCell
    }
    
    @IBAction func startLesson(_ sender: UIButton) {
        doHaptic()
        if buttonBegin.isSelected {
            // set deselected
            buttonBegin.isSelected = false
        } else {
            // set selected
            buttonBegin.isSelected = true
        }
    }
    @IBAction func startLesson2(_ sender: Any) {
        doHaptic()
        if buttonBegin2.isSelected {
            // set deselected
            buttonBegin2.isSelected = false
        } else {
            // set selected
            buttonBegin2.isSelected = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier ==  "GoToARScreen") {
            let vc = segue.destination as! ARViewController
            vc.choosenLesson = lessonDetail
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


