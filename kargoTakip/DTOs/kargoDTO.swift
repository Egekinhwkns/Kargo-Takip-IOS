//
//  kargoDTO.swift
//  kargoTakip
//
//  Created by proje on 9.11.2022.


import Foundation

struct kargoDTO : Codable {
   
    var status = 5
    var company = ""
    var store : String?  = ""
    var product = ""
    var date = ""

    func printAll(){
        print(" status: \(status), company: \(company), store: \(store), product: \(product), orderDate: \(date)")
    }
    
    func convertDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let convertedDate = dateFormatter.date(from: date)
        return convertedDate ?? Date()
    }
}

