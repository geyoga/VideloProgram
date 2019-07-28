//
//  ViewController.swift
//  Test 1
//
//  Created by Dionisius Ario Nugroho on 12/07/19.
//  Copyright © 2019 Dionisius Ario Nugroho. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!

    private var lesson: [Lessons] = []
    
    static var firstTime = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for : .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = .orange
        
        //FETCH
        let data = CoreDataHelper.fetch(entity: "Lessons") as [Lessons]
        for item in data {
            lesson.append(item)
//            for case let technique as Techniques in item.learn_use! {
//                //print("\(technique.id) - \(technique.name)")
//            }
        }
        
        if UserDefaults.standard.object(forKey: "isFirstTime") == nil {
            //if its done tutorial, next time go directly to lesson path
            UserDefaults.standard.set(true, forKey: "isFirstTime")
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let AR = storyBoard.instantiateViewController(withIdentifier: "ARViewController") as! ARViewController
            AR.choosenLesson = lesson[0]
            self.present(AR, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.tintColor = .orange
        self.tabBarController?.tabBar.barTintColor = .clear
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lesson.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.image.image = UIImage(named: lesson[indexPath.row].image!)//arrImg[indexPath.row]
        
        cell.lessonNum.text = "\(lesson[indexPath.row].type!)" //arrNum[indexPath.row]
        cell.lessonNum.textColor = UIColor.gray
        
        cell.lessonTitle.text = lesson[indexPath.row].name//arrTittle [indexPath.row]
        cell.lessonTitle.font = UIFont.boldSystemFont(ofSize: 17)
        
        cell.lessonBody.text = lesson[indexPath.row].shortDesc// arrBody[indexPath.row]
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        doHaptic()
        let lessonDetail:DetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController

        lessonDetail.lessonDetail  = lesson[indexPath.row]
        
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
