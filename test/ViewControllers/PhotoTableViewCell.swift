//
//  PhotoTableViewCell.swift
//  test
//
//  Created by Ruslan Zinko on 2/1/17.
//  Copyright © 2017 Ruslan Zinko. All rights reserved.
//

import UIKit

protocol PhotoTableViewCellDelegate: class{
    func likeButtonPressed(dataId: String, tag: Int)
}

class PhotoTableViewCell: UITableViewCell {
    
    var photoObject = PhotoModel()
    
    weak var deledate : PhotoTableViewCellDelegate?
    
    @IBOutlet weak var photoImage       : UIImageView!
    @IBOutlet weak var createdAtLabel   : UILabel!
    @IBOutlet weak var ownerLabel       : UILabel!
    @IBOutlet weak var likesLabel       : UILabel!
    @IBOutlet weak var likeItButton     : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func passPhotoObject(photoObject: PhotoModel) {
        self.photoObject = photoObject
        self.createdAtLabel.text = toString(date: self.photoObject.createdAt)
        self.ownerLabel.text = self.photoObject.user
        self.likesLabel.text = String(self.photoObject.likes)
        self.photoImage.sd_setImage(with: URL(string: self.photoObject.url))
    }
    
    func toString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy"
        let convertedDateString = dateFormatter.string(from: date)
        
        return convertedDateString
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeItButtonPressed(_ sender: Any) {
        deledate?.likeButtonPressed(dataId: self.photoObject.id, tag: self.tag)
    }
}
