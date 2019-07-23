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
    
    private var recipeViewModel: RecipeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadView(recipeViewModel: RecipeViewModel){
        loadView()
        
        self.recipeViewModel = recipeViewModel
        
        recipeViewModel.loadingStatuChanged = { [weak self] in
            if recipeViewModel.isLoading {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                self?.labelIngredients.text = "Loading, please wait..."
            } else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        
        recipeViewModel.didUpdateIngredients = { [weak self] in
            self?.labelIngredients.text = recipeViewModel.ingredients
        }
        
        recipeViewModel.didFailToUpdateIngredients = { [weak self] in
            self?.labelIngredients.text = "Not available"
        }
        
        imgView.sd_setImage(with: URL(string: recipeViewModel.imgUrl), placeholderImage: UIImage(named: "FoodPlaceHolder.png"), options: [.cacheMemoryOnly, .retryFailed])
        
        labelTitle.text = recipeViewModel.title
        labelPublisher.text = recipeViewModel.publisher
        labelRank.text = recipeViewModel.rank
        
        if let ingredients = recipeViewModel.ingredients {
            labelIngredients.text = ingredients
        } else {
            recipeViewModel.loadIngredients()
        }
    }
    
    @IBAction func buttonVisiteSourceUrlClicked(_ sender: Any) {
        guard let recipeSourceUrl = URL(string: recipeViewModel.sourceUrl) else {
            return
        }
        
        let safariVC = SFSafariViewController(url: recipeSourceUrl)
        present(safariVC, animated: true, completion: nil)
    }
    
}
