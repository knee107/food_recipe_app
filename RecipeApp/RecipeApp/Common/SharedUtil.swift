//
//  SharedUtil.swift
//  RecipeApp
//
//  Created by Knee Shin Cong on 02/05/2024.
//

import Foundation
import UIKit
import CoreData

struct SharedUtil
{
    static func unwrapBool(_ boolean: Bool?) -> Bool
    {
        return boolean ?? false
    }
    
    static func isEmptyString(_ string: String?) -> Bool
    {
        return (string ?? "").isEmpty
    }
    
    static func checkIsStringContainEmoji(str: String) -> Bool
    {
        let isContainEmoji = str.unicodeScalars.filter({ $0.properties.isEmoji }).count > 0
        let numberCharacters = str.rangeOfCharacter(from: .decimalDigits)
        
        if isContainEmoji && numberCharacters == nil
        {
            return true
        }
        
        return false
    }
    
    static func createData(recipeDetail: FoodRecipeModel)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "FoodRecipeDetail", in: managedContext)!
        
        let recipe = NSManagedObject(entity: entity, insertInto: managedContext)
        recipe.setValue(recipeDetail.recipeName, forKey: "recipeName")
        recipe.setValue(recipeDetail.recipeType, forKey: "recipeType")
        recipe.setValue(recipeDetail.recipeImage?.jpegData(compressionQuality: 1.0), forKey: "recipeImage")
        recipe.setValue(recipeDetail.recipeIngredients, forKey: "recipeIngredients")
        recipe.setValue(recipeDetail.recipeSteps, forKey: "recipeSteps")
        
        do
        {
            try managedContext.save()
        } catch let error as NSError
        {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    static func retrieveData() -> [FoodRecipeModel]
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FoodRecipeDetail")
        
        do
        {
            let result = try managedContext.fetch(fetchRequest)
            
            var recipeList: [FoodRecipeModel] = []
            
            for data in result as! [NSManagedObject]
            {
                
                let foodRecipe = FoodRecipeModel()
                foodRecipe.recipeName = data.value(forKey: "recipeName") as? String
                foodRecipe.recipeType = data.value(forKey: "recipeType") as? String
                
                if let imageData = data.value(forKey: "recipeImage") as? Data
                {
                    foodRecipe.recipeImage = UIImage(data: imageData)
                }
                foodRecipe.recipeIngredients = data.value(forKey: "recipeIngredients") as? String
                foodRecipe.recipeSteps = data.value(forKey: "recipeSteps") as? [String]
                
                recipeList.append(foodRecipe)
            }
            
            return recipeList
        }
        catch
        {
            print("Failed to retrieve data")
        }
        
        return []
    }
    
    static func deleteData(recipeDetail: FoodRecipeModel)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FoodRecipeDetail")
        fetchRequest.predicate = NSPredicate(format: "recipeName = %@", recipeDetail.recipeName ?? "")
        
        do
        {
            let result = try managedContext.fetch(fetchRequest)
            
            if !result.isEmpty
            {
                managedContext.delete(result[0] as! NSManagedObject)
            }
            
            do
            {
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
    }
    
    static func updateData(recipeDetail: FoodRecipeModel)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FoodRecipeDetail")
        fetchRequest.predicate = NSPredicate(format: "recipeName = %@", recipeDetail.recipeName ?? "")
        
        do
        {
            let result = try managedContext.fetch(fetchRequest)
            
            if !result.isEmpty
            {
                let updatedObject = result[0] as! NSManagedObject
                updatedObject.setValue(recipeDetail.recipeName, forKey: "recipeName")
                updatedObject.setValue(recipeDetail.recipeType, forKey: "recipeType")
                updatedObject.setValue(recipeDetail.recipeImage?.jpegData(compressionQuality: 1.0), forKey: "recipeImage")
                updatedObject.setValue(recipeDetail.recipeIngredients, forKey: "recipeIngredients")
                updatedObject.setValue(recipeDetail.recipeSteps, forKey: "recipeSteps")
            }
            else
            {
                print("ERROR :: ITEM NOT FOUND!!!")
            }
            
            do
            {
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
    }
    
    static func deleteAllData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entities = appDelegate.persistentContainer.managedObjectModel.entities
        for entity in entities {
            if let entityName = entity.name {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                do {
                    try managedContext.execute(deleteRequest)
                    try managedContext.save()
                } catch {
                    print("Failed to delete data for entity \(entityName): \(error)")
                }
            }
        }
    }
    
    static func createSimulateData()
    {
        let foodRecipe = FoodRecipeModel(recipeName: "Fried Chicken",
                                         recipeType: "Chicken" ,
                                         recipeImage: UIImage(named: "fried_chicken"),
                                         recipeIngredients: "chicken, black pepper, salt, buttermilk, all-purpose flour",
                                         recipeSteps: ["Step 1", "Step 2", "Step 3", "Step 4", "Step 5", "Step 6"])
        createData(recipeDetail: foodRecipe)
        
        let foodRecipe2 = FoodRecipeModel(recipeName: "Sweet & Sour Pork",
                                         recipeType: "Pork" ,
                                         recipeImage: UIImage(named: "sweet_and_sour_pork"),
                                         recipeIngredients: "pork, soy sauce, ginger, garlic, corn flour",
                                         recipeSteps: ["Step 1", "Step 2", "Step 3", "Step 4", "Step 5", "Step 6"])
        createData(recipeDetail: foodRecipe2)
        
        let foodRecipe3 = FoodRecipeModel(recipeName: "Brocolli Salad",
                                         recipeType: "Vegetable" ,
                                         recipeImage: UIImage(named: "broccoli_salad"),
                                         recipeIngredients: "brocolli, carrot, salt, sugar, lemon",
                                         recipeSteps: ["Step 1", "Step 2", "Step 3", "Step 4", "Step 5", "Step 6"])
        createData(recipeDetail: foodRecipe3)
        
        let foodRecipe4 = FoodRecipeModel(recipeName: "Fish and Chips",
                                         recipeType: "Fish" ,
                                         recipeImage: UIImage(named: "fish_and_chips"),
                                         recipeIngredients: "white fish fillets, black pepper, salt, potatoes, all-purpose flour",
                                         recipeSteps: ["Step 1", "Step 2", "Step 3", "Step 4", "Step 5", "Step 6"])
        createData(recipeDetail: foodRecipe4)
    }
}
