
//  AppDelegate.swift
//  Flashcard
//
//  Created by Naoto Ohno on 7/17/15.
//  Copyright (c) 2015 Naoto. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4
import ParseUI


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var parseLoginHelper: ParseLoginHelper!
    
    override init() {
        super.init()
        
        parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
            // Initialize the ParseLoginHelper with a callback
            if let error = error {
                // 1
                ErrorHandling.defaultErrorHandler(error)
            } else  if let user = user {
                // if login was successful, display the NavBarController
                // 2
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let NavBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
                // 3
                //                self.window?.rootViewController!.presentViewController(NavBarController, animated:true, completion:nil)
                self.window?.rootViewController = NavBarController            }
        }
    }
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //Register Parse class? Ask why is this neccesary. Also do I have to register "User" too?
        StudySets.registerSubclass()
        Card.registerSubclass()
        
        
        Parse.setApplicationId("qHfjy6kpBVVbVRC2Wne4t3h40iO1AUwZNvybFQBz", clientKey: "bRjnuE2RwhrO5MxCLQImlm5nPyD8vqYfvdl772xg")
        
        
        //PFUser.logInWithUsername("test", password: "test")
        
        print(PFUser.currentUser())
        
        
        // Initialize Facebook
        // 1
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        // check if we have logged in user
        // 2
        let user = PFUser.currentUser()
        
        let startViewController: UIViewController;
        
        if (user != nil) {
            // 3
            // if we have a user, set the NavBarController to be the initial View Controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            startViewController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        } else {
            // 4
            // Otherwise set the LoginViewController to be the first
            let loginViewController = LogInViewController()
            loginViewController.fields = [
                PFLogInFields.UsernameAndPassword,
                PFLogInFields.LogInButton,
                PFLogInFields.SignUpButton,
                PFLogInFields.PasswordForgotten,
                PFLogInFields.Facebook
            ]
            loginViewController.delegate = parseLoginHelper
            loginViewController.signUpController?.delegate = parseLoginHelper
            
            startViewController = loginViewController
        }
        
        // 5
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = startViewController;
        self.window?.makeKeyAndVisible()
        
        
        //UICollor setting
        UINavigationBar.appearance().barTintColor = StyleConstants.pastelPurple
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UINavigationBar.appearance().translucent = false
        
        UIToolbar.appearance().barTintColor = StyleConstants.pastelPurple
        UIToolbar.appearance().tintColor = UIColor.whiteColor()
        UIToolbar.appearance().translucent = false
        
        
        
        //NSNotification with func logout in setting
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("userLoggedOut"), name: "UserLoggedOut", object: nil)
        
        //Set UIStatusBar color white
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        // Override point for customization after application launch.
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
    }
    
    func userLoggedOut() {
        
        let loginViewController = LogInViewController()
        loginViewController.fields = [
            PFLogInFields.UsernameAndPassword,
            PFLogInFields.LogInButton,
            PFLogInFields.SignUpButton,
            PFLogInFields.PasswordForgotten,
            PFLogInFields.Facebook
        ]
        loginViewController.delegate = parseLoginHelper
        loginViewController.signUpController?.delegate = parseLoginHelper
        
        window?.rootViewController = loginViewController
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    
    //MARK: Facebook Integration
    //Boilerplate code for FacebookSDK
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    //Boilerplate code for FacebookSDK
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

