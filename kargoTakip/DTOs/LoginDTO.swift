//
//  LoginDTO.swift
//  kargoTakip
//
//  Created by proje on 10.01.2023.
//

import Foundation

struct LoginDTO: Codable {
    
    var id = 0
    var name = ""
    var gmail = ""
    var gmail_user_id = ""
    var access_token = ""
    
    func printAll(){
        print("id: \(id), name \(name), gmail: \(gmail), gmail_user_id: \(gmail_user_id), access_token: \(access_token)")
    }
}
