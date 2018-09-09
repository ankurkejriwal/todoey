//
//  catergory.swift
//  todoey
//
//  Created by Ankur Kejriwal on 2018-07-18.
//  Copyright © 2018 Ankur kejriwal. All rights reserved.
//

import Foundation
import RealmSwift

class catergory: Object {
    @objc dynamic var name : String = ""
    
    let items = List<Item>()
    
    
}
