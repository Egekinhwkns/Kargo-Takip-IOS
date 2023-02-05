//
//  KargoLandingCell.swift
//  kargoTakip
//
//  Created by proje on 9.11.2022.
//

import UIKit

enum KargoStatusType {
    case onTheRoad
    case onTheDistCompany
    case preparing
    case accepted
}

class KargoLandingCell: UICollectionViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var kargoDate: UILabel!
    
    var statusType : KargoStatusType? {
        didSet {
            configureUI()
        }
    }
    
    
    
    static var identifier = "KargoLandingCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        
    }
    
    
    func configureUI(){
        
        backgroundColor = UIHelper.shared.backgroundColor
        backView.layer.cornerRadius = 7
        
        kargoDate.textColor = .white
        switch statusType {
        case .preparing:
            backView.backgroundColor = UIHelper.shared.onTheRoadBgColor
            labelTitle.textColor = UIHelper.shared.thirdColor
            labelStatus.textColor = UIHelper.shared.thirdColor
        case .onTheRoad:
            backView.backgroundColor = UIHelper.shared.onTheDistBgColor
            labelTitle.textColor = UIHelper.shared.primaryColor
            labelStatus.textColor = UIHelper.shared.primaryColor
        case .accepted:
            backView.backgroundColor = UIHelper.shared.preparingBgColor
            labelTitle.textColor = UIHelper.shared.secondColor
            labelStatus.textColor = UIHelper.shared.secondColor
        default:
            backView.backgroundColor = UIHelper.shared.acceptedBgColor
            labelTitle.textColor = UIHelper.shared.passiveTextColor
            labelStatus.textColor = UIHelper.shared.passiveTextColor
        }
    
    }
    
}
