//
//  ViewController.swift
//  kargoTakip
//
//  Created by proje on 23.10.2022.
//

import UIKit
import GoogleSignIn


class LoginVC: UIViewController {
    
    
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var googlePngImageView: UIImageView!
    @IBOutlet weak var signInWithGoogleView: UIView!
    
    // MARK: Client ID for App

    let signInConfig = "ourClientIDs"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //isAlreadyLoggedIn()
        configureUI()
    }
    
    func configureUI(){
        signInWithGoogleView.layer.cornerRadius = 10
        googlePngImageView.image = UIImage(named: "googlepng")
        middleLabel.text = " "
    }

    func isAlreadyLoggedIn() {
        if let currentUser = GIDSignIn.sharedInstance.currentUser {
            print("Already Logged in.")
            let vc = NavigationManager.shared.navigateTo(.tabBarVC)
            present(vc, animated: true, completion: nil)
        }
        else { return }
    }
    
    // MARK: Sign-in With Google Button Tapped
    @IBAction func signGoogleButtonTapped(_ sender: UIButton) {
        
        signOutFromGoogle {
            self.signInWithGoogle { user in
                
                let profilePicUrl = user.profile?.imageURL(withDimension: 320)?.absoluteString
                let emailAddress = user.profile?.email
                let userId = user.userID
                let fullName = user.profile?.name
                let givenName = user.profile?.givenName
                let familyName = user.profile?.familyName
                
                UserDefaults.standard.set(emailAddress, forKey: "userEmail")
                UserDefaults.standard.set(fullName, forKey: "userFullname")
                UserDefaults.standard.set(givenName, forKey: "userGivenname")
                UserDefaults.standard.set(familyName, forKey: "userFamilyname")
                UserDefaults.standard.set(profilePicUrl, forKey: "userProfilepic")
                
                print("userid:  \(user.userID!)")
                let vc = NavigationManager.shared.navigateTo(.tabBarVC)
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    // MARK: Sign In With Google and Send Server Client ID
    
    func signInWithGoogle(completion: @escaping (GIDGoogleUser) -> Void) {
        print("Logging in...")
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            
            let scoper = "https://www.googleapis.com/auth/gmail.readonly"
            
            guard error == nil else { return }
            guard user != nil else { return }
            
            GIDSignIn.sharedInstance.addScopes([scoper], presenting: self) { user, error in
                // MARK: Client ID for Server
                guard error == nil else { return }
                guard let user = user else { return }
                print("Server Authorization Code : \(String(describing: user.serverAuthCode))")
                
                var id: Int?
                
                let url1 = "http://137.184.93.237:5000/kargotakip/user/login"
                let url2 = "http://137.184.93.237:5000/kargotakip/user/getTrendyolMessages"
                let url3 = "http://137.184.93.237:5000/kargotakip/user/getHepsiburadaMessages"
                let url4 = "http://137.184.93.237:5000/kargotakip/user/getTrendyolYemekMessages"
                
                let loginParameters = [
                    "name" : user.profile!.name,
                    "gmail_user_id" : user.userID!,
                    "gmail" : user.profile!.email,
                    "auth_code" : user.serverAuthCode!
                ]

                NetworkManager.shared.jsonPostRequest(url: url1, params: loginParameters, type: LoginDTO.self) { data in
                    id = data.id
                    UserDefaults.standard.set(id, forKey: "userId")
                    user.authentication.do { authentication, error in
                        guard error == nil else { return }
                        guard let authentication = authentication else { return }
                        let idToken = authentication.idToken
                        print("Access Token Expire Date: \(authentication.accessTokenExpirationDate)")
                        print("refresh token: \(authentication.refreshToken)")
                        print("Access Token: \(String(describing: idToken))")
                        completion(user)
                    }
                }
            }
          }
    }
    
    
    // MARK: Sign Out From Google
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
