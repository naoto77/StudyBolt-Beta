//
//  ExploreViewController.swift
//  Flashcard
//
//  Created by Naoto Ohno on 8/11/15.
//  Copyright (c) 2015 Naoto. All rights reserved.
//

import UIKit
import Parse

class ExploreViewController: UIViewController{
    
    @IBOutlet weak var tableViewInExplore: UITableView!
    
    @IBOutlet weak var searchBarInExplore: UISearchBar!
    
    
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
                searchBarInExplore.resignFirstResponder()
                searchBarInExplore.showsCancelButton = false
                
            case .SearchMode:
                let searchText = searchBarInExplore.text ?? ""
                searchBarInExplore.setShowsCancelButton(true, animated: true)
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegate and Data Source
        tableViewInExplore.delegate = self
        tableViewInExplore.dataSource = self
        
        //for search
        searchBarInExplore.delegate = self
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // Refresh or Pull Data from Parse
        populateData()
        
        //for search bar
        state = .DefaultMode
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Refresh or Pull Data from Parse
    func populateData(){
        
        //fetch Card class from Parse and sort it by StudySets pointer
        var studySetsQuery = PFQuery(className: StudySets.parseClassName())//StudySets.parseClassName is same as "StudySets"
        
        studySetsQuery.whereKey("user", notEqualTo:PFUser.currentUser()!)
        
        //the values are optional so unwrap it by optional binding
        if let studySets = studySetsQuery.findObjects() as? [StudySets] {
            studySetsObjects = studySets
            
        }
        
        
    }
    
    
    //search query
    func searchStudySetsForExplore(){
        var findStudySets = PFQuery(className: StudySets.parseClassName())
        //findStudySets.whereKey("title", containsString: searchBarInExplore.text)
        findStudySets.whereKey("title", matchesRegex: searchBarInExplore.text, modifiers: "i")
        
        if let searchResult = findStudySets.findObjects() as? [StudySets]{
            studySetsObjects = searchResult
            
            //Reload tableView
            self.tableViewInExplore.reloadData()
            
        }
    }
    
    
    //pass values from Explore to Import
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toImport"){
            var studySetView: ImportViewController = segue.destinationViewController as! ImportViewController
            
            let indexPath = tableViewInExplore.indexPathForSelectedRow()
            let object = studySetsObjects[indexPath!.row]
            studySetView.studySetInImport = object
            
            var cardsQuery = PFQuery(className: Card.parseClassName())//Card.parseClassName is same as "Card"
            cardsQuery.whereKey("studySets", equalTo: object)
            //the values are optional so unwrap it by optional binding
            if let cards = cardsQuery.findObjects() as? [Card] {
                studySetView.cardsObjects = cards
            }
            
        }
        
    }
    
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        if segue.identifier == "importDone" {
            populateData()
        }
    }
    
}


extension ExploreViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studySetsObjects.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StudySetsCellInExplore") as! StudySetsCellInExplore
        
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
        cell.titleLabelInExplore.text = titleString
        cell.cardsLabelInExplore.text = String(numberOfcardsString)
        cell.updateDateLabelInExplore.text = updateDate
        
        
        return cell
    }

    
}


//for search bar
extension ExploreViewController: UISearchBarDelegate {
    
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
        searchStudySetsForExplore()
        //notes = searchStudySets(searchText)
    }
    
}