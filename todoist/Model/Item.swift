//
//  Item.swift
//  todoist
//
//  Created by Piotr Andrzejewski on 20/12/2018.
//  Copyright © 2018 Piotr Andrzejewski. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var date : Date?
    let category = LinkingObjects(fromType: Category.self, property: "items")
}
