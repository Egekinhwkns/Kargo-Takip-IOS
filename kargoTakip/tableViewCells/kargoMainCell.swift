//
//  kargoMainCell.swift
//  kargoTakip
//
//  Created by proje on 5.11.2022.
//

import UIKit

class kargoMainCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var kargo = kargoDTO()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        
    }
    
    func configureUI(){
        backgroundColor = UIHelper.shared.collectionBgColor
        titleLabel.textColor = UIHelper.shared.primaryColor
        detailLabel.textColor = UIHelper.shared.secondColor
        dateLabel.textColor = UIHelper.shared.activeTagBgGradientColor
        titleLabel.text = kargo.company
        detailLabel.text = kargo.store ?? "(Belirtilmemiş)"
        dateLabel.text = kargo.date
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
