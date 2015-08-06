//
//  LoginViewController.swift
//  Flashcard
//
//  Created by Naoto Ohno on 8/6/15.
//  Copyright (c) 2015 Naoto. All rights reserved.
//

import Foundation
import Parse
import ParseUI


class LogInViewController : PFLogInViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = StyleConstants.pastelPurple
        let logoView = UIImageView(image: UIImage(named:"FlashcardLogo2.png"))
        
        self.logInView!.logo = logoView
    }
}