//
//  CreditViewController.swift
//  VideoVersionTwo
//
//  Created by Indra Sumawi on 20/07/19.
//  Copyright © 2019 Georgius Yoga Dewantama. All rights reserved.
//

import UIKit

class CreditViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func learningPath(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func barrelCredit(_ sender: Any) {
        if let url = URL(string: "https://free3d.com/3d-model/wooden-barrel-11607.html") {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func plantCredit(_ sender: Any) {
        if let url = URL(string: "https://free3d.com/3d-model/alokaziya-377519.html") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func aboutUs(_ sender: Any) {
        if let url = URL(string: "https://indratechid.com/videlo/") {
            UIApplication.shared.open(url)
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
