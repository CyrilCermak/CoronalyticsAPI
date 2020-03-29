//
//  MyContactFriend.swift
//  CoronalyticsAPI
//
//  Created by Cyril Cermak on 28/3/20.
//

import Foundation
import FluentMySQL
import Vapor


final class MyContactFriend: MySQLStringModel {
    typealias ID = String

    public static var idKey: IDKey { return \.phone }

    var id: String?
    var phone: String?
    var parentId: MyContact.ID
    var status: ScanResult

    init(phone: String, status: ScanResult?, parentId: MyContact.ID) {
        self.phone = phone
        self.status = status ?? .unknown
        self.parentId = parentId
    }
}

extension MyContactFriend: Migration { }

extension MyContactFriend: Content { }

extension MyContactFriend: Parameter { }

extension MyContactFriend {
    var contact: Parent<MyContactFriend, MyContact> {
        return parent(\.parentId)
    }
}
