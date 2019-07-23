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
    
    private var recipeListViewModel: RecipeListViewModel!
    private var timerForUpdatingRecipesData: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI(){
        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        recipeListViewModel = RecipeListViewModel()
        
        recipeListViewModel.didUpdateRecipeList = { [weak self] in
            self?.tableView.reloadData()
            self?.tableView.setContentOffset(CGPoint.zero, animated: false)
        }
        
        recipeListViewModel.didFailToUpdateRecipeList = { [weak self] in
            let alertVC = UIAlertController(title: "Failed to load the data", message: "Please try again later", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self?.present(alertVC, animated: true, completion: nil)
        }
        
        recipeListViewModel.loadingStatuChanged = { [weak self] in
            if let isLoading = self?.recipeListViewModel.isLoading, isLoading {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            } else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        
        recipeListViewModel.search("")
    }
    
}

//MARK: - extension ViewController: UITableViewDataSource
extension RecipesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeListViewModel.getListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipeViewModel = recipeListViewModel.getRecipeViewModel(forRow: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as! RecipeTableViewCell
        cell.loadView(recipeViewModel: recipeViewModel)
        cell.selectionStyle = .none
        return cell
    }
    
}

//MARK: - extension ViewController: UITableViewDelegate
extension RecipesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipeViewModel = recipeListViewModel.getRecipeViewModel(forRow: indexPath.row)
        
        let recipeDetailsVC = storyboard?.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsViewController
        recipeDetailsVC.loadView(recipeViewModel: recipeViewModel)
        navigationController?.pushViewController(recipeDetailsVC, animated: true)
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
            self.recipeListViewModel.search(searchText)
        })
    }
    
}
