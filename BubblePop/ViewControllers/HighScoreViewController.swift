//
//  HighScoreViewController.swift
//  BubblePop
//
//  Created by zohvin basnyat on 5/11/20.
//  Copyright © 2020 zohvin. All rights reserved.
//

import UIKit

class HighScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let userDefaults = UserDefaults.standard
    var rankingDictionary = [String: Int]()
    var previousRankingDictionary: Dictionary? = [String: Int]()
    var sortedHighScoreArray = [(key: String, value: Int)]()
    
    @IBOutlet weak var highScoreTableView: UITableView!
    @IBOutlet weak var resetScoreBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    
    
    // reset the scores
    @IBAction func resetScoreClicked(_ sender: UIButton) {
        
        if previousRankingDictionary != nil{
            deleteData()
        }
        highScoreTableView.reloadData()
    }
    
    // go back to home
    @IBAction func homeClicked(_ sender: UIButton) {
        // move to rootview
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    // setting up the view before it appears
    override func viewWillAppear(_ animated: Bool) {
        
        // check user defaults to set the high scores
        checkDefaults()
        
        // rounding the buttons
        resetScoreBtn.layer.cornerRadius = 20
        resetScoreBtn.clipsToBounds = true
        homeBtn.layer.cornerRadius = 20
        homeBtn.clipsToBounds = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // set data before view load
    func checkDefaults()  {
        
        // get userdefaults rankings
        previousRankingDictionary = userDefaults.dictionary(forKey: "ranking") as? Dictionary<String, Int>
        
        if previousRankingDictionary != nil{
            rankingDictionary = previousRankingDictionary!
            sortedHighScoreArray = rankingDictionary.sorted(by: {$0.value > $1.value})
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // faking count if there is no data in the sorted array list
        if(sortedHighScoreArray.count == 0){
            return(1)
        }
        return (sortedHighScoreArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "highScoreItem", for: indexPath)
        
        // setting up the cel if there is data in sorted array
        if sortedHighScoreArray.count != 0{
            cell.textLabel?.text = "\(sortedHighScoreArray[indexPath.row].key)"
            cell.detailTextLabel?.text = "\(sortedHighScoreArray[indexPath.row].value)"

        } else{
            // if there is no data in the sorted array show 1 manual cel with no HS
            cell.textLabel?.text = "NO HIGH SCORE YET!"
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    // remove all data when reset is pressed
    func deleteData(){
        userDefaults.removeObject(forKey: "ranking")
        sortedHighScoreArray.removeAll()
    }
    
    
}
