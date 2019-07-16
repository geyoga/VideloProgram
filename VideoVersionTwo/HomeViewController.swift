//
//  ViewController.swift
//  Test 1
//
//  Created by Dionisius Ario Nugroho on 12/07/19.
//  Copyright © 2019 Dionisius Ario Nugroho. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrNum = ["LESSON 1", "LESSON 2", "LESSON 3", "EXTRA LESSON"]
    var arrImg = [UIImage(named: "Lesson 1 BG"),UIImage(named: "Lesson 2 BG"),UIImage(named: "Lesson 3 BG"),UIImage(named: "Lesson 4 BG")]
    var arrTittle = ["Introduction", "Still Object", "Moving Object", "Freestyle Mode"]
    var arrBody = ["You will learn how to use this application clearly. Also introduce you about basic shot, angle and movement. ", "learn about how to get best shot and angle with still object", "Bla bla", "Bla bla bla"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for : .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = .orange
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrNum.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.image.image = arrImg[indexPath.row]
        
        cell.lessonNum.text = arrNum[indexPath.row]
        cell.lessonNum.textColor = UIColor.gray
        
        cell.lessonTitle.text = arrTittle [indexPath.row]
        cell.lessonTitle.font = UIFont.boldSystemFont(ofSize: 17)
        
        cell.lessonBody.text = arrBody[indexPath.row]
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lessonDetail:DetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        self.navigationController?.pushViewController(lessonDetail, animated: true)
    }
    
}
extension ViewController: UICollectionViewDelegateFlowLayout{
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        let collectionWidth = collectionView.bounds.width
    //        return CGSize(width: collectionWidth, height: collectionWidth)
    //    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

