//
//  NewswireCategory.swift
//  NYT Apperino
//
//  Created by William Choi on 8/19/17.
//  Copyright © 2017 choiw. All rights reserved.
//

import Foundation
import RealmSwift

final class NewswireCategory: Object{
    
    dynamic var name = ""
    let items = List<NewswireItem>()
    
    convenience init?(name: String){
        self.init()
        self.name = name
    }
    
}
