//
//  OnTheRoadCell.swift
//  kargoTakip
//
//  Created by proje on 8.11.2022.
//

import UIKit

protocol OnTheRoadCellDelegate: AnyObject {
    func getOnTheRoads(completion: ([kargoDTO]) -> Void)
    func goToSegue(kargo: kargoDTO)
}

class OnTheRoadCell: UICollectionViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyKargoLabel: UILabel!
    
    static let identifier = "OnTheRoadCell"
    var delegate: OnTheRoadCellDelegate?
    var onTheRoads = [kargoDTO]()

    override func awakeFromNib() {
        
        super.awakeFromNib()
        configureUI()
    }
    
    func configureUI(){
        labelTitle.textColor = UIHelper.shared.primaryColor
        emptyKargoLabel.textColor = UIHelper.shared.secondColor
        emptyKargoLabel.text = "Bulunamadi"
        emptyKargoLabel.isHidden = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "KargoLandingCell", bundle: nil), forCellWithReuseIdentifier: "KargoLandingCell")
        collectionView.reloadData()
    }
    
    func getArray(){
        delegate?.getOnTheRoads(completion: { kargos in
            self.onTheRoads = kargos
            self.emptyKargoLabel.isHidden = self.onTheRoads.isEmpty ? false : true
            //self.emptyKargoLabel.isHidden = true
            collectionView.reloadData()
        })
    }
}

extension OnTheRoadCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onTheRoads.count
        //return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KargoLandingCell.identifier, for: indexPath) as? KargoLandingCell else { return UICollectionViewCell() }
        cell.statusType = .onTheRoad
        cell.labelTitle.text = onTheRoads[indexPath.row].company
        cell.kargoDate.text = onTheRoads[indexPath.row].date
        cell.labelStatus.text = onTheRoads[indexPath.row].store ?? "(Belirtilmemiş)"
//        cell.labelTitle.text = "Trendyol"
//        cell.kargoDate.text = "12.01.2022 15:44"
//        cell.labelStatus.text = "YTU Store"
        onTheRoads[indexPath.row].printAll()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.goToSegue(kargo: onTheRoads[indexPath.row])
        //delegate?.goToSegue(kargo: kargoDTO(status: 0, company: "Trendyol", store: "YTU Dukkan", product: "T-Shirt", date: "12.01.2022 15:44"))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 112.0)
    }
}

