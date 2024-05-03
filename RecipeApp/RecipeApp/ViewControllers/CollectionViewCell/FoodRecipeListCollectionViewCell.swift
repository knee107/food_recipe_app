//
//  FoodRecipeListCollectionViewCell.swift
//  RecipeApp
//
//  Created by Knee Shin Cong on 01/05/2024.
//

import UIKit

class FoodRecipeListCollectionViewCell: UICollectionViewCell 
{
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var lblFoodTitle: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() 
    {
        self.layoutIfNeeded()
    }
    
    func configure(foodRecipe: FoodRecipeModel)
    {
        if let image = foodRecipe.recipeImage ?? UIImage(named: "food_image_default")
        {
            self.foodImage.image = image
        }
        else
        {
            print("Image Not Found!!!")
        }
        
        self.lblFoodTitle.text = foodRecipe.recipeName
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
