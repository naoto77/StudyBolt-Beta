////
////  Card.swift
////  Flashcard
////
////  Created by Naoto Ohno on 7/24/15.
////  Copyright (c) 2015 Naoto. All rights reserved.
////
//
import Foundation
import Parse
//
class Card: PFObject, PFSubclassing {
    
//    //In this way, which class should have @IBOutlet of text field and save button?
//    //    var titleData: String
//    //    var termData: String
//    //    var definitionData: String
//    
//    
//    //MARK: PFSubclassing Protocol
//    //Does this code access StudySets class on parse? If so why return value is String?
    static func parseClassName() -> String {
        return "Card"
    }
//
//    //What do these codes do? Accessing colums on StudySets class?
    @NSManaged var studySets: StudySets?
    @NSManaged var term: String?
    @NSManaged var definition: String?
//
//    
//    //    //Upload deck created
//    //    func uploadPost() {
//    //
//    //        //let imageData = UIImageJPEGRepresentation(image, 0.8)
//    //        //let imageFile = PFFile(data: imageData)
//    //        //imageFile.save()
//    //
//    //        //self.imageFile = imageFile
//    //        save()
//    //    }
}
