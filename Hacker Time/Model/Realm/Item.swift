//
//  Item.swift
//  Hacker Time
//
//  Created by Travis Baker on 2/15/19.
//  Copyright © 2019 Travis Baker. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var id: Int = -1
    @objc dynamic var by: String?
    let deleted = RealmOptional<Bool>()
    @objc dynamic var type: String?
    let time = RealmOptional<Int>() // In Unix time
    @objc dynamic var text: String? // this is in HTML
    let parent = RealmOptional<Int>()
    let poll = RealmOptional<Int>() // The id of the poll for a pollopt
    let kids = List<Int>()
    @objc dynamic var url: String?
    let score = RealmOptional<Int>() // Score or vote
    @objc dynamic var title: String?
    let parts = List<Int>() // For polls, a list of the options
    let descendants = RealmOptional<Int>() // the total count of comments
    
    func setFrom(itemResponse: ItemResponse) {
        id = itemResponse.id
        by = itemResponse.by
        deleted.value = itemResponse.deleted
        type = itemResponse.type?.rawValue
        time.value = itemResponse.time
        text = itemResponse.text
        parent.value = itemResponse.parent
        poll.value = itemResponse.poll
        if let responseKids = itemResponse.kids {
            kids.append(objectsIn: responseKids)
        }
        url = itemResponse.url
        score.value = itemResponse.score
        title = itemResponse.title
        if let responseParts = itemResponse.parts {
            parts.append(objectsIn: responseParts)
        }
        descendants.value = itemResponse.descendants
    }
}
