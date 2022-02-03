//
//  CellView.swift
//  WorkOrderApp
//
//  Created by mac on 05/12/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class CellView: UITableViewCell {

    @IBOutlet weak var labQty: UITextField!
    @IBOutlet weak var txtPartNAme: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
