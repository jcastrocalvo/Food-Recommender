//
//  NewMenuViewController.swift
//  FoodRecommender
//
//  Created by Joaquin Castro-Calvo on 3/13/16.
//  Copyright © 2016 Joaquin Castro-Calvo. All rights reserved.
//

import UIKit
import CoreData
import LiquidFloatingActionButton
import Social

class NewMenuViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, LiquidFloatingActionButtonDelegate, LiquidFloatingActionButtonDataSource {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var menuBox: UITextField!
    @IBOutlet weak var menuDescriptionBox: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    var floatingActionButton: LiquidFloatingActionButton!
    var cells: [LiquidFloatingCell] = []
    var menu: NSManagedObject!
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var imageWasTaken: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        if(menu == nil){
            deleteButton.hidden = true
        }else{
            menuBox.text = menu.valueForKey("menuName") as? String
            menuDescriptionBox.text = menu.valueForKey("menuDescription") as? String
            if(menu.valueForKey("menuImage") != nil){
                let imageData: NSData = menu.valueForKey("menuImage") as! NSData
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
        //self.parentViewController?.view.addSubview(bottomRightButton)
        self.view.addSubview(bottomRightButton)
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.parentViewController?.navigationController?.navigationBarHidden = true
        self.navigationController?.navigationBarHidden = true
    }
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.parentViewController?.navigationController?.navigationBarHidden = true
        self.navigationController?.navigationBarHidden = false
    }
    

    @IBAction func Save(sender: AnyObject) {
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        if(menu == nil){
            let entity =  NSEntityDescription.entityForName("Menu",
                inManagedObjectContext:managedContext)
            let meal = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            if(imageView.image != nil){
                let imageData: NSData = UIImageJPEGRepresentation(imageView.image!, 1)!
                meal.setValue(imageData, forKey: "menuImage")
            }
            
            meal.setValue(menuBox.text, forKey: "menuName")
            meal.setValue(menuDescriptionBox.text, forKey: "menuDescription")
            
            do {
                try managedContext.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }else{
            menu.setValue(menuBox.text, forKey: "menuName")
            menu.setValue(menuDescriptionBox.text, forKey: "menuDescription")
            if(imageView.image != nil){
                let imageData: NSData = UIImageJPEGRepresentation(imageView.image!, 1)!
                menu.setValue(imageData, forKey: "menuImage")
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
    
    
    @IBAction func Back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func Delete(sender: AnyObject) {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        managedContext.deleteObject(menu)
        
        do {
            try managedContext.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func useCamera(sender: AnyObject) {
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
    
    @IBAction func openGallery(sender: AnyObject) {
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
                twitterSheet.setInitialText("Check out this great meal called " + menuBox.text! + " the best way to describe it is " + menuDescriptionBox.text!)
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
                facebookSheet.setInitialText("Check out this great meal called " + menuBox.text! + " the best way to describe it is " + menuDescriptionBox.text!)
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
