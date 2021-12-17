//
//  SocialTableViewCell.swift
//  MyMovies
//
//  Created by Ngoc Hoang on 17/12/2021.
//

import UIKit

class SocialTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var posterView0: UIImageView!
    @IBOutlet weak var posterView1: UIImageView!
    @IBOutlet weak var posterView2: UIImageView!
    @IBOutlet weak var posterView3: UIImageView!
    @IBOutlet weak var posterView4: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
