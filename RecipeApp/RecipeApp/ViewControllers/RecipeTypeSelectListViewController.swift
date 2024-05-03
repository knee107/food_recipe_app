//
//  RecipeTypeSelectListViewController.swift
//  RecipeApp
//
//  Created by Knee Shin Cong on 01/05/2024.
//

import Foundation
import UIKit

protocol RecipeTypeSelectListViewControllerDelegate
{
    func recipeTypeListOnItemClicked(recipeType: String?, index: Int)
}

class RecipeTypeSelectListViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, XMLParserDelegate
{
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var contentView: UIStackView!
    @IBOutlet weak var recipeTypePickerView: UIPickerView!
    
    var delegate: RecipeTypeSelectListViewControllerDelegate?
    var recipeTypeList: [String] = []
    var isAppendAllIntoList: Bool = true
    
    // ===========================================================================
    // MARK: - Init
    // ===========================================================================
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initUI()
        loadXMLFile()
    }
    
    override func viewWillAppear(_ animated: Bool) 
    {
        super.viewWillAppear(animated)
    }
    
    private func initUI()
    {
        recipeTypePickerView.dataSource = self
        recipeTypePickerView.delegate = self
        
        UIView.animate(withDuration: 0.5, animations: {self.openView()})
        
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        self.contentView.layer.cornerRadius = 27.0
        self.contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.contentView.clipsToBounds = true
        
        if isAppendAllIntoList
        {
            recipeTypeList.append("All")
        }
    }
    
    private func loadXMLFile()
    {
        // Load XML file
        if let path = Bundle.main.path(forResource: "recipetypes", ofType: "xml")
        {
            if let xml = try? String(contentsOfFile: path)
            {
                if let dataXML = xml.data(using: .utf8)
                {
                    let parser = XMLParser(data: dataXML)
                    parser.delegate = self
                    parser.parse()
                }
            }
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer)
    {
        let location = sender.location(in: self.view)
        if !contentView.frame.contains(location) {
            dismissView()
        }
    }
    
    private func openView()
    {
        self.outerView.backgroundColor = .black
        self.outerView.alpha = 0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.cancelsTouchesInView = false
        self.outerView.addGestureRecognizer(tapGesture)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut,
                       animations: {self.outerView.alpha = 0.5},
                       completion: nil)
    }
    
    private func dismissView()
    {
        UIView.animate(withDuration: 0.3, animations: {self.closeView()})
    }
    
    private func closeView()
    {
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        self.contentView.frame = CGRect(x: 0, y: screenHeight, width: self.contentView.frame.width, height: self.contentView.frame.height)
        self.outerView.alpha = 0.5
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseOut,
                       animations: {self.outerView.alpha = 0},
                       completion: {(finished:Bool) in
                                    self.dismiss(animated: false)})
    }
    
    // ===========================================================================
    // MARK: - IBAction
    // ===========================================================================
    @IBAction func doneButtonOnClicked()
    {
        let selectedRow = recipeTypePickerView.selectedRow(inComponent: 0)
        let recipeType = recipeTypeList[selectedRow]
        delegate?.recipeTypeListOnItemClicked(recipeType: recipeType, index: selectedRow)
        dismissView()
    }
    
    // ===========================================================================
    // MARK: - UIPickerViewDelegate
    // ===========================================================================
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int 
    {
        return recipeTypeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? 
    {
        return recipeTypeList[row]
    }
    
    // ===========================================================================
    // MARK: - XMLParserDelegate
    // ===========================================================================
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        if elementName == "recipe", let recipeType = attributeDict["name"]
        {
            recipeTypeList.append(recipeType)
        }
    }
}
