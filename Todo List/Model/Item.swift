//
//  Item.swift
//  Todo List
//
//  Created by Aleksey Fedorov on 28.07.2021.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var patentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
