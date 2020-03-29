//
//  MyContactsController.swift
//  CoronalyticsAPI
//
//  Created by Cyril Cermak on 27.03.20.
//  Copyright © Cyril Cermak. All rights reserved.
//

import Vapor

class MyContactsController {

    /// GET
    func get(_ req: Request) throws -> Future<[MyContact]> {
        return MyContact.query(on: req).all()
    }


    /// Testing only
    func getFriends(_ req: Request) throws -> Future<[MyContactFriend]> {
        return try req.content.decode(CheckContactRequest.self).flatMap { (checkContact) -> Future<[MyContactFriend]> in
            return MyContact.query(on: req).filter(\.phone, .equal, checkContact.phone).first().flatMap { (contact) -> Future<[MyContactFriend]> in
                return try contact!.friends.query(on: req).all()
            }
        }
    }

    /// POST
    func checkContact(_ req: Request) throws -> Future<MyContact> {
        return try req.content.decode(CheckContactRequest.self).flatMap { (contact) -> Future<MyContact> in
            return MyContact.query(on: req).filter(\.phone, .equal, contact.phone).first().map { knownContact -> MyContact in
                guard let knownContact = knownContact else {
                    return MyContact(phone: contact.phone, status: .clear)
                }

                return knownContact
            }
        }
    }

    func newInfection(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.content.decode(UpdateInfectedContactsRequest.self).map { (infectedContact) in
            /// Updates database on the background
            return self.updateInfectedDatabase(on: req, infected: infectedContact)
        }.transform(to: HTTPStatus.accepted)
    }
}

/// Request logic
extension MyContactsController {

    private func checkFriends(for contact: CheckContactRequest, on req: Request) -> Future<MyContact> {
        return MyContact.query(on: req).filter(\.phone, .equal, contact.phone).first().map { knownContact -> MyContact in
            guard knownContact != nil else {
                return MyContact(phone: contact.phone, status: .clear)
            }

            return MyContact(phone: contact.phone, status: .unknown)
        }
    }

    private func updateInfectedDatabase(on req: Request, infected: UpdateInfectedContactsRequest) -> Future<[MyContact]> {
        return MyContact.query(on: req).all().map { (contacts) -> [MyContact] in
            var updatedContacts = [MyContact]()
            let newContact = MyContact(phone: infected.infectedPhone, status: .infected)
            let friendContacts = infected.friendsPhones.map { (phone) -> MyContactFriend in
                return MyContactFriend(phone: phone, status: .friendsInfected, parentId: infected.infectedPhone)
            }

            newContact.create(on: req).map { (contact) in
                friendContacts.map({ (contact) -> Future<MyContactFriend> in
                    return contact.create(on: req)
                }).flatten(on: req)
            }

            contacts.forEach { (contact) in
                if infected.friendsPhones.contains(contact.phone ?? "") {
                    contact.status = .friendsInfected
                    updatedContacts.append(contact)
                }
                if infected.infectedPhone == contact.phone {
                    contact.status = .infected
                    updatedContacts.append(contact)
                }
            }

            return updatedContacts
        }.do { (updatedContacts) in
            updatedContacts.map({ $0.update(on: req) }).flatten(on: req)
        }
    }
}

/// Request models
extension MyContactsController {
    private struct CheckContactRequest: Codable {
        var phone: String
    }

    private struct UpdateInfectedContactsRequest: Codable {
        var infectedPhone: String
        var friendsPhones: [String]
    }
}
