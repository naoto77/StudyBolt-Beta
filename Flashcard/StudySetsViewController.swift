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
    
    //declare an array to "store studySetsObjects" as a class property
    var studySetsObjects = [StudySets()]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetch Card class from Parse and sort it by StudySets pointer
        var studySetsQuery = PFQuery(className: StudySets.parseClassName())//StudySets.parseClassName is same as "StudySets"
        
        //the values are optional so unwrap it by optional binding
        if let studySets = studySetsQuery.findObjects() as? [StudySets] {
            studySetsObjects = studySets
        }
        
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
        }
        
    }
    
    
    
    //Delete functionality
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let removedStudySet = studySetsObjects.removeAtIndex(indexPath.row)
            removedStudySet.deleteInBackground()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
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