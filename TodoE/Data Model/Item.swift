//
//  Item.swift
//  TodoE
//
//  Created by Jon Kyer on 6/4/19.
//  Copyright © 2019 Jon Kyer. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object{
   @objc dynamic  var title : String = ""
   @objc dynamic  var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
