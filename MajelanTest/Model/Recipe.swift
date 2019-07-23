//
//  Recipe.swift
//  MajelanTest
//
//  Created by Amine Hadj Mohamed on 23/7/19.
//  Copyright © 2019 Amine Haj Mohamed. All rights reserved.
//

import Foundation

struct Recipe: Codable {
    let title: String
    let imgUrl: String
    let ingredients: [String]?
    let rank: Double
    let publisher: String
    let sourceUrl: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case imgUrl = "image_url"
        case ingredients
        case rank = "social_rank"
        case publisher
        case sourceUrl = "source_url"
    }
}
