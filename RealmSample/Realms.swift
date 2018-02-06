//
//  Realms.swift
//  RealmSample
//
//  Created by Naoto Onagi on H30/02/06.
//  Copyright © 平成30年 Naoto Onagi. All rights reserved.
//

import Foundation
import RealmSwift

struct Realms {
    static var realm: Realm {
        return try! Realm()
    }
}
