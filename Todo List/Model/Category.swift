//
//  Category.swift
//  Todo List
//
//  Created by Aleksey Fedorov on 28.07.2021.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
}
