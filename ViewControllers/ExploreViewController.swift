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
    
    var studySetsObjects = [StudySets]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegate and Data Source
        tableViewInExplore.delegate = self
        tableViewInExplore.dataSource = self
        
        
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