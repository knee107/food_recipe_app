//
//  NumWithTextFieldTableViewCell.swift
//  RecipeApp
//
//  Created by Knee Shin Cong on 02/05/2024.
//

import UIKit

protocol NumWithTextFieldTableViewCellDelegate
{
    func didTapButtonInCell(_ cell: NumWithTextFieldTableViewCell)
    func didEndEditingInCell(_ cell: NumWithTextFieldTableViewCell, textField: UITextField)
}

class NumWithTextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var lblStepNo: UILabel!
    @IBOutlet weak var txtFieldStepDesc: UITextField!
    
    var delegate: NumWithTextFieldTableViewCellDelegate?
    var rowIndex: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        txtFieldStepDesc.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) 
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(stepNo: String?, stepDesc: String?)
    {
        lblStepNo.text = stepNo
        txtFieldStepDesc.text = stepDesc
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool 
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        delegate?.didEndEditingInCell(self, textField: textField)
    }
    
}
