//
//  Category.swift
//  Todoey
//
//  Created by 1101373 on 2020/07/12.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
    
}
