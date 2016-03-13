//
//  FirstViewController.swift
//  FoodRecommender
//
//  Created by Joaquin Castro-Calvo on 3/4/16.
//  Copyright © 2016 Joaquin Castro-Calvo. All rights reserved.
//

import UIKit
import LiquidFloatingActionButton
import Social

class MealsViewController: UIViewController, LiquidFloatingActionButtonDelegate, LiquidFloatingActionButtonDataSource, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48"]
    
    var floatingActionButton: LiquidFloatingActionButton!
    var cells: [LiquidFloatingCell] = []
    @IBOutlet var tabBar: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //liquidbutton start
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
        cells.append(cellFactory("lsf-meal_48_0_f44024_none.png"))
        cells.append(cellFactory("brandico-twitter-bird_48_0_f44024_none.png"))
        cells.append(cellFactory("brandico-facebook_48_0_f44024_none.png"))
        let floatingFrame = CGRect(x: self.view.frame.width - 70, y: (self.view.frame.height - (self.tabBarController?.tabBar.frame.height)! - 60), width: 56, height: 56)
        let bottomRightButton = createButton(floatingFrame, .Up)
        self.view.addSubview(bottomRightButton)
        //liquid button end
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor(red: 243/255, green: 58/255, blue: 36/255, alpha: 1)]
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
        self.tabBarController?.tabBar.barTintColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
        self.tabBarController?.tabBar.tintColor = UIColor(red: 243/255, green: 58/255, blue: 36/255, alpha: 1)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Liquid button start
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
            
            performSegueWithIdentifier("addNewMeal", sender: nil)
        }
    }
    //liquid button end
    
    
    //CollectionView start
    // tell the collection view how many cells to make
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        //let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CardCollectionViewCell
        let cell:CardCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CardCollectionViewCell
        
//        cell.frame = CGRect(x: self.collectionView.frame.width * 0.1, y: self.collectionView.frame.height * 0.03, width: self.collectionView.frame.width - (self.collectionView.frame.width * 0.2), height: self.collectionView.frame.height * 0.33)
        
        cell.layer.shadowColor = UIColor.blackColor().CGColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 4)
        cell.layer.shadowOpacity = 0.8
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.layer.bounds, cornerRadius: 2).CGPath
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.TitleLabel.text = items[indexPath.row]
        cell.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 0.9) // make cell more visible in our example project
        cell.Image.image = UIImage(named: "lsf-meal_48_0_f44024_none.png")
        cell.DescriptionLabel.text = "This is a very long sentence that I hope it gets pushed down but we will see if this even works now that I think about it, it probably will not work at all."
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
}

