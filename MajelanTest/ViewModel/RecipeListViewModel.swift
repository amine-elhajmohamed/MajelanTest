//
//  RecipeListViewModel.swift
//  MajelanTest
//
//  Created by Amine Hadj Mohamed on 24/7/19.
//  Copyright © 2019 Amine Haj Mohamed. All rights reserved.
//

import Foundation

class RecipeListViewModel {
    
    private var recipeList: [RecipeViewModel]? = nil {
        didSet {
            didUpdateRecipeList()
        }
    }
    
    private(set) var isLoading: Bool = false {
        didSet{
            loadingStatuChanged()
        }
    }
    
    var loadingStatuChanged = {}
    var didUpdateRecipeList = {}
    var didFailToUpdateRecipeList = {}
    
    func getListCount() -> Int {
        return recipeList?.count ?? 0
    }
    
    func getRecipeViewModel(forRow: Int) -> RecipeViewModel {
        return recipeList![forRow]
    }
    
    func search(_ text: String){
        isLoading = true
        ApiService.shared.searchRecipes(text) { [weak self] (recipes: [Recipe]?) in
            guard let self = self else {
                return
            }
            
            self.isLoading = false
            
            self.recipeList = recipes?.map({ (recipe: Recipe) -> RecipeViewModel in
                return RecipeViewModel(recipe: recipe)
            })
            
            if self.recipeList == nil {
                self.didFailToUpdateRecipeList()
            }
        }
    }
    
}
