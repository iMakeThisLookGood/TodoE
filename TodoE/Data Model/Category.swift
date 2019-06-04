//
//  Category.swift
//  TodoE
//
//  Created by Jon Kyer on 6/4/19.
//  Copyright © 2019 Jon Kyer. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
