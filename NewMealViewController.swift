//
//  NewMealViewController.swift
//  FoodRecommender
//
//  Created by Joaquin Castro-Calvo on 3/12/16.
//  Copyright © 2016 Joaquin Castro-Calvo. All rights reserved.
//

import UIKit
import CoreData
import LiquidFloatingActionButton
import Social

class NewMealViewController: UIViewController, LiquidFloatingActionButtonDelegate, LiquidFloatingActionButtonDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var MealTitleText: UITextField!
    @IBOutlet weak var MealDescriptionText: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var meal: NSManagedObject!
    var floatingActionButton: LiquidFloatingActionButton!
    var cells: [LiquidFloatingCell] = []
    var imageWasTaken: Bool = false
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.navigationController?.navigationBarHidden = true
        
        if(meal == nil){
            deleteButton.hidden = true
        }else{
            MealTitleText.text = meal.valueForKey("mealTitle") as? String
            MealDescriptionText.text = meal.valueForKey("mealDescription") as? String
            if(meal.valueForKey("mealImage") != nil){
                let imageData: NSData = meal.valueForKey("mealImage") as! NSData
                imageView.image = UIImage(data: imageData)
            }
        }
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
        cells.append(cellFactory("brandico-twitter-bird_48_0_f44024_none.png"))
        cells.append(cellFactory("brandico-facebook_48_0_f44024_none.png"))
        let floatingFrame = CGRect(x: self.view.frame.width - 70, y: (self.view.frame.height - (self.tabBarController?.tabBar.frame.height)! - 60), width: 56, height: 56)
        let bottomRightButton = createButton(floatingFrame, .Up)
        self.view.addSubview(bottomRightButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    @IBAction func Save(sender: AnyObject) {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        if(meal == nil){
            let entity =  NSEntityDescription.entityForName("Meal",
                inManagedObjectContext:managedContext)
            let meal = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            if(imageView.image != nil){
                let imageData: NSData = UIImageJPEGRepresentation(imageView.image!, 1)!
                meal.setValue(imageData, forKey: "mealImage")
            }
            
            meal.setValue(MealTitleText.text, forKey: "mealTitle")
            meal.setValue(MealDescriptionText.text, forKey: "mealDescription")
            
            do {
                try managedContext.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }else{
            meal.setValue(MealTitleText.text, forKey: "mealTitle")
            meal.setValue(MealDescriptionText.text, forKey: "mealDescription")
            if(imageView.image != nil){
                let imageData: NSData = UIImageJPEGRepresentation(imageView.image!, 1)!
                meal.setValue(imageData, forKey: "mealImage")
            }
            do {
                try managedContext.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func Deletege(sender: AnyObject) {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        managedContext.deleteObject(meal)
        
        do {
            try managedContext.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func takePhotoButton(sender: AnyObject) {
        if(UIImagePickerController.isSourceTypeAvailable(.Camera)){
            if(UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil){
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .Camera
                imagePicker.cameraCaptureMode = .Photo
                imageWasTaken = true
                presentViewController(imagePicker, animated: true, completion: {})
            }
        }else{
            let alert = UIAlertController(title: "No camera", message: "This device has no camera available", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func useGalleryButton(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
            if(imageWasTaken == true){
                let selectorToCall = Selector("imageWasSavedSuccessfully:didFinishSavingWithError:context:")
                UIImageWriteToSavedPhotosAlbum(pickedImage, self, selectorToCall, nil)
            }
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
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
        if(index == 0){
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
                let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                twitterSheet.setInitialText("Check out this great meal called " + MealTitleText.text! + " the best way to describe it is " + MealDescriptionText.text!)
                if(imageView.image != nil){
                    twitterSheet.addImage(imageView.image)
                }
                self.presentViewController(twitterSheet, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }else if(index == 1){
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
                let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebookSheet.setInitialText("Check out this great meal called " + MealTitleText.text! + " the best way to describe it is " + MealDescriptionText.text!)
                if(imageView.image != nil){
                    facebookSheet.addImage(imageView.image)
                }
                self.presentViewController(facebookSheet, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    //liquid button end
    //
}
