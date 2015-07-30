//
//  ViewController.swift
//  Flashcard
//
//  Created by Naoto Ohno on 7/17/15.
//  Copyright (c) 2015 Naoto. All rights reserved.
//

import UIKit
import Parse
import ConvenienceKit


class StudySetsViewController: UIViewController, TimelineComponentTarget {
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        
        if let identifier = segue.identifier {
            println("Identifier \(identifier)")
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //ForConvenienceKit
    // Timeline Component Protocol
    let defaultRange = 0...10
    let additionalRangeSize = 5
    var timelineComponent: TimelineComponent<StudySets, StudySetsViewController>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineComponent = TimelineComponent(target: self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        timelineComponent.loadInitialIfRequired()
    }
    
    
    func loadInRange(range: Range<Int>, completionBlock: ([StudySets]?) -> Void) {
        ParseHelper.studysetRequestforCurrentUser(range) {
            (result: [AnyObject]?, error: NSError?) -> Void in
            if let error = error {
            }
            
            let posts = result as? [StudySets] ?? []
            completionBlock(posts)
        }
    }

    //pass values from StudySets to StudySet
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toStudy"){
            var studySetView: StudySetViewController = segue.destinationViewController as! StudySetViewController
            
            let indexPath = tableView.indexPathForSelectedRow()
            let object = timelineComponent.content[ indexPath!.row ?? 0 ]
            studySetView.studySet = object
        }
        
    }
}



extension StudySetsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return timelineComponent.content.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StudySetsCell") as! StudySetsCell
        

        let object = timelineComponent.content[indexPath.row]
        let title = object["title"] as! String
        let numberOfCards = object["numberOfCards"] as! Int
        var updateDate = ""
        
        //Unwrap optional value
        if let updatedAt = object.updatedAt{
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "M/d/yy"
            updateDate = dateFormatter.stringFromDate(updatedAt)
        }
        

        //put each data into cells
        cell.titleLabel.text = title
        cell.cardsLabel.text = String(numberOfCards)
        cell.updateDateLabel.text = updateDate
        
        
        return cell
    }
    
}


extension StudySetsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        timelineComponent.targetWillDisplayEntry(indexPath.section)
    }
    
}
