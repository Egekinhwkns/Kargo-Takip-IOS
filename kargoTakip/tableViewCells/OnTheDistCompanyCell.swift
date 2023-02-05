//
//  OnTheDistCompanyCell.swift
//  kargoTakip
//
//  Created by proje on 8.11.2022.
//

import UIKit

class OnTheDistCompanyCell: UICollectionViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
//    var task: TaskDTO!
    static let identifier = "OnTheDistCompanyCell"
    
//    var viewModel : TaskVm! {
//        didSet {
//            updateUI()
//        }
//    }

    override func awakeFromNib() {
        super.awakeFromNib()

        labelTitle.textColor = UIHelper.shared.passiveTextColor
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "KargoLandingCell", bundle: nil), forCellWithReuseIdentifier: "KargoLandingCell")
        collectionView.reloadData()
    }
    
    private func updateUI() {
        //labelTitle.text =  "new.notification.upper".value + " (\(viewModel.count))"
        collectionView.reloadData()
    }
    
    private func getColor() -> UIColor {
//        switch task.status{
//        case 1:
//            return UIHelper.shared.thirdColor
//        case  2:
//            return UIHelper.shared.primaryColor
//        case 4:
//            return UIHelper.shared.passiveTextColor
//        default:
//            return UIHelper.shared.popupCloseIconColor
//        }
        return UIHelper.shared.passiveTextColor
    }
    
}

extension OnTheDistCompanyCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return viewModel.numberOfTasks
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KargoLandingCell.identifier, for: indexPath) as? KargoLandingCell else { return UICollectionViewCell() }
        cell.statusType = .onTheDistCompany
        //cell.viewModel = viewModel.getTaskItemVM(indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        NetworkManager.shared.response(.taskDetail(taskId: viewModel.getTaskItemVM(indexPath.row).id), TaskDetailDTO.self, { (response) in
//            TaskDetailVM(response).checkTaskIsTaken()
//            NavigationManager.shared.navigateTo(.taskDetail, TaskDetailVM(response))
//        },nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 112.0)
    }
}


