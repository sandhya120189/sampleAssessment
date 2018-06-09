//
//  TableViewModel.swift
//  SampleAssesement
//
//  Created by Vinoth Ganapathy on 08/06/18.
//  Copyright © 2018 Gee Vee. All rights reserved.
//

import UIKit
public struct TableViewModel {
    
    public var imageHref: String?
    public var title: String?
    public var description: String?
    
    init(dictionary: NSDictionary) {
        
        self.imageHref = dictionary["imageHref"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.title = dictionary["title"] as? String ?? ""
        
    }
    
}

