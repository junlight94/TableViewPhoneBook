//
//  TableViewCell.swift
//  TableViewPhoneBook
//
//  Created by 이준영 on 2022/03/28.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var bookMarkImageView: UIImageView!
    @IBOutlet var phoneNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
