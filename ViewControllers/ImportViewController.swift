//
//  ImportViewController.swift
//  Flashcard
//
//  Created by Naoto Ohno on 8/12/15.
//  Copyright (c) 2015 Naoto. All rights reserved.
//

import UIKit
import Parse

class ImportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Reciever
    var studySetInImport: StudySets!
    var cardsObjects = [Card]()
    
    @IBOutlet weak var tableViewInImport: UITableView!
    @IBOutlet weak var titleInImport: UILabel!
    @IBOutlet weak var numberOfCardsInImport: UILabel!
    @IBOutlet weak var importButton: UIButton!
    
    @IBAction func importStudySet (sender: AnyObject) {
        
        // Variables
        var copyOfAStudySet = StudySets()
        
        copyOfAStudySet.user = PFUser.currentUser()
        copyOfAStudySet.title = studySetInImport.title
        copyOfAStudySet.numberOfCards = studySetInImport.numberOfCards
        copyOfAStudySet.saveInBackground()
        
        println(cardsObjects)
        
        var copyOfCards = [Card]()
        
        for(var i = 0; i < cardsObjects.count; i++){
            
            copyOfCards.append(Card())
            
            
            copyOfCards[i].term = cardsObjects[i].term
            copyOfCards[i].definition = cardsObjects[i].definition
            copyOfCards[i].studySets = copyOfAStudySet
            copyOfCards[i].saveInBackground()
            
            println(copyOfCards[i].term)
            
        }
    }
    
    
   
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        hidesBottomBarWhenPushed = true
    }
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //set dataSource
        tableViewInImport.dataSource = self
        
        //This code stop tableView to be displayed in wierd way
        tabBarController?.tabBar.hidden = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        populateData()
    }
    
    
    func populateData(){
        //fetch data from Parse and put those in titleInStudy and numberOfCards
        self.titleInImport.text = studySetInImport["title"] as? String
        if let numberOfCards = studySetInImport["numberOfCards"] as? NSNumber {
            self.numberOfCardsInImport.text = numberOfCards.stringValue
        }
        //Reload tableView
        self.tableViewInImport.reloadData()
    }
    
    
    
    //Return a number of objects
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardsObjects.count
    }
    
    //set index for array by using indexPath which fetches data from ViewController via data source
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StudySetCell") as! StudySetCell
        
        let termInStudyScene = cardsObjects[indexPath.row].term
        let definitionInStudyScene = cardsObjects[indexPath.row].definition
        
        //put each data into cells
        cell.termInStudyScene.text = termInStudyScene
        cell.definitionInStudyScene.text = definitionInStudyScene
        
        
        return cell
    }
    
    
}
