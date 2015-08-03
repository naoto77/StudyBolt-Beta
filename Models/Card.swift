//
//  Card.swift
//  Flashcard
//
//  Created by Naoto Ohno on 7/24/15.
//  Copyright (c) 2015 Naoto. All rights reserved.
//

import Foundation
import Parse

class Card: PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "Card"
    }

    //What do these codes do? Accessing colums on StudySets class?
    @NSManaged var studySets: StudySets?
    @NSManaged var term: String?
    @NSManaged var definition: String?
}
