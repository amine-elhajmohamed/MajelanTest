//
//  RecipeDetailsViewController.swift
//  MajelanTest
//
//  Created by Amine Hadj Mohamed on 23/7/19.
//  Copyright © 2019 Amine Haj Mohamed. All rights reserved.
//

import UIKit
import SDWebImage
import SafariServices

class RecipeDetailsViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelPublisher: UILabel!
    @IBOutlet weak var labelRank: UILabel!
    @IBOutlet weak var labelIngredients: UILabel!
    
    private var recipe: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadView(recipe: Recipe){
        loadView()
        
        self.recipe = recipe
        
        imgView.sd_setImage(with: URL(string: recipe.imgUrl), placeholderImage: UIImage(named: "FoodPlaceHolder.png"), options: [.cacheMemoryOnly, .retryFailed])
        
        labelTitle.text = recipe.title
        labelPublisher.text = "By " + recipe.publisher
        labelRank.text = "\(String(format: "%.2f", recipe.rank))"
        
        loadIngredientsList()
    }
    
    private func loadIngredientsList(){
        if let ingredients = recipe.ingredients {
            labelIngredients.text = getListedText(from: ingredients)
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        labelIngredients.text = "Loading, please wait..."
        
        ApiService.shared.getRecipeDetails(id: recipe.id) { [weak self] (recipeDetails: Recipe?) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            guard let self = self else {
                return
            }
            
            if let ingredients = recipeDetails?.ingredients {
                self.recipe.ingredients = ingredients
                self.labelIngredients.text = self.getListedText(from: ingredients)
            } else {
                self.labelIngredients.text = "Not available"
            }
        }
    }
    
    private func getListedText(from tab: [String]) -> String {
        let ingredientsText = tab.reduce("") { (result: String, value: String) -> String in
            return "\(result)\n* \(value)"
        }
        return ingredientsText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    @IBAction func buttonVisiteSourceUrlClicked(_ sender: Any) {
        guard let recipeSourceUrl = URL(string: recipe.sourceUrl) else {
            return
        }
        
        let safariVC = SFSafariViewController(url: recipeSourceUrl)
        present(safariVC, animated: true, completion: nil)
    }
    
}
