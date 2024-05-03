//
//  FoodRecipeModel.swift
//  RecipeApp
//
//  Created by Knee Shin Cong on 01/05/2024.
//

import UIKit

class FoodRecipeModel: NSObject 
{
    var recipeName: String?
    var recipeType: String?
    var recipeImage: UIImage?
    var recipeIngredients: String?
    var recipeSteps: [String]?
    
    init(recipeName: String? = nil, recipeType: String? = nil, recipeImage: UIImage? = nil, recipeIngredients: String? = nil, recipeSteps: [String]? = nil)
    {
        self.recipeName = recipeName
        self.recipeType = recipeType
        self.recipeImage = recipeImage
        self.recipeIngredients = recipeIngredients
        self.recipeSteps = recipeSteps
    }
}
