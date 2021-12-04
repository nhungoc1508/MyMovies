//
//  MovieCell.swift
//  Flixster
//
//  Created by Matthew Swartz on 9/23/21.
//

import UIKit

class MovieCell: UITableViewCell {
    // adding our storyboard outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
