//
//  Recipe.swift
//  MajelanTest
//
//  Created by Amine Hadj Mohamed on 23/7/19.
//  Copyright © 2019 Amine Haj Mohamed. All rights reserved.
//

import Foundation

class Recipe: Codable {
    let id: String
    let title: String
    let imgUrl: String
    var ingredients: [String]?
    let rank: Double
    let publisher: String
    let sourceUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id = "recipe_id"
        case title
        case imgUrl = "image_url"
        case ingredients
        case rank = "social_rank"
        case publisher
        case sourceUrl = "source_url"
    }
}
