//
//  FoodDetailAddEditViewController.swift
//  RecipeApp
//
//  Created by Knee Shin Cong on 01/05/2024.
//

import UIKit

protocol FoodDetailAddEditViewControllerDelegate
{
    func saveEditButtonOnClicked(foodRecipe: FoodRecipeModel)
}

class FoodDetailAddEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RecipeTypeSelectListViewControllerDelegate, NumWithTextFieldTableViewCellDelegate
{
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var foodImgView: UIImageView!
    @IBOutlet weak var txtFieldFoodCategory: UITextField!
    @IBOutlet weak var txtFieldFoodName: UITextField!
    @IBOutlet weak var txtViewIngredients: UITextView!
    
    @IBOutlet var stepTableView: UITableView!
    @IBOutlet weak var stepTableViewHeightConstraint: NSLayoutConstraint!
    
    var stepStringMap: [String: String] = [:]
    var textFields: [String] = []
    var delegate: FoodDetailAddEditViewControllerDelegate?
    var isEditMode: Bool = false
    var passedInFoodRecipe: FoodRecipeModel? = nil
    
    let imagePicker = UIImagePickerController()
    let TEXT_VIEW_PLACEHOLDER = "Ingredients"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initTextField()
        setupTableView()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) 
    {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) 
    {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)

    }
    
    private func initUI()
    {
        imagePicker.delegate = self
        
        saveBtn.target = self
        saveBtn.action = #selector(saveBtnOnClicked)
        
        if isEditMode
        {
            txtFieldFoodName.text = passedInFoodRecipe?.recipeName
            txtFieldFoodCategory.text = passedInFoodRecipe?.recipeType
            foodImgView.image = passedInFoodRecipe?.recipeImage
            txtViewIngredients.text = SharedUtil.isEmptyString(passedInFoodRecipe?.recipeIngredients) ? TEXT_VIEW_PLACEHOLDER : passedInFoodRecipe?.recipeIngredients
            txtViewIngredients.textColor = SharedUtil.isEmptyString(passedInFoodRecipe?.recipeIngredients) ? UIColor.lightGray : UIColor.black
            
            if let unwrappedStep = passedInFoodRecipe?.recipeSteps
            {
                stepStringMap = Dictionary(uniqueKeysWithValues: unwrappedStep.enumerated().map { (index, step) in
                    (String(index), step)
                })
                
                textFields =  unwrappedStep.enumerated().map{ (index, _ ) in
                    "\(index+1)."
                }
                
                DispatchQueue.main.async
                {
                    self.stepTableViewHeightConstraint?.constant = self.stepTableView.contentSize.height + 16
                }
            }
        }
    }
    
    private func initTextField()
    {
        txtFieldFoodCategory.delegate = self
        txtFieldFoodCategory.layer.borderColor = UIColor.lightGray.cgColor
        txtFieldFoodCategory.inputView = UIView()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(foodCategoryTextFieldOnTapped))
        txtFieldFoodCategory.addGestureRecognizer(tapGestureRecognizer)
        
        txtFieldFoodName.delegate = self
        txtFieldFoodName.layer.borderColor = UIColor.lightGray.cgColor
        
        txtViewIngredients.delegate = self
        txtViewIngredients.layer.borderWidth = 1.0
        let borderColor = UIColor(red:240.0 / 255.0, green:240.0 / 255.0, blue:240.0 / 255.0, alpha:1.0)
        txtViewIngredients.layer.borderColor = borderColor.cgColor
        txtViewIngredients.layer.cornerRadius = 5.0
        txtViewIngredients.text = TEXT_VIEW_PLACEHOLDER
        txtViewIngredients.textColor = UIColor.lightGray
        
        // Set up keyboard toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonOnTapped))
        
        toolbar.items = [flexibleSpace, doneButton]
        txtViewIngredients.inputAccessoryView = toolbar
        
        let dismissKeyboardTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismissKeyboardTapGesture)
    }
    
    private func setupTableView()
    {
        stepTableView.delegate = self
        stepTableView.dataSource = self
        
        // register cells
        stepTableView.register(UINib(nibName: String(describing: NumWithTextFieldTableViewCell.self), bundle: nil), forCellReuseIdentifier: SharedUIConstants.CELL.NUM_WITH_TEXT_FIELD_TABLE_VIEW)
        
        // dynamic height table view
        stepTableView.rowHeight = UITableView.automaticDimension
        stepTableView.estimatedRowHeight = 30
        stepTableView.separatorStyle = .none
        
        textFields.append("1.")
        stepStringMap["1"] = ""
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
                dest.isAppendAllIntoList = false
            }
            
        default:
            break
        }
        
    }
    
    // ===========================================================================
    // MARK: - Button Action
    // ===========================================================================
    
    @IBAction func addImageBtnOnClicked(_ sender: UIButton)
    {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { (_) in
            self.openCamera()
        }
        
        let photoLibraryAction = UIAlertAction(title: "Choose Photo", style: .default) { (_) in
            self.openPhotoLibrary()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController
        {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) 
        {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else 
        {
            print("Camera is not available")
        }
    }
    
    func openPhotoLibrary() 
    {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addNewStepBtnOnClicked()
    {
        addStepTextField()
    }
    
    func addStepTextField()
    {
        let newIndex = textFields.count
        textFields.append("\(newIndex+1).")
        
        stepStringMap["\(newIndex)"] = ""
        
        self.stepTableView.beginUpdates()
        self.stepTableView.insertRows(at: [IndexPath.init(row: self.textFields.count-1, section: 0)], with: .automatic)
        self.stepTableView.endUpdates()
        
        DispatchQueue.main.async
        {
            self.stepTableView?.layoutIfNeeded()
            self.stepTableViewHeightConstraint?.constant = self.stepTableView.contentSize.height + 16
            self.scrollView.layoutIfNeeded()
            
            if self.scrollView.contentSize.height > self.scrollView.bounds.size.height
            {
                let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
                self.scrollView.setContentOffset(bottomOffset, animated: true)
            }
        }
    }
    
    @objc func foodCategoryTextFieldOnTapped()
    {
        performSegue(withIdentifier: SharedUIConstants.SEGUE.RECIPE_TYPE_SELECT_LIST, sender: self)
    }
    
    func recipeTypeListOnItemClicked(recipeType: String?, index: Int)
    {
        txtFieldFoodCategory.text = "\(recipeType ?? "")"
    }
    
    @objc func doneButtonOnTapped()
    {
        txtViewIngredients.resignFirstResponder()
    }
    
    @objc func saveBtnOnClicked() 
    {
        if isAllMandatoryFieldEntered()
        {
            let stepsArray = stepStringMap.keys.sorted().map { stepStringMap[$0] ?? "" }
            let foodRecipe = FoodRecipeModel(recipeName: txtFieldFoodName.text,
                                             recipeType: txtFieldFoodCategory.text,
                                             recipeImage: foodImgView.image,
                                             recipeIngredients: txtViewIngredients.text,
                                             recipeSteps: stepsArray)
            
            delegate?.saveEditButtonOnClicked(foodRecipe: foodRecipe)
        }
        else
        {
            if SharedUtil.isEmptyString(txtFieldFoodCategory.text)
            {
                let alertVC = UIAlertController(title: "Alert", message: "Food Category cannot be empty!!!", preferredStyle: .alert)
                let okActionBtn = UIAlertAction(title: "Ok", style: .default)
                
                alertVC.addAction(okActionBtn)
                present(alertVC, animated: true, completion: nil)
            }
            else if SharedUtil.isEmptyString(txtFieldFoodName.text)
            {
                let alertVC = UIAlertController(title: "Alert", message: "Food Name cannot be empty!!!", preferredStyle: .alert)
                let okActionBtn = UIAlertAction(title: "Ok", style: .default)
                
                alertVC.addAction(okActionBtn)
                present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    // ===========================================================================
    // MARK: - UITextFieldDelegate
    // ===========================================================================
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        // Disallow editing by returning false
        if textField == txtFieldFoodCategory
        {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool 
    {
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if SharedUtil.checkIsStringContainEmoji(str: string)
        {
            return false
        }
        
        switch (textField)
        {
        case txtFieldFoodName:
            let maxLength = Int(30)
            
            if ((textField.text!) + string).count > maxLength
            {
                return false
            }
            
        default:
            return true
        }
        return true
    }
    
    
    // ===========================================================================
    // MARK: - UITextViewDelegate
    // ===========================================================================
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView.text == TEXT_VIEW_PLACEHOLDER
        {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool
    {
        // Return true to allow the text view to end editing
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) 
    {
        if textView.text == ""
        {
            textView.text = TEXT_VIEW_PLACEHOLDER
            textView.textColor = UIColor.lightText
        }
        else
        {
            textView.textColor = UIColor.black
        }
    }
    
    private func isAllMandatoryFieldEntered() -> Bool
    {
        let isValid = !SharedUtil.isEmptyString(txtFieldFoodCategory.text) && !SharedUtil.isEmptyString(txtFieldFoodName.text)
        
        return isValid
    }
    
    // ===========================================================================
    // MARK: - Keyboard method
    // ===========================================================================
    @objc func keyboardWillShow(notification: NSNotification) 
    {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            scrollView.contentInset.bottom = keyboardSize.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification)
    {
        // reset scrollview default state
        scrollView.contentInset.bottom = 0.0
    }
    
    // Dismiss keyboard when tapping outside text view
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    // ===========================================================================
    // MARK: - UITableViewDelegate
    // ===========================================================================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return textFields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SharedUIConstants.CELL.NUM_WITH_TEXT_FIELD_TABLE_VIEW, for: indexPath) as? NumWithTextFieldTableViewCell else {return UITableViewCell()}
        
        cell.configure(stepNo: textFields[indexPath.row], stepDesc: stepStringMap["\(indexPath.row)"])
        cell.delegate = self
        cell.rowIndex = indexPath.row
        
        return cell
    }
    
    func didTapButtonInCell(_ cell: NumWithTextFieldTableViewCell)
    {
    }
    
    func didEndEditingInCell(_ cell: NumWithTextFieldTableViewCell, textField: UITextField)
    {
        stepStringMap["\(cell.rowIndex)"] = textField.text
    }
    
    // ===========================================================================
    // MARK: - UIImagePickerControllerDelegate
    // ===========================================================================
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let selectedImage = info[.originalImage] as? UIImage
        {
            foodImgView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) 
    {
        dismiss(animated: true, completion: nil)
    }
}
