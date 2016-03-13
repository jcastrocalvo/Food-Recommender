//
//  NewMealViewController.swift
//  FoodRecommender
//
//  Created by Joaquin Castro-Calvo on 3/12/16.
//  Copyright © 2016 Joaquin Castro-Calvo. All rights reserved.
//

import UIKit
import CoreData

class NewMealViewController: UIViewController {

    @IBOutlet weak var MealTitleText: UITextField!
    @IBOutlet weak var MealDescriptionText: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    var meal: NSManagedObject!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        if(meal == nil){
            deleteButton.hidden = true
        }
        // Do any additional setup after loading the view.
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
        
        let entity =  NSEntityDescription.entityForName("Meal",
            inManagedObjectContext:managedContext)
        
        let meal = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        meal.setValue(MealTitleText.text, forKey: "mealTitle")
        meal.setValue(MealDescriptionText.text, forKey: "mealDescription")
        
        do {
            try managedContext.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }

        navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func Deletege(sender: AnyObject) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
