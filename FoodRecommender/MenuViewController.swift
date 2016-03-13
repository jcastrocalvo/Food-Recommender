//
//  SecondViewController.swift
//  FoodRecommender
//
//  Created by Joaquin Castro-Calvo on 3/4/16.
//  Copyright © 2016 Joaquin Castro-Calvo. All rights reserved.
//

import UIKit
import LiquidFloatingActionButton
import Social
import CoreData

class MenuViewController: UIViewController, LiquidFloatingActionButtonDelegate, LiquidFloatingActionButtonDataSource {

    var floatingActionButton: LiquidFloatingActionButton!
    var cells: [LiquidFloatingCell] = []
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var descriptionBox: UITextView!
    @IBOutlet var titleBox: UILabel!
    var chosenMenu: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (chosenMenu != nil){
            descriptionBox.text = chosenMenu.valueForKey("menuDescription") as? String
            titleBox.text = chosenMenu.valueForKey("menuTitle") as? String
            if(chosenMenu.valueForKey("menuImage") != nil){
                let imageData: NSData = chosenMenu.valueForKey("menuImage") as! NSData
                imageView.image = UIImage(data: imageData)
            }
        }else{
            descriptionBox.hidden = true
            titleBox.hidden = true
        }
        //liquid start
        let createButton: (CGRect, LiquidFloatingActionButtonAnimateStyle) -> LiquidFloatingActionButton = { (frame, style) in
            let floatingActionButton = LiquidFloatingActionButton(frame: frame)
            floatingActionButton.animateStyle = style
            floatingActionButton.dataSource = self
            floatingActionButton.delegate = self
            return floatingActionButton
        }
        
        let cellFactory: (String) -> LiquidFloatingCell = { (iconName) in
            return LiquidFloatingCell(icon: UIImage(named: iconName)!)
        }
        cells.append(cellFactory("fa-map_48_0_f44024_none.png"))
        cells.append(cellFactory("brandico-twitter-bird_48_0_f44024_none.png"))
        cells.append(cellFactory("brandico-facebook_48_0_f44024_none.png"))
        
        let floatingFrame = CGRect(x: self.view.frame.width - 70, y: (self.view.frame.height - (self.tabBarController?.tabBar.frame.height)! - 60), width: 56, height: 56)
        let bottomRightButton = createButton(floatingFrame, .Up)
        
        self.view.addSubview(bottomRightButton)
        //liquid end
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)]
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
        self.tabBarController?.tabBar.barTintColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
        self.tabBarController?.tabBar.tintColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        // Do any additional setup after loading the view, typically from a nib.
        
        self.refreshUI()
    }
    
    func refreshUI() {
        if (chosenMenu != nil){
            descriptionBox.text = chosenMenu.valueForKey("menuDescription") as? String
            titleBox.text = chosenMenu.valueForKey("menuTitle") as? String
            if(chosenMenu.valueForKey("menuImage") != nil){
                let imageData: NSData = chosenMenu.valueForKey("menuImage") as! NSData
                imageView.image = UIImage(data: imageData)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfCells(liquidFloatingActionButton: LiquidFloatingActionButton) -> Int{
        return cells.count
    }
    
    func cellForIndex(index: Int) -> LiquidFloatingCell{
        return cells[index]
    }
    
    func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int){
        liquidFloatingActionButton.close()
        if(index == 1){
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
                let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                twitterSheet.setInitialText("Share on Twitter")
                self.presentViewController(twitterSheet, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }else if(index == 2){
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
                let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebookSheet.setInitialText("Share on Facebook")
                self.presentViewController(facebookSheet, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }else{
            performSegueWithIdentifier("addNewMenuItem", sender: nil)
        }

    }

}

