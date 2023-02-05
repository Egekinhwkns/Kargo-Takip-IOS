//
//  LandingVC.swift
//  kargoTakip
//
//  Created by proje on 3.11.2022.
//

import Foundation
import UIKit

class EskiKargolarVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var userId = 2
    var kargolar = kargoArrayDTO()
    var kargoForDetail = kargoDTO()
    let activityView = UIActivityIndicatorView(style: .large)
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        configureUI()
        updateUI()
        title = "Geçmiş"
    }
    
    func configureUI(){
        view.backgroundColor = UIHelper.shared.backgroundColor
        
        activityView.center = self.view.center
        //activityView.color = UIHelper.shared.thirdColor
        activityView.color = .white
        self.view.addSubview(activityView)
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let attributedTitle = NSAttributedString(string: "Sayfa Yenileniyor...", attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) 
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.updateUI(isRefreshing: true)
        print("REFRESHED!")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! KargoDetailVC
        destinationVC.kargoObject = self.kargoForDetail
    }
    
    func updateUI(isRefreshing: Bool? = false){
        
        if !(isRefreshing!) {
            activityView.startAnimating()
        }
        view.alpha = 0.5
//        let url = "http://34.125.44.191:5000/kargotakip/user/getKargos"
        
        let url = "http://137.184.93.237:5000/kargotakip/user/getKargos"
        self.userId = UserDefaults.standard.integer(forKey: "userId")
        let kargoParameters = ["id" : String(self.userId)]
        
        NetworkManager.shared.jsonPostRequest(url: url, params: kargoParameters, type: kargoArrayDTO.self) { data in

            var newKargos = data
            newKargos.formatDateAll()
            self.kargolar = newKargos
            DispatchQueue.main.async {
                self.kargolar.sortDateAll()
                self.endRefresh()
                self.tableView.reloadData()
            }
        }
    }
    
    func setTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.backgroundColor = UIHelper.shared.backgroundColor
        tableView.tableHeaderView = UIView()
        tableView.backgroundColor = UIHelper.shared.collectionBgColor
        tableView.layer.cornerRadius = 10
        tableView.register(UINib(nibName: "kargoMainCell", bundle: nil), forCellReuseIdentifier: "kargoMainCell")
    }
    
    func endRefresh(){
            self.view.alpha = 1
            activityView.stopAnimating()
            refreshControl.endRefreshing()
    }
}

extension EskiKargolarVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kargolar.kargos.count
        //return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kargoMainCell") as! kargoMainCell
//        if indexPath.row == kargolar.kargos.count - 1 {
//                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
//            }
        cell.kargo = kargolar.kargos[indexPath.row]
//        cell.kargo = kargoDTO(status: 0, company: "Trendyol", store: "YTU Dukkan", product: "T-Shirt", date: "12.01.2022 15:44")
        cell.configureUI()
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.kargoForDetail = kargolar.kargos[indexPath.row]
//        self.kargoForDetail = kargoDTO(status: 0, company: "Trendyol", store: "YTU Dukkan", product: "T-Shirt", date: "12.01.2022 15:44")
        performSegue(withIdentifier: "toKargoDetail2", sender: self)
    }
}
