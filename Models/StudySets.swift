//
//  StudySets.swift
//  Flashcard
//
//  Created by Naoto Ohno on 7/24/15.
//  Copyright (c) 2015 Naoto. All rights reserved.
//

import Foundation
import Parse

class StudySets: PFObject, PFSubclassing {
    
    //In this way, which class should have @IBOutlet of text field and save button?
//    var titleData: String
//    var termData: String
//    var definitionData: String
    
    
    //MARK: PFSubclassing Protocol
    //Does this code access StudySets class on parse? If so why return value is String?
    //Yes, it does access the class on Parse
    static func parseClassName() -> String {
        return "StudySets"
    }
    

    //What do these codes do? Accessing colums on StudySets class?
    //Yes, those codes are accessing the colums on StudySets class on Parse
    @NSManaged var user: PFUser?
    @NSManaged var title: String?
    @NSManaged var numberOfCards: NSNumber?
   
    
    
//    //Upload deck created
//    func uploadPost() {
//        
//        //let imageData = UIImageJPEGRepresentation(image, 0.8)
//        //let imageFile = PFFile(data: imageData)
//        //imageFile.save()
//        
//        //self.imageFile = imageFile
//        save()
//    }
}
