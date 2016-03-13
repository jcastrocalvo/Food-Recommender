//
//  Meal+CoreDataProperties.swift
//  
//
//  Created by Joaquin Castro-Calvo on 3/12/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Meal {

    @NSManaged var mealTitle: String?
    @NSManaged var mealDescription: String?
    @NSManaged var mealImagePath: String?

}
