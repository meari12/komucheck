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
    @objc dynamic var recordData: Date?
    @objc dynamic var duration: String = ""
    
}
