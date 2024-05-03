//
//  FoodRecipeListCollectionViewController.swift
//  RecipeApp
//
//  Created by Knee Shin Cong on 01/05/2024.
//

import UIKit

private let reuseIdentifier = SharedUIConstants.CELL.FOOD_RECIPE_LIST_COLLECTION_VIEW

protocol FoodRecipeListCollectionViewControllerDelegate
{
    func collectionViewCellOnClicked(foodRecipe: FoodRecipeModel)
}

class FoodRecipeListCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{

    var passedInRecipeList: [FoodRecipeModel] = []
    var delegate: FoodRecipeListCollectionViewControllerDelegate?
    
    // ===========================================================================
    // MARK: - Init
    // ===========================================================================
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.collectionView.register(UINib(nibName: String(describing: FoodRecipeListCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) 
    {
        super.viewDidAppear(animated)
    }
    
    func reloadData()
    {
        self.collectionView.reloadData()
    }
    
    // ===========================================================================
    // MARK: - UICollectionViewDataSource
    // ===========================================================================
    override func numberOfSections(in collectionView: UICollectionView) -> Int 
    {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int 
    {
        return passedInRecipeList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell 
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FoodRecipeListCollectionViewCell
        
        cell.configure(foodRecipe: passedInRecipeList[indexPath.row])
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) 
    {
        delegate?.collectionViewCellOnClicked(foodRecipe: passedInRecipeList[indexPath.row])
    }
    
    // ===========================================================================
    // MARK: - UICollectionViewDelegateFlowLayout
    // ===========================================================================
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        // Calculate the size of the cell here
        var preferredWidth: CGFloat? = 150
        let numOfColumn = 2 //numOfColumn
        let interitemSpace = CGFloat(numOfColumn) * 16
        let insets = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        
        let availableWidth = self.view.frame.width - interitemSpace - insets.left - insets.right
        let netWidthPerCell = availableWidth / CGFloat(numOfColumn)
        
        preferredWidth = netWidthPerCell
        
        let targetSize = CGSize(width: preferredWidth!, height: preferredWidth!)
        return targetSize
    }
    
    // UICollectionViewDelegateFlowLayout method to set the spacing between rows and sections
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat 
    {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat 
    {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let insets = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        
        return insets
    }

}
