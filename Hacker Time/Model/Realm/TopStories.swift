//
//  TopStories.swift
//  Hacker Time
//
//  Created by Travis Baker on 2/15/19.
//  Copyright © 2019 Travis Baker. All rights reserved.
//

import Foundation
import RealmSwift

class TopStories: Object {
    let stories = List<Int>()
    
    let readStories = List<Int>()
}
