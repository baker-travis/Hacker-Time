//
//  HackerNewsAPI.swift
//  Hacker Time
//
//  Created by Travis Baker on 1/31/19.
//  Copyright © 2019 Travis Baker. All rights reserved.
//

import Foundation

class HackerNewsAPI {
    static let BASE_URL = "https://hacker-news.firebaseio.com"
    
    enum Endpoints {
        case topStories
        case items(String)
        
        var url: URL {
            switch self {
            case .topStories:
                return URL(string: BASE_URL + "/v0/topstories.json")!
            case let .items(itemId):
                return URL(string: BASE_URL + "/v0/item/\(itemId).json")!
            }
        }
    }
    
    static func getTopStories(completion: @escaping ([Int], Error?) -> Void) {
        let url = Endpoints.topStories.url
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            
            guard let data = data else {
                // TODO: call completion handler with proper error
                return
            }
            
            let decoder = JSONDecoder()
            var responseList: [Int]
            
            do {
                responseList = try decoder.decode([Int].self, from: data)
                DispatchQueue.main.async {
                    completion(responseList, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
        
        task.resume()
    }
    
    static func getItem(itemId: String, completion: @escaping (ItemResponse?, Error?) -> Void) {
        let url = Endpoints.items(itemId).url
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            guard let data = data else {
                // TODO: call completion handler with proper error
                return
            }
            
            let decoder = JSONDecoder()
            var item: ItemResponse
            
            do {
                item = try decoder.decode(ItemResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(item, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
    }
}
