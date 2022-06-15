//
//  Kiroku.swift
//  gyomucheck
//
//  Created by Meri Sato on 2022/06/01.
//

import Foundation
import RealmSwift

class Kiroku: Object {
    @objc dynamic var subject: String = ""
    @objc dynamic var recordDateString: String = ""
    @objc dynamic var duration: String = ""
    
}

public var primaryKey: String {
        return "date"
   }
