//
//  ListItem.swift
//  todoist
//
//  Created by Piotr Andrzejewski on 18/12/2018.
//  Copyright © 2018 Piotr Andrzejewski. All rights reserved.
//

import Foundation

class ListItem : Codable{
    
    var name : String = ""
    var done : Bool = false
    
    init(name : String) {
        self.name = name
    }
}
