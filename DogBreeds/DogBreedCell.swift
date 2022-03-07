//
//  DogBreedCell.swift
//  DogBreeds
//
//  Created by Rammel on 2022-01-25.
//

import UIKit

class DogBreedCell: UITableViewCell {

    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var subBreedLabel: UILabel!
    @IBOutlet weak var dogBreedImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    

}
