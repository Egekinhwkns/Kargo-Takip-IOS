//
//  ProfilVC.swift
//  kargoTakip
//
//  Created by proje on 18.01.2023.
//

import Foundation
import UIKit
import GoogleSignIn

class ProfilVC: UIViewController {
    
    @IBOutlet weak var emailLabel : UILabel!
    @IBOutlet weak var fullnameLabel : UILabel!
    //@IBOutlet weak var givennameLabel : UILabel!
    //@IBOutlet weak var familynameLabel : UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var profilepic : UIImageView!
    
    let refreshControl = UIRefreshControl()
    var profilePicUrl : String? = ""
    var emailAddress = ""
    var fullName = ""
    var givenName = ""
    var familyName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profil"
        configureUI()
        updateUI()
    }
    
    func configureUI(){
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let attributedTitle = NSAttributedString(string: "Sayfa Yenileniyor...", attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        //view.addSubview(refreshControl)
        
        view.backgroundColor = UIHelper.shared.backgroundColor
        emailLabel.textColor = UIHelper.shared.primaryColor
        fullnameLabel.textColor = UIHelper.shared.primaryColor
        logOutButton.tintColor = UIHelper.shared.primaryColor
        //givennameLabel.textColor = UIHelper.shared.secondColor
        //familynameLabel.textColor = UIHelper.shared.secondColor
    
        emailAddress = UserDefaults.standard.string(forKey: "userEmail") ?? ""
        fullName = UserDefaults.standard.string(forKey: "userFullname") ?? ""
        givenName = UserDefaults.standard.string(forKey: "userGivenname") ?? ""
        familyName = UserDefaults.standard.string(forKey: "userFamilyname") ?? ""
        profilePicUrl = UserDefaults.standard.string(forKey: "userProfilepic")
        
        profilepic.layer.cornerRadius = profilepic.frame.height/2
        
        emailLabel.text = "E-MAIL: \(emailAddress)"
        fullnameLabel.text = "İSİM: \(fullName)"
        //givennameLabel.text = "TAKMA AD: \(givenName)"
        //familynameLabel.text = "SOYISIM: \(fullName)"
    }
    
    func updateUI(){
        if let profpic = profilePicUrl {
            let url = URL(string: profpic)
            downloadImage(from: url!)
        }
    }
    
    func refreshEndControl(count: Int){
        refreshControl.endRefreshing()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.updateUI()
        print("REFRESHED!")
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
            let task = URLSession.shared.dataTask(with: url ) { data, response, error in
                
                if let error = error {
                    print("error: \(error)")
                    if let httpresponse = response as? HTTPURLResponse {
                        print("status: \(httpresponse.statusCode)")
                    }
                }
                if let data = data {
                    print(response?.suggestedFilename ?? url.lastPathComponent)
                    print("Download Finished")
                    // always update the UI from the main thread
                    DispatchQueue.main.async() { [weak self] in
                        self?.profilepic.image = UIImage(data: data)
                    }
                }
            }
        task.resume()
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        //self.signOutFromGoogle {
            let vc = NavigationManager.shared.navigateTo(.loginVC)
            self.present(vc, animated: true, completion: nil)
        //}
    }
    func signOutFromGoogle(completion: @escaping () -> Void){
        GIDSignIn.sharedInstance.disconnect { error in
            
            print("Logging out...")
            guard error == nil else {
                print("Error when logged out.")
                return
            }
            print("Logged Out.")
            completion()
        }
    }

}
