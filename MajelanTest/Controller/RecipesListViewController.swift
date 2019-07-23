//
//  RecipesListViewController.swift
//  MajelanTest
//
//  Created by Amine Hadj Mohamed on 23/7/19.
//  Copyright © 2019 Amine Haj Mohamed. All rights reserved.
//

import UIKit

class RecipesListViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var recipes: [Recipe] = []
    
    private var timerForUpdatingRecipesData: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.dataSource = self
        
        updateRecipesData()
    }
    
    private func updateRecipesData(){
        let searchText = searchBar.text ?? ""
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        ApiService.shared.searchRecipes(searchText) { [weak self] (recipes: [Recipe]?) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            guard let self = self else {
                return
            }
            
            if (recipes == nil) {
                let alertVC = UIAlertController(title: "Failed to load the data", message: "Please try again later", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
                return
            }
            
            self.recipes = recipes!
            self.tableView.reloadData()
            self.tableView.setContentOffset(CGPoint.zero, animated: false)
        }
    }
    
}

//MARK: - extension ViewController: UITableViewDataSource
extension RecipesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = recipes[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as! RecipeTableViewCell
        cell.loadView(recipe: recipe)
        cell.selectionStyle = .none
        return cell
    }
    
}

//MARK: - extension ViewController: UISearchBarDelegate
extension RecipesListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timerForUpdatingRecipesData?.invalidate()
        
        timerForUpdatingRecipesData = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] (_) in
            guard let self = self else {
                return
            }
            self.updateRecipesData()
        })
    }
    
}
