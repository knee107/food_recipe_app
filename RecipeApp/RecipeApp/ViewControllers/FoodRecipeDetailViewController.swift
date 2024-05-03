//
//  FoodRecipeDetailViewController.swift
//  RecipeApp
//
//  Created by Knee Shin Cong on 02/05/2024.
//

import UIKit

protocol FoodRecipeDetailViewControllerDelegate
{
    func deleteFoodRecipeBtnOnClicked(foodRecipe: FoodRecipeModel)
}

class FoodRecipeDetailViewController: UIViewController, FoodDetailAddEditViewControllerDelegate
{
    @IBOutlet weak var editBarBtn: UIBarButtonItem!
    @IBOutlet weak var deleteBarBtn: UIBarButtonItem!
    @IBOutlet weak var foodRecipeImgView: UIImageView!
    @IBOutlet weak var lblFoodRecipeName: UILabel!
    @IBOutlet weak var lblFoodRecipeType: UILabel!
    @IBOutlet weak var lblFoodRecipeIngredients: UILabel!
    @IBOutlet var foodRecipeStepView: UIStackView!
    
    var passedInFoodRecipeDetail: FoodRecipeModel?
    var delegate: FoodRecipeDetailViewControllerDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        initUI()
        // Do any additional setup after loading the view.
    }
    
    private func initUI()
    {
        foodRecipeImgView.image = passedInFoodRecipeDetail?.recipeImage
        lblFoodRecipeName.text = passedInFoodRecipeDetail?.recipeName
        lblFoodRecipeType.text = passedInFoodRecipeDetail?.recipeType
        lblFoodRecipeIngredients.text = passedInFoodRecipeDetail?.recipeIngredients
        
        var totalHeight:CGFloat = 0
        
        removeAllSubviewInStepView()
        
        if let unwrapSteps = passedInFoodRecipeDetail?.recipeSteps
        {
            for (index, step) in unwrapSteps.enumerated()
            {
                let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: self.foodRecipeStepView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
                stackView.axis = .horizontal
                stackView.alignment = .leading
                stackView.distribution = .fillProportionally
                stackView.translatesAutoresizingMaskIntoConstraints = false
                
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 15.0, height: CGFloat.greatestFiniteMagnitude))
                label.text = "\(index+1). "
                label.numberOfLines = 0
                label.setContentHuggingPriority(.required, for: .horizontal)
                label.setContentCompressionResistancePriority(.required, for: .horizontal)
                label.translatesAutoresizingMaskIntoConstraints = false
                stackView.addArrangedSubview(label)
                
                let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: 250.0, height: CGFloat.greatestFiniteMagnitude))
                label2.text = "\(step)"
                label2.numberOfLines = 0
                label2.translatesAutoresizingMaskIntoConstraints = false
                label2.lineBreakMode = NSLineBreakMode.byWordWrapping
                label2.sizeToFit()
                stackView.addArrangedSubview(label2)
                
                foodRecipeStepView.addArrangedSubview(stackView)
            }
        }
        else
        {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: foodRecipeStepView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
            label.text = "-"
            label.translatesAutoresizingMaskIntoConstraints = false
            self.foodRecipeStepView.addSubview(label)

            totalHeight += 6

            label.leadingAnchor.constraint(equalTo: self.foodRecipeStepView.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: self.foodRecipeStepView.trailingAnchor).isActive = true

            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.sizeToFit()
            totalHeight += label.frame.size.height
        }
        
        editBarBtn.target = self
        deleteBarBtn.target = self
    }
    
    @IBAction func editBtnOnClicked()
    {
        performSegue(withIdentifier: SharedUIConstants.SEGUE.FOOD_DETAIL_ADD_EDIT, sender: nil)
    }
    
    @IBAction func deleteBtnOnCLicked()
    {
        delegate?.deleteFoodRecipeBtnOnClicked(foodRecipe: passedInFoodRecipeDetail!)
    }
    
    // ===========================================================================
    // MARK: - Navigation
    // ===========================================================================
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch segue.identifier
        {
        case SharedUIConstants.SEGUE.FOOD_DETAIL_ADD_EDIT:
            if let dest = segue.destination as? FoodDetailAddEditViewController
            {
                dest.delegate = self
                dest.isEditMode = true
                dest.passedInFoodRecipe = passedInFoodRecipeDetail
            }
            
        default:
            break
        }
        
    }
    
    // ===========================================================================
    // MARK: - FoodDetailAddEditViewControllerDelegate
    // ===========================================================================
    
    func saveEditButtonOnClicked(foodRecipe: FoodRecipeModel)
    {
        self.navigationController?.popViewController(animated: true)
        
        SharedUtil.updateData(recipeDetail: foodRecipe)
        passedInFoodRecipeDetail = foodRecipe
        initUI()
    }
    
    private func removeAllSubviewInStepView()
    {
        for subview in foodRecipeStepView.arrangedSubviews 
        {
            foodRecipeStepView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }

}
