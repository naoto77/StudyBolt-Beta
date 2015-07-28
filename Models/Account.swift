////
////  Account.swift
////  Flashcard
////
////  Created by Naoto Ohno on 7/23/15.
////  Copyright (c) 2015 Naoto. All rights reserved.
////
//
//import Foundation
//import Parse
//import UIKit
//
//class accountView : UIViewController {
//    
//    var titleText: String = ""
//    var termText = ""
//    var definitionText = ""
//    
//    @IBAction func Create(sender: AnyObject) {
//        titleText = self.TItle.text
//        termText = self.Term.text
//        definitionText = self.Definition.text
//        
//        sendToParse()
//    }
//    
//    func sendToParse()
//    {
//        let flashcards = PFObject(className: "StudySets")
//        let card       = PFObject(className: "Cards")
//        
//        flashcards["title"] = titleText
//        card["term"] = termText
//        card["definition"] = definitionText
//        
//        flashcards.saveInBackgroundWithBlock({
//            (success: Bool, error: NSError?) -> Void in
//            println("Saved flashcards")
//        })
//        card.saveInBackgroundWithBlock({
//            (success: Bool, error: NSError?) -> Void in
//            println("Saved flashcards")
//        })
//    }
//    
//    @IBOutlet weak var TItle: UITextField!
//    
//    @IBOutlet weak var Term: UITextField!
//    
//    @IBOutlet weak var Definition: UITextField!
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//}