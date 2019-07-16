//
//  DetailsViewController.swift
//  Test 1
//
//  Created by Dionisius Ario Nugroho on 15/07/19.
//  Copyright © 2019 Dionisius Ario Nugroho. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        progressView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        progressView.layer.cornerRadius = 8.0
        progressView.clipsToBounds = true
        
        self.tabBarController?.tabBar.isHidden = true
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
