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
import CoreData

class MealsViewController: UIViewController, LiquidFloatingActionButtonDelegate, LiquidFloatingActionButtonDataSource, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var floatingActionButton: LiquidFloatingActionButton!
    var cells: [LiquidFloatingCell] = []
    var meals = [NSManagedObject]()
    @IBOutlet var tabBar: UIView!
    @IBOutlet var collectionView: UICollectionView!
    var mealToSend: NSManagedObject!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
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
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)]
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
        self.tabBarController?.tabBar.barTintColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
        self.tabBarController?.tabBar.tintColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Meal")
        
        //3
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            meals = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        self.collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //
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
    //
    
    //CollectionView start
    // tell the collection view how many cells to make
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meals.count
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:CardCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CardCollectionViewCell
        let meal = meals[indexPath.row]
        //cell.layer.masksToBounds = false

        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.TitleLabel.textColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        cell.TitleLabel.text = meal.valueForKey("mealTitle") as? String
        cell.DescriptionLabel.textColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        cell.DescriptionLabel.text = meal.valueForKey("mealDescription") as? String
        cell.DescriptionLabel.backgroundColor = UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1)
        cell.backgroundColor = UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1)
        //cell.Image.image = UIImage(named: "lsf-meal_48_0_f44024_none.png")
        if(meal.valueForKey("mealImage") != nil){
        let imageData: NSData = meal.valueForKey("mealImage") as! NSData
        cell.Image.image = UIImage(data: imageData)
        }
        
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.layer.bounds, cornerRadius: 2).CGPath
        cell.layer.cornerRadius = 2
        cell.layer.shadowColor = UIColor.blackColor().CGColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.layer.shadowRadius = 1
        cell.layer.shadowOpacity = 0.5
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        mealToSend = meals[indexPath.item] as NSManagedObject
        print("You selected cell #\(indexPath.item)!")
        performSegueWithIdentifier("withDataSegue", sender: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "withDataSegue")
        {
            let vc = segue.destinationViewController as! NewMealViewController
            vc.meal = mealToSend
        }
    }
}

