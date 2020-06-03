//
//  GameViewController.swift
//  BubblePop
//
//  Created by zohvin basnyat on 5/11/20.
//  Copyright © 2020 zohvin. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var initailGameLooper = 3
    var timeRemaining = 60
    var initialTimeForColor = 60
    var maxBubble = 15
    var currentPlayerName = "ANONYMOUS"
    var score = 0
    var comboCounter = 0
    var lastBubbleValue: Int = 0
    var rankingDictionary = [String: Int]()
    var previousRankingDictionary: Dictionary? = [String: Int]()
    var sortedHighScoreArray = [(key: String, value: Int)]()
    var myTimer: Timer?
    var initialCountdownTimer: Timer?
    var bubbleBtn = BubbleButton()
    var bubbleArray = [BubbleButton]()
    
    // getting screen width
    var screenWidth: UInt32 {
        return UInt32(UIScreen.main.bounds.width)
    }
    
    // getting screen height
    var screenHeight: UInt32 {
        return UInt32(UIScreen.main.bounds.height)
    }
    
    // user detaults
    let userDefaults = UserDefaults.standard
    
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var highScoreLbl: UILabel!
    @IBOutlet weak var comboLbl: UILabel!
    
    @IBOutlet weak var initialCountdownLbl: UILabel!
    @IBOutlet weak var initialCountdownView: UIView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // set time
        getTotalTime()
        // calculate max bubble
        getMaxBubble()
        // set current player name
        getPlayerName()
        // TODO: calculate the highscore to display
        getHighScore()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // coundown before the game
        initialCountdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ timer in
            self.initialCountDownTimer()
        }
        
    }
    
    // if back is pressed after game starts then stop the timers
    override func viewDidDisappear(_ animated: Bool) {
        initialCountdownTimer?.invalidate()
        myTimer?.invalidate()
        
    }
    
    
    // this is for the game screen count down 
    func initialCountDownTimer(){
        if(initailGameLooper == 0){
            startGame()
            initialCountdownView.removeFromSuperview()
            initialCountdownTimer?.invalidate()
            
        } else{
            initailGameLooper -= 1
            if(initailGameLooper == 0){
             initialCountdownLbl.text = "GO!"
            }else {
                initialCountdownLbl.text = String(initailGameLooper) //String(Int(initialCountdownLbl.text!)! - 1)
            }
        }
    }
    
    func startGame(){
        // start timer and perform actions
        myTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ timer in
            
            self.setRemainingTime()
            self.removeBubble()
            self.createBubble()
        }
    }
    
    // get the total time user selected in earlier page
    func getTotalTime(){
        if let time = userDefaults.value(forKey: "gameTime") as? Int {
            timeRemaining = time
            initialTimeForColor = time
        }else{
            timeRemaining = 60
            initialTimeForColor = 60
        }
        timeLbl.text = "\(timeRemaining)"
    }
    
    // get the Max bubble selected by the user in earlier page
    func getMaxBubble(){
        if let maxBubbleSelected = userDefaults.value(forKey: "maxBubbles") as? Int {
            maxBubble = maxBubbleSelected
        }else{
            maxBubble = 15
        }
    }
    
    // get the player name
    func getPlayerName(){
        if let playerName = userDefaults.value(forKey: "currentPlayer") as? String {
            currentPlayerName = playerName
        }
    }
    
    // check previous highscore and set it in the label
    func getHighScore() {
        previousRankingDictionary = userDefaults.dictionary(forKey: "ranking") as? Dictionary<String, Int>
        if previousRankingDictionary != nil{
            rankingDictionary = previousRankingDictionary!
            sortedHighScoreArray = rankingDictionary.sorted(by: {$0.value > $1.value})
            highScoreLbl.text = "\(sortedHighScoreArray[0].value)"
        }
    }
    
    // set the timer and do countdown
    func setRemainingTime(){
        
        // update Label
        timeLbl.text = "\(timeRemaining)"
        // check if game ended
        if(timeRemaining == 0){
            // stop the timer after it is 0
            myTimer?.invalidate()
            
            // check previous high score
            checkHighScore()
            
            // Navigate to HighScore Page
            let destinationView = self.storyboard?.instantiateViewController(withIdentifier: "HighScoreViewController") as! HighScoreViewController
            // hide the navigation bar back button so that user cant go to game screen again
            destinationView.navigationItem.setHidesBackButton(true, animated: true)
            // push to actual view
            self.navigationController?.pushViewController(destinationView, animated: true)
            
            
        } else {
            timeRemaining -= 1
        }
        
        // call to change the timer color
        changeTimerColor()
        
    }
    
    // change timer lable color to red when it is 5% of total time and orange when 15% of total time
    func changeTimerColor(){
        if timeRemaining < Int(round(Double(initialTimeForColor) * 0.05)) {
            timeLbl.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        } else if timeRemaining < Int(round(Double(initialTimeForColor) * 0.15)){
            timeLbl.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        }
    }
    
    // randomly remove button from the screen
    func removeBubble(){
        
        var i = 0
        while i < bubbleArray.count{
            if arc4random_uniform(100) < 33 {
                // remove button from superview
                bubbleArray[i].removeFromSuperview()
                // remove button from array
                bubbleArray.remove(at: i)
                // for looping
                i += 1
            }
        }
    }
    
    
    
    // check if bubbles overlap or not
    func isOverlapped(newBubble: BubbleButton) -> Bool {
        for existingBubble in bubbleArray{
            if newBubble.frame.intersects(existingBubble.frame){
                return true
            }
        }
        return false
    }
    
    // creating bubbles 
    func createBubble() {
        let numberToCreate = arc4random_uniform(UInt32( maxBubble - bubbleArray.count))
        
        var i = 0
        while i < numberToCreate{
            // create bubble
            bubbleBtn = BubbleButton() // creating UIButton
            
            // set position
            bubbleBtn.frame = createRandomRect()
            
            //check position for Overlap
            if (!isOverlapped(newBubble: bubbleBtn)){
                // set onClick listner
                bubbleBtn.addTarget(self, action: #selector(bubbleTapped), for: UIControl.Event.touchUpInside)
                
                // add the bubble button to the view
                self.view.addSubview(bubbleBtn)
                
                // add bubble to bubbleArray
                bubbleArray += [bubbleBtn]
                
                // animate
                bubbleBtn.animateBoing()
                //bubbleBtn.animateOpacity()
                
                // loop counter
                i += 1
                
            }
        }
    }
    
    // getting random screen position
    func createRandomRect() -> CGRect {
        let diameter = 2 * bubbleBtn.radius
        let randomX = CGFloat(20 + arc4random_uniform( screenWidth - diameter - 20 ))
        let randomY = CGFloat(140 + arc4random_uniform(screenHeight - diameter - 140))
        
        return CGRect(x: randomX,
                      y:randomY,
                      width: CGFloat(diameter),
                      height: CGFloat(diameter))
        
    }
    
    // actions when bubble is clicked on
    @IBAction func bubbleTapped(_ bubbleClicked: BubbleButton) {
        // TODO actions when button pressed
        bubbleClicked.animateRemove()
        
        // check for combo
        if lastBubbleValue == bubbleClicked.value {
            score += Int(round(Double(bubbleClicked.value) * 1.5))
            comboCounter += 1
            comboLbl.text = "\(comboCounter)"
        }else{
            score += bubbleClicked.value
        }
        // assign last bubble
        lastBubbleValue = bubbleClicked.value
        
        // upadate current score
        scoreLbl.text = "\(score)"
        
        // update highscore
        if previousRankingDictionary == nil {
            highScoreLbl.text = "\(score)"
       } else if sortedHighScoreArray[0].value < score{
            highScoreLbl.text = "\(score)"
        } else if sortedHighScoreArray[0].value >= score {
            highScoreLbl.text = "\(sortedHighScoreArray[0].value)"
        }
    }
    
    // saving highscore
    func saveHighScore(){
        rankingDictionary.updateValue(score, forKey: currentPlayerName)
        userDefaults.set(rankingDictionary, forKey: "ranking")
    }
    
    // check high score and save data to userdefaults
    func checkHighScore(){
        if previousRankingDictionary == nil{
            saveHighScore()
        }else{
            rankingDictionary = previousRankingDictionary!
            if rankingDictionary.keys.contains(currentPlayerName){
                let previousScore = rankingDictionary[currentPlayerName]!
                if previousScore < score {
                    saveHighScore()
                }
            } else {
                saveHighScore()
            }
        }
    }
}
