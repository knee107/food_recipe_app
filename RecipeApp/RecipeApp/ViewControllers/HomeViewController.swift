//
//  ViewController.swift
//  RecipeApp
//
//  Created by Knee Shin Cong on 01/05/2024.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, RecipeTypeSelectListViewControllerDelegate, FoodRecipeListCollectionViewControllerDelegate, FoodDetailAddEditViewControllerDelegate, FoodRecipeDetailViewControllerDelegate
{
    @IBOutlet weak var recipeTypeBtn: UIButton!
    var recipeList: [FoodRecipeModel] = []
    var currentRecipeType: String? = "All"

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        recipeTypeBtn.layer.cornerRadius = recipeTypeBtn.frame.width / 2
    }
    
    // ===========================================================================
    // MARK: - Navigation
    // ===========================================================================
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch segue.identifier
        {
        case SharedUIConstants.SEGUE.RECIPE_TYPE_SELECT_LIST:
            if let dest = segue.destination as? RecipeTypeSelectListViewController
            {
                dest.delegate = self
            }
            
        case SharedUIConstants.SEGUE.FOOD_RECIPE_LIST:
            if let dest = segue.destination as? FoodRecipeListCollectionViewController
            {
                recipeList = SharedUtil.retrieveData()
                dest.passedInRecipeList = recipeList
                
                dest.delegate = self
            }
            
        case SharedUIConstants.SEGUE.FOOD_DETAIL_ADD_EDIT:
            if let dest = segue.destination as? FoodDetailAddEditViewController
            {
                dest.delegate = self
            }
            
        case SharedUIConstants.SEGUE.FOOD_RECIPE_DETAIL:
            if let dest = segue.destination as? FoodRecipeDetailViewController
            {
                if let foodRecipeDetail = sender as? FoodRecipeModel
                {
                    dest.delegate = self
                    dest.passedInFoodRecipeDetail = foodRecipeDetail
                }
            }
            
        default:
            break
        }
        
    }

    // ===========================================================================
    // MARK: - RecipeTypeSelectListViewController
    // ===========================================================================
    
    @IBAction func recipeTypeButtonOnClicked()
    {
        performSegue(withIdentifier: SharedUIConstants.SEGUE.RECIPE_TYPE_SELECT_LIST, sender: self)
    }
    
    func recipeTypeListOnItemClicked(recipeType: String?, index: Int) 
    {
        recipeTypeBtn.setTitle("Category: \(recipeType ?? "")", for: .normal)
        filterRecipeListWithRecipeType(recipeType: recipeType!)
        currentRecipeType = recipeType
        reloadCollectionView()
    }
    
    // ===========================================================================
    // MARK: - FoodRecipeListCollectionViewControllerDelegate
    // ===========================================================================
    func collectionViewCellOnClicked(foodRecipe: FoodRecipeModel)
    {
        performSegue(withIdentifier: SharedUIConstants.SEGUE.FOOD_RECIPE_DETAIL, sender: foodRecipe)
    }
    
    func reloadCollectionView() 
    {
        if let collectionViewVC = children.first as? FoodRecipeListCollectionViewController
        {
            filterRecipeListWithRecipeType(recipeType: currentRecipeType!)
            collectionViewVC.passedInRecipeList = recipeList
            collectionViewVC.reloadData()
        }
    }
    
    // ===========================================================================
    // MARK: - FoodDetailAddEditViewControllerDelegate
    // ===========================================================================
    func saveEditButtonOnClicked(foodRecipe: FoodRecipeModel) 
    {
        let isExistingFoodRecipe = SharedUtil.retrieveData().contains(where: { $0.recipeName == foodRecipe.recipeName })
        
        if isExistingFoodRecipe
        {
            SharedUtil.updateData(recipeDetail: foodRecipe)
        }
        else
        {
            SharedUtil.createData(recipeDetail: foodRecipe)
        }
        
        self.navigationController?.popViewController(animated: true)
        recipeList = SharedUtil.retrieveData()
        reloadCollectionView()
    }
    
    // ===========================================================================
    // MARK: - FoodRecipeDetailViewControllerDelegate
    // ===========================================================================
    func deleteFoodRecipeBtnOnClicked(foodRecipe: FoodRecipeModel) 
    {
        SharedUtil.deleteData(recipeDetail: foodRecipe)
        self.navigationController?.popViewController(animated: true)
        recipeList = SharedUtil.retrieveData()
        reloadCollectionView()
    }
    
    // ===========================================================================
    // MARK: - Private Method
    // ===========================================================================
    private func filterRecipeListWithRecipeType(recipeType: String)
    {
        recipeList = SharedUtil.retrieveData()
        
        if recipeType != "All"
        {
            recipeList = recipeList.filter { $0.recipeType == recipeType }
        }
    }
}

