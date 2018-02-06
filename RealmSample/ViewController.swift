//
//  ViewController.swift
//  RealmSample
//
//  Created by Naoto Onagi on H30/02/06.
//  Copyright © 平成30年 Naoto Onagi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.main()
    }

    func main() {
        self.setup()
        
        let realm = Realms.realm
        let results = realm.objects(Entity.self)
            .filter(.isSoftRemoved == false && .isActive != true)
            .sorted(by: .id, ascending: false)

        print(results)
    }
    
    func setup() {
        let realm = Realms.realm
        realm.beginWrite()
        
        realm.deleteAll()
        let objects = [
            Entity(id: "1", isSoftRemoved: false, isActive: true),
            Entity(id: "2", isSoftRemoved: false, isActive: false),
            Entity(id: "3", isSoftRemoved: false, isActive: true),
            Entity(id: "4", isSoftRemoved: true, isActive: true),
            Entity(id: "5", isSoftRemoved: true, isActive: true)
        ]
        realm.add(objects)
        
        try! realm.commitWrite()
    }
}
