//
//  SettingsViewController.swift
//  BubblePop
//
//  Created by zohvin basnyat on 5/11/20.
//  Copyright © 2020 zohvin. All rights reserved.
//


// this is the settings view controller where name, max number of bubbles and time is selected


import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    var totalTime = 60
    var totalBubbles = 15
    let anonymousPlayerName = "ANONYMOUS"
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var playerName: UITextField!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var maxBubbleLbl: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    
    
    // Time slider interface interaction
    @IBAction func timeSlider(_ sender: UISlider) {
        totalTime = Int(sender.value)
        timeLbl.text = String(totalTime) + " sec"
    }
    
    // Max bubbles slider interface interaction
    @IBAction func maxBubbleSlider(_ sender: UISlider) {
        totalBubbles = Int(sender.value)
        maxBubbleLbl.text = String(totalBubbles)
    }
    
    @IBAction func startClicked(_ sender: UIButton) {
        
        // check for Player named or no name
        if let nameTxt = playerName.text, nameTxt.isEmpty{
            userDefaults.set(anonymousPlayerName, forKey: "currentPlayer")
        } else{
            // save typed name in user detaults
            userDefaults.set(playerName.text, forKey: "currentPlayer")
        }
        
        // push time and max bubble to be used in next page
        userDefaults.set(Int(totalTime), forKey: "gameTime")
        userDefaults.set(Int(totalBubbles), forKey: "maxBubbles")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startBtn.layer.cornerRadius = 20
        startBtn.clipsToBounds = true
        playerName.delegate = self
        
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        // get the current text, or use an empty string if that failed
           let currentText = playerName.text ?? ""

           // attempt to read the range they are trying to change, or exit if we can't
           guard let stringRange = Range(range, in: currentText) else { return false }

           // add their new text to the existing text
           let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

           // make sure the result is under 16 characters
           return updatedText.count <= 16
    }
 
}
