//
//  ParseHelper.swift
//  Flashcard
//
//  Created by Naoto Ohno on 7/20/15.
//  Copyright (c) 2015 Naoto. All rights reserved.
//

import Foundation
import Parse

class ParseHelper {
    
    static func studysetRequestforCurrentUser(range: Range<Int>, completionBlock: PFQueryArrayResultBlock) {
        let query = PFQuery(className: "StudySets")
        query.whereKey("user", equalTo:PFUser.currentUser()!)
        
        
        query.skip = range.startIndex
        
        query.limit = range.endIndex - range.startIndex
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
}
