//
//  StudyViewController.swift
//  Flashcard
//
//  Created by Naoto Ohno on 7/27/15.
//  Copyright (c) 2015 Naoto. All rights reserved.
//


import UIKit
import Parse

class StudySetViewController: UIViewController{
    
    @IBOutlet weak var titleInStudy: UILabel!
    @IBOutlet weak var studyButton: UIButton!
    
    @IBOutlet weak var numberOfCards: UILabel!
    var studySet : PFObject!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        var cardQuery = PFQuery(className: Card)
        
        
//        var query = PFQuery(className:"Card")
//        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
//            if error == nil {
//                for object in objects {
//                    // Do something
//                }
//            } else {
//                println(error)
//            }
//        }
        
        
        
        //fetch data from Parse and put those in titleInStudy and numberOfCards
        self.titleInStudy.text = studySet["title"] as? String
        if let numberOfCards = studySet["numberOfCards"] as? NSNumber {
            self.numberOfCards.text = numberOfCards.stringValue
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
}
