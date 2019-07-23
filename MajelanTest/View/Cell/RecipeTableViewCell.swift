//
//  RecipeTableViewCell.swift
//  MajelanTest
//
//  Created by Amine Hadj Mohamed on 23/7/19.
//  Copyright © 2019 Amine Haj Mohamed. All rights reserved.
//

import UIKit
import SDWebImage

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelPublisher: UILabel!
    @IBOutlet weak var labelRank: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imgView.sd_cancelCurrentImageLoad()
        
        imgView.image = nil
        labelTitle.text = nil
        labelPublisher.text = nil
        labelRank.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgView.layer.cornerRadius = 5
        
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOffset = CGSize(width: 2, height: 2)
        bgView.layer.shadowOpacity = 0.3
        bgView.layer.cornerRadius = 5
    }
    
    func loadView(recipe: Recipe){
        imgView.sd_setImage(with: URL(string: recipe.imgUrl), placeholderImage: UIImage(named: "FoodPlaceHolder.png"), options: [.cacheMemoryOnly, .retryFailed])
        labelTitle.text = recipe.title
        labelPublisher.text = recipe.publisher
        labelRank.text = "\(String(format: "%.2f", recipe.rank))"
    }
    
}
