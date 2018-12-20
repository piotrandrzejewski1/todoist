//
//  Category.swift
//  todoist
//
//  Created by Piotr Andrzejewski on 20/12/2018.
//  Copyright © 2018 Piotr Andrzejewski. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
