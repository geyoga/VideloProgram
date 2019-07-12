//
//  PageViewController.swift
//  VideoVersionTwo
//
//  Created by Georgius Yoga Dewantama on 11/07/19.
//  Copyright © 2019 Georgius Yoga Dewantama. All rights reserved.
//

import UIKit
// menambahkan DataSource PageViewController untuk menambahkan dua fungsi dibawah (before / after)
class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    
// membuat variable untuk menyimpan 3 Welcome Page
    lazy var viewControllerList : [UIViewController] = {
        
        // membuat variable story board
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        // membuat variable setiap welcome page dengan identifier
        let welcomePage1 = storyBoard.instantiateViewController(withIdentifier: "WelcomeOne")
        let welcomePage2 = storyBoard.instantiateViewController(withIdentifier: "WelcomeTwo")
        let welcomePage3 = storyBoard.instantiateViewController(withIdentifier: "WelcomeThree")
        
        return[welcomePage1, welcomePage2, welcomePage3]
    }()
    
    // membuat variable untuk class PageControl
    var pageControl = UIPageControl()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        // Do any additional setup after loading the view.
        
        // membuat variabel untuk menampung ketika list VC di panggil
        if let firstViewController = viewControllerList.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        self.delegate = self
        configurePageControl()
        
    }
    
    // melakukan konfigurasi untuk page control
    func configurePageControl(){
         pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50))
        pageControl.numberOfPages = viewControllerList.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        self.view.addSubview(pageControl)
    }
    
    // fungsi untuk menggeser viewcontroller yang sebelumnya
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        // membuat index view controller saat ini
        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil }
        
        let previousIndex = vcIndex - 1
        
        // mengeksekusi ketika kondisi previousIndex tidak sama dengan nol
        guard previousIndex >= 0 else {
            
            // kalo mau infinity Loop
            // return viewControllerList.last
            
            // kalo mau Looping terbatas
            return nil
        }
        
        // mengantisipasi ketika previous index lebih besar dari list array
        guard viewControllerList.count > previousIndex else {
            return nil
        }
        
        // menampilkan view controller sebelumnya
        return viewControllerList[previousIndex]
    }
    
    // fungsi untuk menampilkan viewController setelahnya
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        // membuat variable index untuk menyimpan view controller
        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil }
        
        let afterIndex = vcIndex + 1
        
        // untuk membatasi gerakan dari view controller
        guard viewControllerList.count != afterIndex else {
            
            // kalo mau infinity Loop
            // return viewControllerList.first
            
            // kalo mau looping terbatas
            return nil
        }
        
        guard viewControllerList.count > afterIndex else {
            return nil
        }
        
        return viewControllerList[afterIndex]
    }

    // fungsi untuk transisi page control diambil dari delegate pageView Controller
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // ambil index dari viewControllers
        let pageContentViewController = pageViewController.viewControllers![0]
        
        // ketika index bernilai terakhir, maka transisi opacity terjadi
        if pageContentViewController == viewControllerList.last {
            
            //pageControl.alpha = 0
            UIView.animate(withDuration: 0.2, delay: 0.3, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.pageControl.alpha = 0
            }, completion: nil)
            
        // ketika index pertama langsung tertampil
        }else if pageContentViewController == viewControllerList.first {
            pageControl.alpha = 1
        }
            
        // ketika index kedua, maka page control tertampil lagi
        else {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.pageControl.alpha = 1
            }, completion: nil)
        }
        
        self.pageControl.currentPage = viewControllerList.index(of: pageContentViewController)!
        
    }

}
