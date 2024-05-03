//
//  SharedUIConstant.swift
//  RecipeApp
//
//  Created by Knee Shin Cong on 01/05/2024.
//

import Foundation


class SharedUIConstants
{
    struct SEGUE
    {
        static let RECIPE_TYPE_SELECT_LIST = "RECIPE_TYPE_SELECT_LIST_SEGUE"
        static let FOOD_RECIPE_LIST = "FOOD_RECIPE_LIST_SEGUE"
        static let FOOD_DETAIL_ADD_EDIT = "FOOD_DETAIL_ADD_EDIT_SEGUE"
        static let FOOD_RECIPE_DETAIL = "FOOD_RECIPE_DETAIL_SEGUE"
    }
    
    struct CELL
    {
        static let FOOD_RECIPE_LIST_COLLECTION_VIEW = "FOOD_RECIPE_LIST_COLLECTION_VIEW_CELL"
        static let NUM_WITH_TEXT_FIELD_TABLE_VIEW = "NUM_WITH_TEXT_FIELD_TABLE_VIEW_CELL"
    }
}
