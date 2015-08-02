//
//  StudyViewController.swift
//  Flashcard
//
//  Created by Naoto Ohno on 7/27/15.
//  Copyright (c) 2015 Naoto. All rights reserved.
//


import UIKit
import Parse
import ConvenienceKit


class StudySetViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleInStudy: UILabel!
    @IBOutlet weak var studyButton: UIButton!
    
    @IBOutlet weak var numberOfCards: UILabel!
    var studySet : StudySets!
    
    //declare an array to "store cardObjects" as a class property
    var cardsObjects = [Card]()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //set dataSource
        tableView.dataSource = self
        
        //fetch data from Parse and put those in titleInStudy and numberOfCards
        self.titleInStudy.text = studySet["title"] as? String
        if let numberOfCards = studySet["numberOfCards"] as? NSNumber {
            self.numberOfCards.text = numberOfCards.stringValue
        }

        
        
        //fetch Card class from Parse and sort it by StudySets pointer
        var cardsQuery = PFQuery(className: Card.parseClassName())//Card.parseClassName is same as "Card"
        cardsQuery.whereKey("studySets", equalTo: studySet)
        //the values are optional so unwrap it by optional binding
        if let cards = cardsQuery.findObjects() as? [Card] {
            cardsObjects = cards
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    //pass values from StudySets to StudySet
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toFlashCard"){
            //Create an instance of FlashCardViewController
            var flashCardView: FlashCardViewController = segue.destinationViewController as! FlashCardViewController
            
            //store object in a variable
            let object = studySet
            //put the object in FlashCardViewController's property
            flashCardView.studySet = object
        }
        
    }
    
    
    
    
}