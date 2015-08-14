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
    var studySetsObjects = [StudySets]()
    
    var searchResult = [StudySets]()
    var searchText = ""
    
    
    //For search bar
    enum State {
        case DefaultMode
        case SearchMode
    }
    
    var state: State = .DefaultMode {
        didSet {
            switch (state){
            case .DefaultMode:
                searchBar.resignFirstResponder()
                searchBar.showsCancelButton = false
            
            case .SearchMode:
            let searchText = searchBar.text ?? ""
            searchBar.setShowsCancelButton(true, animated: true)

            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // Refresh or Pull Data from Parse
        populateData()
        
        state = .DefaultMode
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    //search query
    func searchStudySets(){
        var findStudySets = PFQuery(className: StudySets.parseClassName())
        findStudySets.whereKey("user", equalTo: PFUser.currentUser()!)
        findStudySets.whereKey("title", containsString: searchBar.text)
        
        if let searchResult = findStudySets.findObjects() as? [StudySets]{
            studySetsObjects = searchResult
            
            //Reload tableView
            self.tableView.reloadData()
            
        }
    }
    
}



extension StudySetsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studySetsObjects.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StudySetsCell") as! StudySetsCell
        
        let titleString = studySetsObjects[indexPath.row].title
        println(titleString)
//        println(searchBar.text)
        
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


//for search bar
extension StudySetsViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        state = .SearchMode
        if searchBar.text .isEmpty{
            populateData()
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        state = .DefaultMode
        populateData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchStudySets()
        //notes = searchStudySets(searchText)
    }
    
}