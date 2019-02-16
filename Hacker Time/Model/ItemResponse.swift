//
//  Item.swift
//  Hacker Time
//
//  Created by Travis Baker on 1/31/19.
//  Copyright © 2019 Travis Baker. All rights reserved.
//

import Foundation

enum ItemType: String, Codable {
    case job, story, comment, poll, pollopt
}

class ItemResponse: Codable {
    let id: Int
    let by: String?
    let deleted: Bool?
    let type: ItemType?
    let time: Int? // In Unix time
    let text: String? // this is in HTML
    let parent: Int?
    let poll: Int? // The id of the poll for a pollopt
    let kids: [Int]?
    let url: String?
    let score: Int? // Score or vote
    let title: String?
    let parts: [Int]? // For polls, a list of the options
    let descendants: Int? // the total count of comments
}
