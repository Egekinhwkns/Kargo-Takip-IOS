//
//  PreparingCell.swift
//  kargoTakip
//
//  Created by proje on 8.11.2022.
//

import UIKit

protocol PreparingCellDelegate: AnyObject {
    func getPreparings(completion: ([kargoDTO]) -> Void)
    func goToSegue(kargo: kargoDTO)
}

class PreparingCell: UICollectionViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyKargoLabel: UILabel!
    
//    var task: TaskDTO!
    static let identifier = "PreparingCell"
    var delegate: PreparingCellDelegate?
    var preparings = [kargoDTO]()

    override func awakeFromNib() {
        
        super.awakeFromNib()
        configureUI()
    }
    
    func configureUI(){
        labelTitle.textColor = UIHelper.shared.thirdColor
        emptyKargoLabel.textColor = UIHelper.shared.secondColor
        emptyKargoLabel.text = "Bulunamadi"
        emptyKargoLabel.isHidden = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "KargoLandingCell", bundle: nil), forCellWithReuseIdentifier: "KargoLandingCell")
        collectionView.reloadData()
    }
    func getArray(){
        delegate?.getPreparings(completion: { kargos in
            self.preparings = kargos
            self.emptyKargoLabel.isHidden = self.preparings.isEmpty ? false : true
            //self.emptyKargoLabel.isHidden =  true
            collectionView.reloadData()
        })
    }
}

extension PreparingCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return preparings.count
        //return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KargoLandingCell.identifier, for: indexPath) as? KargoLandingCell else { return UICollectionViewCell() }
        cell.statusType = .preparing
        cell.labelTitle.text = preparings[indexPath.row].company
        cell.kargoDate.text = preparings[indexPath.row].date
        cell.labelStatus.text = preparings[indexPath.row].store ?? "(Belirtilmemiş)"
//        cell.labelTitle.text = "Trendyol"
//        cell.kargoDate.text = "12.01.2022 15:44"
//        cell.labelStatus.text = "YTU Store"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.goToSegue(kargo: preparings[indexPath.row])
       //delegate?.goToSegue(kargo: kargoDTO(status: 0, company: "Trendyol", store: "YTU Dukkan", product: "T-Shirt", date: "12.01.2022 15:44"))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 112.0)
    }
}


