//
//  LandingVC.swift
//  kargoTakip
//
//  Created by proje on 8.11.2022.
//

import Foundation
import UIKit

class LandingVC: UIViewController {
    
    var kargoArray = kargoArrayDTO()
    var kargoForDetail = kargoDTO()
    var userId = 2
    let refreshControl = UIRefreshControl()
    let activityView = UIActivityIndicatorView(style: .large)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ana Sayfa"
        configureUI()
        updateUI()
    }
    
    func updateUI(isRefreshing: Bool? = false){
        
        var responseCount = 0
        if !(isRefreshing!) {
            activityView.startAnimating()
        }
        view.alpha = 0.5
        self.kargoArray.kargos.removeAll()
        self.userId = UserDefaults.standard.integer(forKey: "userId")
        // kargo api istegi137.184.93.237
//        let url1 = "http://34.125.44.191:5000/kargotakip/user/login"
//        let url2 = "http://34.125.44.191:5000/kargotakip/user/getTrendyolMessages"
//        let url3 = "http://34.125.44.191:5000/kargotakip/user/getTrendyolYemekMessages"
//        let url4 = "http://34.125.44.191:5000/kargotakip/user/getHepsiburadaMessages"
        
        let url1 = "http://137.184.93.237:5000/kargotakip/user/login"
        let url2 = "http://137.184.93.237:5000/kargotakip/user/getTrendyolMessages"
        let url3 = "http://137.184.93.237:5000/kargotakip/user/getTrendyolYemekMessages"
        let url4 = "http://137.184.93.237:5000/kargotakip/user/getHepsiburadaMessages"
        
        let kargoParameters = ["id" : String(self.userId)]

        NetworkManager.shared.jsonPostRequest(url: url2, params: kargoParameters, type: kargoArrayDTO.self) { data2 in

            var newKargos = data2
            responseCount += 1
            
                newKargos.formatDateAll()
                newKargos.printAll()
                self.kargoArray.kargos.append(contentsOf: newKargos.kargos)

                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.refreshEndControl(count: responseCount)
                }
            
        }
        NetworkManager.shared.jsonPostRequest(url: url3, params: kargoParameters, type: kargoArrayDTO.self) { data2 in

            var newKargos = data2
            responseCount += 1
            
                newKargos.formatDateAll()
                newKargos.printAll()
                self.kargoArray.kargos.append(contentsOf: newKargos.kargos)

                print(self.kargoArray.kargos)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.refreshEndControl(count: responseCount)
                }
            
        }
        NetworkManager.shared.jsonPostRequest(url: url4, params: kargoParameters, type: kargoArrayDTO.self) { data2 in

            var newKargos = data2
            responseCount += 1
            //if !newKargos.kargos.isEmpty {
                newKargos.formatDateAll()
                newKargos.printAll()
                self.kargoArray.kargos.append(contentsOf: newKargos.kargos)

                print(self.kargoArray.kargos)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.refreshEndControl(count: responseCount)
                }
            //}
        }
    }
    
    func configureUI(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIHelper.shared.backgroundColor
        
        activityView.center = self.view.center
        //activityView.color = UIHelper.shared.thirdColor
        activityView.color = .white
        self.view.addSubview(activityView)
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let attributedTitle = NSAttributedString(string: "Sayfa Yenileniyor...", attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    func refreshEndControl(count: Int){
        if count >= 3 {
            kargoArray.sortDateAll()
            self.view.alpha = 1
            activityView.stopAnimating()
            refreshControl.endRefreshing()
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.updateUI(isRefreshing: true)
        print("REFRESHED!")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! KargoDetailVC
        destinationVC.kargoObject = self.kargoForDetail 
    }
}

extension LandingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch indexPath.row {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreparingCell.identifier, for: indexPath) as? PreparingCell else { return UICollectionViewCell() }
            cell.delegate = self
            cell.getArray()
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnTheRoadCell.identifier, for: indexPath) as? OnTheRoadCell else { return UICollectionViewCell() }
            cell.delegate = self
            cell.getArray()
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AcceptedCell.identifier, for: indexPath) as? AcceptedCell else { return UICollectionViewCell() }
            cell.delegate = self
            cell.getArray()
            return cell
        default:
            return UICollectionViewCell()
        }
    }
         
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 160.0)
    }
}
extension LandingVC: OnTheRoadCellDelegate, AcceptedCellDelegate, PreparingCellDelegate {
    
    func goToSegue(kargo: kargoDTO) {
        self.kargoForDetail = kargo
        performSegue(withIdentifier: "toKargoDetail", sender: self)
    }
    
    func getPreparings(completion: ([kargoDTO]) -> Void) {
        var preparings = [kargoDTO]()
        kargoArray.kargos.forEach { kargoObject in
            if kargoObject.status == 0 {
                preparings.append(kargoObject)
            }
        }
        completion(preparings)
    }
    
    func getOnTheRoads(completion: ([kargoDTO]) -> Void) {
        
        var onTheRoads = [kargoDTO]()
        kargoArray.kargos.forEach { kargoObject in
            if kargoObject.status == 1 {
                onTheRoads.append(kargoObject)
            }
        }
        completion(onTheRoads)
    }
    
    func getAccepteds(completion: ([kargoDTO]) -> Void) {
        var accepteds = [kargoDTO]()
        kargoArray.kargos.forEach { kargoObject in
            if kargoObject.status == 2 {
                accepteds.append(kargoObject)
            }
        }
        completion(accepteds)
    }
}
