//
//  FlashCardViewController.swift
//  Flashcard
//
//  Created by Naoto Ohno on 7/30/15.
//  Copyright (c) 2015 Naoto. All rights reserved.
//

import Foundation
import Parse
import ConvenienceKit

class FlashCardViewController: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    //flash card view outlet
    @IBOutlet weak var flashCardView0: FlashCardView!
    @IBOutlet weak var flashCardView1: FlashCardView!
    @IBOutlet weak var flashCardView2: FlashCardView!
    
    var cardsObjects = [Card]()
    
    var cardIndex = 0
    
    //studySet object passed from StudySetViewController
    var studySet : StudySets!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        
        //fetch Card class from Parse and sort it by StudySets pointer
        var cardsQuery = PFQuery(className: Card.parseClassName())//Card.parseClassName is same as "Card"
        cardsQuery.whereKey("studySets", equalTo: studySet)
        //the values are optional so unwrap it by optional binding
        if let cards = cardsQuery.findObjects() as? [Card] {
            cardsObjects = cards
        }
        
        //this tells self class instance is set to delegate of scrollView
        scrollView.delegate = self //should I change the name? cuz scrollView already exists in CreateSetViewController
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let termString = cardsObjects[0].term
        flashCardView0.termInFlashCard.text = termString
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //methods controlling placements of views in scroll view
    func moveToCenter() {
        scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width, y: 0)
    }
    
    
}



extension FlashCardViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        if offset.y != scrollView.frame.size.height {
            if offset.y == 0 {
                cardIndex -= 1
            } else {
                cardIndex += 1
            }
            moveToCenter()
            
            // Also needs to update text field content
            if cardIndex > 0 {
                flashCardView0.termInFlashCard.text = cardsObjects[cardIndex - 1].term
            }
            flashCardView1.termInFlashCard.text = cardsObjects[cardIndex].term
            
            if cardIndex + 1 < cardsObjects.count {
                flashCardView2.termInFlashCard.text = cardsObjects[cardIndex + 1].term
            } else {
                flashCardView2.termInFlashCard.text = nil
            }
            
        }
    }
}

