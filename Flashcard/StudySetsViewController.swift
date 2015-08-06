//
//  ViewController.swift
//  Flashcard
//
//  Created by Naoto Ohno on 7/17/15.
//  Copyright (c) 2015 Naoto. All rights reserved.
//

import UIKit
import Parse


class StudySetsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //declare an array to "store studySetsObjects" as a class property
    var studySetsObjects = [StudySets()]
    
    var searchResult = [StudySets()]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // Refresh or Pull Data from Parse
        populateData()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
    }

    //pass values from StudySets to StudySet
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toStudy"){
            var studySetView: StudySetViewController = segue.destinationViewController as! StudySetViewController
            
            let indexPath = tableView.indexPathForSelectedRow()
            let object = studySetsObjects[indexPath!.row]
            studySetView.studySet = object

            var cardsQuery = PFQuery(className: Card.parseClassName())//Card.parseClassName is same as "Card"
            cardsQuery.whereKey("studySets", equalTo: object)
            //the values are optional so unwrap it by optional binding
            if let cards = cardsQuery.findObjects() as? [Card] {
                studySetView.cardsObjects = cards
            }
            
        }
        
    }
    
    //Delete functionality
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let removedStudySet = studySetsObjects.removeAtIndex(indexPath.row)
            removedStudySet.delete()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
        populateData()
        
    }
    
    // Refresh or Pull Data from Parse
    func populateData(){
        
        //fetch Card class from Parse and sort it by StudySets pointer
        var studySetsQuery = PFQuery(className: StudySets.parseClassName())//StudySets.parseClassName is same as "StudySets"
        
        studySetsQuery.whereKey("user", equalTo:PFUser.currentUser()!)

        
        //the values are optional so unwrap it by optional binding
        if let studySets = studySetsQuery.findObjects() as? [StudySets] {
            studySetsObjects = studySets
            
            //Reload tableView
            self.tableView.reloadData()
        }
        
        
    }
    
    
    //Search function
//    func searchStudyset(searchText: String) -> StudySets{
//        let studySetQuery = PFQuery(className: StudySets.parseClassName())
//        
//        studySetQuery.whereKey("studySets", equalTo: searchText)
//        
//        if let studySet = studySetQuery.findObjects() as? [StudySets]{
//            searchResult = studySet
//        }
//        
//        return searchResult as? [StudySets]
//    }
//    
//    
//    var cardsQuery = PFQuery(className: Card.parseClassName())//Card.parseClassName is same as "Card"
//    
//    //Sort query by studySet pointer
//    cardsQuery.whereKey("studySets", equalTo: studySet)
//    
//    //The values are optional so unwrap it by optional binding
//    if let cards = cardsQuery.findObjects() as? [Card] {
//        cardsObjects = cards
//    }
//    func searchUsers(searchText: String, completionBlock: PFArrayResultBlock)
//        -> PFQuery {
//            /*
//            NOTE: We are using a Regex to allow for a case insensitive compare of usernames.
//            Regex can be slow on large datasets. For large amount of data it's better to store
//            lowercased username in a separate column and perform a regular string compare.
//            */
//            let query = PFUser.query()!.whereKey(ParseHelper.ParseUserUsername,
//                matchesRegex: searchText, modifiers: "i")
//            
//            query.whereKey(ParseHelper.ParseUserUsername,
//                notEqualTo: PFUser.currentUser()!.username!)
//            
//            query.orderByAscending(ParseHelper.ParseUserUsername)
//            query.limit = 20
//            
//            query.findObjectsInBackgroundWithBlock(completionBlock)
//            
//            return query
//    }
    
}



extension StudySetsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studySetsObjects.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StudySetsCell") as! StudySetsCell
        
        let titleString = studySetsObjects[indexPath.row].title
        println(titleString)
        println(searchBar.text)
        
        let numberOfcardsString = studySetsObjects[indexPath.row].numberOfCards as! Int
        var updateDate = ""
        
        //Unwrap optional value
        if let updatedAt = studySetsObjects[indexPath.row].updatedAt{
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "M/d/yy"
            updateDate = dateFormatter.stringFromDate(updatedAt)
        }
        
        
        //put each data into cells
        cell.titleLabel.text = titleString
        cell.cardsLabel.text = String(numberOfcardsString)
        cell.updateDateLabel.text = updateDate
        
        
        return cell
    }
    
}