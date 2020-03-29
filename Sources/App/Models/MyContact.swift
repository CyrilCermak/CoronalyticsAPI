//
//  MyContact.swift
//  CoronalyticsAPI
//
//  Created by Cyril Cermak on 28/3/20.
//

import Foundation
import FluentMySQL
import Vapor

enum ScanResult: Int, Codable {
    case clear, infected, friendsInfected, unknown
}

typealias PhoneNumber = String

final class MyContact: MySQLStringModel {
    typealias ID = String

    public static var idKey: IDKey { return \.phone }

    var id: String?
    var phone: String?
    var status: ScanResult

    init(phone: String, status: ScanResult?) {
        self.phone = phone
        self.status = status ?? .unknown
    }
}

extension MyContact: Migration { }

extension MyContact: Content { }

extension MyContact: Parameter { }

extension MyContact {
    var friends: Children<MyContact, MyContactFriend> {
        return children(\.parentId)
    }
}
