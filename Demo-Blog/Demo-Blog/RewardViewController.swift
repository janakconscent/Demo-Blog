//
//  RewardViewController.swift
//  Demo-Blog
//
//  Created by Sam on 27/06/23.
//

import UIKit
import BluePine

class RewardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("RewardViewController")
        BluePine.startBluePine()
    }
}
