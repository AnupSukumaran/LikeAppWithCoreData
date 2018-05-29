//
//  LikeGiverViewController.swift
//  LikeApp
//
//  Created by Sukumar Anup Sukumaran on 05/04/18.
//  Copyright © 2018 AssaRadviewTech. All rights reserved.
//

import UIKit

class LikeGiverViewController: UIViewController {
    
    var id = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ID = \(id)")
       Constants.sharedInt.id = id
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func LikeAction(_ sender: Any) {
        
        NotificationCenter.default.post(name: Constants.sharedInstance , object: nil)
    }
    
    
    @IBAction func BackAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    

}
