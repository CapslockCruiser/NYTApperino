//
//  NewswireItem.swift
//  NYT Apperino
//
//  Created by William Choi on 8/19/17.
//  Copyright © 2017 choiw. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

final class NewswireItem: Object{
    
    dynamic var title = ""
    dynamic var abstract = ""
    dynamic var url = ""
    dynamic var thumbnailURL = ""
    private var category = LinkingObjects(fromType: NewswireCategory.self, property: "items")
    
    convenience init?(result: JSON){
        self.init()
        self.title = result["title"].string ?? "Title"
        self.abstract = result["abstract"].string ?? "Abstract"
        self.url = result["url"].string ?? "URL"
        self.thumbnailURL = result["thumbnail_standard"].string ?? "Thumbnail URL"
        
        let realm = try! Realm()
        
        var cat: NewswireCategory?
        
        if let categoryExists = realm.objects(NewswireCategory.self).filter("name = '\(result["section"].stringValue)'").first{
            categoryExists.items.append(self)
        }else{
            cat = NewswireCategory.init(name: "\(result["section"].stringValue)")
            cat?.items.append(self)
        }
        
    }
    
}
