//
//  MyContact.swift
//  CoronalyticsAPI
//
//  Created by Cyril Cermak on 28/3/20.
//

import FluentMySQL
import Vapor

final class DailyAnalytics: MySQLModel {

    var id: Int?

    let city: String
    let state: String
    let lastUpdate: String
    let confirmed: Int
    let deaths: Int
    let recovered: Int

    init(city: String, state: String, lastUpdate: String, confirmed: Int, deaths: Int, recovered: Int) {
        self.city = city
        self.state = state
        self.lastUpdate = lastUpdate
        self.confirmed = confirmed
        self.deaths = deaths
        self.recovered = recovered
    }
}

extension DailyAnalytics: Migration { }

extension DailyAnalytics: Content { }

extension DailyAnalytics: Parameter { }
