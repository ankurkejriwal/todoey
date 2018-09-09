//
//  Item.swift
//  todoey
//
//  Created by Ankur Kejriwal on 2018-07-18.
//  Copyright © 2018 Ankur kejriwal. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    
    var parentCatergory = LinkingObjects (fromType: catergory.self, property: "items")//AutoUpdating Containers (Inverse relationships of items)
    
    //makes it the catergory type
    
    
    
}
