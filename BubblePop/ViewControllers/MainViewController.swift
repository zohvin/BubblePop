//
//  ViewController.swift
//  BubblePop
//
//  Created by zohvin basnyat on 5/11/20.
//  Copyright © 2020 zohvin. All rights reserved.
//


// this is the main view controller

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var newGameBtn: UIButton!
    
    @IBOutlet weak var highScoreBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // making the button curve edges 
        newGameBtn.layer.cornerRadius = 20
        newGameBtn.clipsToBounds = true
        highScoreBtn.layer.cornerRadius = 20
        highScoreBtn.clipsToBounds = true
        
    }


}

