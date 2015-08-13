//
//  StudyViewController.swift
//  Flashcard
//
//  Created by Naoto Ohno on 7/27/15.
//  Copyright (c) 2015 Naoto. All rights reserved.
//


import UIKit
import Parse


class StudySetViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleInStudy: UILabel!
    @IBOutlet weak var studyButton: UIButton!
    
    @IBOutlet weak var numberOfCards: UILabel!
    var studySet: StudySets!
    
    //declare an array to "store cardObjects" as a class property
    var cardsObjects = [Card]()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //set dataSource
        tableView.dataSource = self
        
        //This code stop tableView to be displayed in wierd way
        tabBarController?.tabBar.hidden = true
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        populateData()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func populateData(){
        //fetch data from Parse and put those in titleInStudy and numberOfCards
        self.titleInStudy.text = studySet["title"] as? String
        if let numberOfCards = studySet["numberOfCards"] as? NSNumber {
            self.numberOfCards.text = numberOfCards.stringValue
        }
        //Reload tableView
        self.tableView.reloadData()
    }
    
    
    //Delete functionality
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let removedCard = cardsObjects.removeAtIndex(indexPath.row)
            removedCard.delete()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
        //update the number of cards on Parse
        for card in self.cardsObjects {
            studySet!.numberOfCards = cardsObjects.count
            card.saveInBackgroundWithBlock(nil)
            studySet?.saveInBackgroundWithBlock(nil)
        }
        
        if cardsObjects.count == 0{
            let removeStudySet = studySet.delete()
            // Bring you back to previous VC
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        populateData()
        
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
    
    
    //pass values from StudySet to FlashCard and CreateSet
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toFlashCard"){
            //Create an instance of FlashCardViewController
            var flashCardView: FlashCardViewController = segue.destinationViewController as! FlashCardViewController
            
            //store object in a variable
            let objectToFlashCard = studySet
            //put the object in FlashCardViewController's property
            flashCardView.studySet = objectToFlashCard
        }
        
        else if(segue.identifier == "toCreateSetToEdit"){
            var createSetView: CreateSetViewController = segue.destinationViewController as! CreateSetViewController
            
            let objectToCreateSet = studySet
            createSetView.studySet = objectToCreateSet
            
            createSetView.cards = cardsObjects
            createSetView.cardIndex = tableView.indexPathForSelectedRow()?.row ?? 0
        
        }
        
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        if segue.identifier == "createSetDone" {
            let createSetVC = segue.sourceViewController as! CreateSetViewController
            cardsObjects = createSetVC.cards
            populateData()
        }
    }
    
    
    
}