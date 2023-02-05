//
//  NetworkManager.swift
//  kargoTakip
//
//  Created by proje on 3.11.2022.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func jsonPostRequest<T: Codable>(url: String, params: [String: String], type: T.Type, completion: @escaping (T) -> Void) {
        
        guard let authData = try? JSONEncoder().encode(params) else {
            return
        }
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.uploadTask(with: request, from: authData) { data, response, error in
            
            let decoder = JSONDecoder()
            do {
                 let data = try decoder.decode(T.self, from: data!)
                completion(data)
                } catch {
                    print(error)
                    if let httpresponse = response as? HTTPURLResponse {
                        print("status: \(httpresponse.statusCode)")
                    }
             }
        }
        task.resume()
    }
}
