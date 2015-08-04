//
//  StudySetsScreen.swift
//  Flashcard
//
//  Created by Naoto Ohno on 7/21/15.
//  Copyright (c) 2015 Naoto. All rights reserved.
//

import Foundation
import UIKit

class StudySetsScreen: UIViewController {
    
    //Declare properties that you use
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    
    
    //create instances of UIObjects
    var searchBar = UISearchBar()
    var tableView = UITableView()
    var studySetCell = UITableViewCell()
    var testLbl = UILabel()
    
    
    //setFrames
    func setFrames(){
        searchBar.frame = CGRect(x: 0, y: width/2, width: width, height: height/15 )
        
        testLbl.frame = CGRect(x: 0, y: 0, width: width, height: height/6)
    }
    
    
    //initializer
    func initializeObject(){
        testLbl.textAlignment = .Center
        testLbl.text = "text Text"
        testLbl.font = UIFont(name: "HelveticaNeue-Bold", size: width/10)
    }
    
    
    //addViews
    func addViews(){
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(studySetCell)
        view.addSubview(testLbl)
    }
    
    
    //display on screen
    override func viewDidLoad() {
        super.viewDidLoad()
        width = view.bounds.width
        height = view.bounds.height
        
        setFrames()
        addViews()
        initializeObject()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
