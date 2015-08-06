//
//  SettingViewController.swift
//  Flashcard
//
//  Created by Naoto Ohno on 8/4/15.
//  Copyright (c) 2015 Naoto. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class SettingViewController: UITableViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    @IBAction func logout(sender: AnyObject!){
        PFUser.logOut()
        var currentUser = PFUser.currentUser()
        if currentUser == nil {}
        
        //NSNotification with func application in appDelegate
        NSNotificationCenter.defaultCenter().postNotificationName("UserLoggedOut", object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    
}