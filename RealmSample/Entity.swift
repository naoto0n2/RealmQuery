//
//  Entity.swift
//  RealmSample
//
//  Created by Naoto Onagi on H30/02/06.
//  Copyright © 平成30年 Naoto Onagi. All rights reserved.
//

import Foundation
import RealmSwift

class Entity: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var isSoftRemoved: Bool = false
    @objc dynamic var isActive: Bool = false
    
    enum Column: String, ColumnType {
        case id
        case isSoftRemoved
        case isActive
    }
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    convenience init(id: String, isSoftRemoved: Bool, isActive: Bool) {
        self.init()
        self.id = id
        self.isSoftRemoved = isSoftRemoved
        self.isActive = isActive
    }
}

extension Entity: Editable {}
