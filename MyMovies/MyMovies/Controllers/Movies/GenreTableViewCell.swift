//
//  GenreTableViewCell.swift
//  MyMovies
//
//  Created by Ngoc Hoang on 11/12/2021.
//

import UIKit

class GenreTableViewCell: UITableViewCell {
    @IBOutlet weak var genreName: UILabel!
    @IBOutlet weak var backdrop: UIImageView!
    @IBOutlet weak var backdropOverlay: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
