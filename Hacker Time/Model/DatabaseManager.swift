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
    
    func addStory(_ story: Item) {
        realm.objects(Item.self)
        do {
            try realm.write {
                realm.add(story)
            }
        } catch {
            throw error
        }
    }
}
