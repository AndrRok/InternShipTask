//
//  NetworkManager.swift
//  InternShipTask
//
//  Created by ARMBP on 8/27/23.
//


import UIKit

class NetworkManager {
    let cache = NSCache<NSString, UIImage>()
    static let shared = NetworkManager()// пока изучаю dependency injection. Знаю что синглтоны не очень
    private let mainURL = "https://www.avito.st/s/interns-ios/main-page.json"
    private let deteilsURL = "https://www.avito.st/s/interns-ios/details/"
    
    
    private init() {}
    
    func getMainRequest(completed: @escaping (Result< ItemsResponse, ErrorMessages>) -> Void) {
        let endpoint = mainURL
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy  = .convertFromSnakeCase
                let itemResult            = try decoder.decode(ItemsResponse.self, from: data)
                completed(.success(itemResult))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    
    func getDetails(id: String, completed: @escaping (Result<DetailModel, ErrorMessages>) -> Void) {
        let endpoint = deteilsURL + "\(id).json"

        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidRequest))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy  = .convertFromSnakeCase
                let detailResult        = try decoder.decode(DetailModel.self, from: data)
                completed(.success(detailResult))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    //MARK: - DownLoad image
    func downloadImage(fromURLString urlString: String, completed: @escaping(UIImage?) -> Void ){
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey){
            completed(image)
            return
        }
        
        
        guard let url = URL(string: urlString) else{
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else{
                completed(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
        
    }
}


