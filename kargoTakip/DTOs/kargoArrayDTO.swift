//
//  kargoArrayDTO.swift
//  kargoTakip
//
//  Created by proje on 13.01.2023.


import Foundation

struct kargoArrayDTO : Codable {
    var kargos = [kargoDTO]()
    
    func printAll(){
        var i = 0
        for kargo in kargos {
            print("kargo\(i) --> \(kargo.date)")
            i += 1
        }
    }
    
    mutating func formatDateAll(){
        for index in 0..<kargos.count {
            let newDate = formatDate(date: kargos[index].date)
            kargos[index].date = newDate
        }
    }
    
    func formatDate(date: String) -> String {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        dateFormatterGet.locale = Locale(identifier: "en_US")

        let dateFormatterSet = DateFormatter()
        dateFormatterSet.dateFormat = "dd-MM-yyyy HH:mm"

        if let date = dateFormatterGet.date(from: date) as NSDate? {
            return dateFormatterSet.string(from: date as Date)
        }
        return date
        
    }
    
    mutating func sortDateAll(){
        kargos.sort(){$0.convertDate(date: $0.date) > $1.convertDate(date: $1.date)}
    }
}
