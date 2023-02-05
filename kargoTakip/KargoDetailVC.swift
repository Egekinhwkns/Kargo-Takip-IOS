//
//  KargoDetailVC.swift
//  kargoTakip
//
//  Created by proje on 16.01.2023.
//

import Foundation
import UIKit

class KargoDetailVC: UIViewController {
    
    @IBOutlet private weak var companyLabel: UILabel!
    @IBOutlet private weak var storeLabel: UILabel!
    @IBOutlet private weak var productLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
//    var companyName = ""
//    var storeName = ""
//    var productName = ""
//    var status = 0
//    var date = ""
    
    var kargoObject = kargoDTO()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Kargo Detayi"
        configureUI()
    }
    
    func configureUI(){
        view.backgroundColor = UIHelper.shared.backgroundColor
        companyLabel.textColor = UIHelper.shared.sunnyYellow
        storeLabel.textColor = UIHelper.shared.denyColor
        
        companyLabel.text = "Şirket: \(kargoObject.company)"
        storeLabel.text = "Dükkan: \(kargoObject.store ?? "(Belirtilmemiş)")"
        productLabel.text = "Ürün: \(kargoObject.product)"
        dateLabel.text = "Bilgilendirilme Tarihi:\n\(kargoObject.date)"
        switch kargoObject.status {
        case 0:
            statusLabel.textColor = UIHelper.shared.thirdColor
            statusLabel.text = "Hazırlanıyor"
        case 1:
            statusLabel.textColor = UIHelper.shared.primaryColor
            statusLabel.text = "Yola Çıktı"
        default:
            statusLabel.textColor = UIHelper.shared.passiveTextColor
            statusLabel.text = "İletildi"
        }
    }
}
