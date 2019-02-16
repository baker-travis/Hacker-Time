//
//  DatabaseManager.swift
//  Hacker Time
//
//  Created by Travis Baker on 2/15/19.
//  Copyright © 2019 Travis Baker. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseManager {
    static let shared = DatabaseManager()
    
    let realm: Realm
    
    private init() {
        self.realm = try! Realm()
    }
    
    func getTopStories() throws -> TopStories {
        let topStoriesResults = realm.objects(TopStories.self)
        if topStoriesResults.count > 0 {
            return topStoriesResults.first!
        }
        var topStories: TopStories!
        do {
            try realm.write {
                topStories = realm.create(TopStories.self)
            }
        } catch {
            throw error
        }
        
        return topStories
    }
    
    func setTopStories(_ stories: [Int]) throws {
        let storedTopStories = try getTopStories().stories
        try realm.write {
            storedTopStories.removeAll()
            storedTopStories.append(objectsIn: stories)
        }
    }
    
    func addItem(_ story: Item) throws {
        // Ensure the item doesn't exist yet
        guard getItem(id: story.id) == nil else {
            return
        }
        do {
            try realm.write {
                realm.add(story)
            }
        } catch {
            throw error
        }
    }
    
    func getItem(id: Int) -> Item? {
        let results = realm.objects(Item.self).filter(NSPredicate(format: "id == \(id)"))
        if results.count > 0 {
            return results.first!
        }
        
        return nil
    }
}
