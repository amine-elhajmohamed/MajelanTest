//
//  RecipeViewModel.swift
//  MajelanTest
//
//  Created by Amine Hadj Mohamed on 24/7/19.
//  Copyright © 2019 Amine Haj Mohamed. All rights reserved.
//

import Foundation

class RecipeViewModel {
    
    private(set) var isLoading: Bool = false {
        didSet{
            loadingStatuChanged()
        }
    }
    
    var loadingStatuChanged = {}
    var didUpdateIngredients = {}
    var didFailToUpdateIngredients = {}
    
    let title: String
    let imgUrl: String
    let rank: String
    let publisher: String
    let sourceUrl: String
    var ingredients: String? {
        didSet{
            didUpdateIngredients()
        }
    }
    
    private let recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
        
        title = recipe.title
        imgUrl = recipe.imgUrl
        rank = "\(String(format: "%.2f", recipe.rank))"
        publisher = "By " + recipe.publisher
        sourceUrl = recipe.sourceUrl
        
        if let ingredients = recipe.ingredients {
            self.ingredients = getListedText(from: ingredients)
        }
    }
    
    func loadIngredients(){
        isLoading = true
        
        ApiService.shared.getRecipeDetails(id: recipe.id) { [weak self] (recipeDetails: Recipe?) in
            guard let self = self else {
                return
            }
            
            self.isLoading = false
            
            if let ingredients = recipeDetails?.ingredients {
                self.recipe.ingredients = ingredients
                self.ingredients = self.getListedText(from: ingredients)
            } else {
                self.didFailToUpdateIngredients()
            }
        }
    }
    
    private func getListedText(from tab: [String]) -> String {
        let ingredientsText = tab.reduce("") { (result: String, value: String) -> String in
            return "\(result)\n* \(value)"
        }
        return ingredientsText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
