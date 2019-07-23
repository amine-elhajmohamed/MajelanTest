//
//  ApiService.swift
//  MajelanTest
//
//  Created by Amine Hadj Mohamed on 23/7/19.
//  Copyright © 2019 Amine Haj Mohamed. All rights reserved.
//

import Foundation
import Alamofire

class ApiService {
    
    static let shared = ApiService()
    
    private static let baseUrl = "https://www.food2fork.com/api/"
    private static let searchUrl = baseUrl + "search"
    private static let detailsUrl = baseUrl + "get"
    private static let apiKey = "1ec030682addff45b9199a4269dfed77"
    
    private lazy var sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        return SessionManager(configuration: configuration)
    }()
    
    private init(){
    }
    
    func searchRecipes(_ text: String, onComplition: @escaping (([Recipe]?)->())){
        var parameters = ["key":ApiService.apiKey]
        
        if !text.isEmpty {
            parameters["q"] = text
        }
        
        sessionManager.request(ApiService.searchUrl, method: .get, parameters: parameters, headers: nil).responseJSON { (dataResponse: DataResponse<Any>) in
            guard let statusCode = dataResponse.response?.statusCode else {
                onComplition(nil)
                return
            }
            
            switch statusCode {
            case 200:
                guard let resultValue = dataResponse.result.value as? [String: Any],
                    let recipesJsonList = resultValue["recipes"] as? [[String: Any]],
                    let recipesJsonListData = try? JSONSerialization.data(withJSONObject: recipesJsonList, options: .prettyPrinted) else {
                        onComplition(nil)
                        return
                }
                
                let jsonDecoder = JSONDecoder()
                let recipes = try? jsonDecoder.decode([Recipe].self, from: recipesJsonListData)
                onComplition(recipes)
            default:
                onComplition(nil)
            }
        }
    }
    
    func getRecipeDetails(id: String, onComplition: @escaping ((Recipe?)->())){
        let parameters = ["key":ApiService.apiKey, "rId": id]
        
        sessionManager.request(ApiService.detailsUrl, method: .get, parameters: parameters, headers: nil).responseJSON { (dataResponse: DataResponse<Any>) in
            guard let statusCode = dataResponse.response?.statusCode else {
                onComplition(nil)
                return
            }
            
            switch statusCode {
            case 200:
                guard let resultValue = dataResponse.result.value as? [String: Any],
                    let recipeDetailJson = resultValue["recipe"] as? [String: Any],
                    let recipesDetailJsonData = try? JSONSerialization.data(withJSONObject: recipeDetailJson, options: .prettyPrinted) else {
                        onComplition(nil)
                        return
                }
                
                let jsonDecoder = JSONDecoder()
                let recipe = try? jsonDecoder.decode(Recipe.self, from: recipesDetailJsonData)
                onComplition(recipe)
            default:
                onComplition(nil)
            }
        }
    }

    
}


