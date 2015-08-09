//
//  CreateSetViewController.swift
//  Flashcard
//
//  Created by Naoto Ohno on 7/23/15.
//  Copyright (c) 2015 Naoto. All rights reserved.
//

import UIKit
import Parse

class CreateSetViewController: UIViewController {
    @IBOutlet var titleTextField: UITextField!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var addCardView0: AddCardView! // Left
    @IBOutlet var addCardView1: AddCardView! // Center
    @IBOutlet var addCardView2: AddCardView! // Right
    
    var cards = [Card()]
    
    var cardIndex = 0
    
    //Reciever of studySet object passed from StudySetViewController
    var studySet: StudySets?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("textFieldDidChange:"), name: UITextFieldTextDidChangeNotification, object: nil)
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if studySet != nil{
            titleTextField.text = studySet?.title
            updateTextFields()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        updateLocking()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        moveToCenter()
    }
    
    func textFieldDidChange(notification: NSNotification) {
        let currentCard = cards[cardIndex]
        currentCard.term = addCardView1.termTextField.text
        currentCard.definition = addCardView1.definitionTextField.text
        
        updateLocking()
    }
    
    @IBAction func save(sender: AnyObject!) {
        
        if studySet != nil{
            // Save all the cards
            studySet?.title = titleTextField.text
            studySet!.numberOfCards = cards.count
            studySet?.saveInBackgroundWithBlock(nil)
            for card in self.cards {
                card.studySets = studySet
                card.saveInBackgroundWithBlock(nil)
            }
            self.performSegueWithIdentifier("createSetDone", sender: nil)
        }
        else{
            
            
            // Upload/save study sets
            let newStudySets = StudySets()
            newStudySets.user = PFUser.currentUser()
            newStudySets.title = titleTextField.text
            newStudySets.numberOfCards = cards.count
            newStudySets.saveInBackgroundWithBlock { (success, error) -> Void in
                // Save all the cards
                for card in self.cards {
                    card.studySets = newStudySets
                    card.saveInBackgroundWithBlock(nil)
                }
                self.performSegueWithIdentifier("createSetDone", sender: nil)
            }
        }
        
        // Go back to previous VC
//        self.navigationController?.popViewControllerAnimated(true)
//        performSegueWithIdentifier("createSetDone", sender: nil)
    }
    
    func updateLocking() {
        if addCardView1.termTextField.text.isEmpty && addCardView1.definitionTextField.text.isEmpty {
            if cardIndex <= 0 {
                lockScrollView()
            } else {
                lockScrollViewRight()
            }
        } else {
            if cardIndex <= 0 {
                lockScrollViewLeft()
            } else {
                unlockScrollView()
            }
        }
    }
    
    func lockScrollView() {
        let insets = UIEdgeInsets(top: 0, left: -scrollView.frame.size.width, bottom: 0, right: -scrollView.frame.size.width)
        scrollView.contentInset = insets
    }
    
    func lockScrollViewRight() {
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -scrollView.frame.size.width)
        scrollView.contentInset = insets
    }
    
    func lockScrollViewLeft() {
        let insets = UIEdgeInsets(top: 0, left: -scrollView.frame.size.width, bottom: 0, right: 0)
        scrollView.contentInset = insets
    }
    
    func unlockScrollView() {
        scrollView.contentInset = UIEdgeInsetsZero
    }
    
    func moveToCenter() {
        scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width, y: 0)
    }
    
    
    
    //update textFields
    func updateTextFields() {
        
        // Also needs to update text field content
        if cardIndex > 0 {
            addCardView0.termTextField.text = cards[cardIndex - 1].term
            addCardView0.definitionTextField.text = cards[cardIndex - 1].definition
            println(cardIndex)
        }
        
        addCardView1.termTextField.text = cards[cardIndex].term
        addCardView1.definitionTextField.text = cards[cardIndex].definition
        
        if cardIndex + 1 < cards.count {
            addCardView2.termTextField.text = cards[cardIndex + 1].term
            addCardView2.definitionTextField.text = cards[cardIndex + 1].definition
            println(cardIndex)
            
        } else {
            addCardView2.termTextField.text = nil
            addCardView2.definitionTextField.text = nil
            println(cardIndex)
        }
    }
    
    
    //update textFields for edit
    func updateTextFieldsForEdit(){
        
    }
    
    
}

extension CreateSetViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        if offset.x != scrollView.frame.size.width {
            if offset.x == 0 {
                cardIndex -= 1
            } else {
                cardIndex += 1
            }
            moveToCenter()
            
            
            
            if cardIndex >= cards.count {
                cards.append(Card())
            }
            
            updateTextFields()
            
            // Need to update locking
            updateLocking()
        }
    }
}


