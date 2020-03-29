//
//  DailyAnalyticsController.swift
//  CoronalyticsAPI
//
//  Created by Cyril Cermak on 27.03.20.
//  Copyright © Cyril Cermak. All rights reserved.
//

import Vapor

final class DailyAnalyticsController {
    func get(_ req: Request) throws -> Future<[DailyAnalytics]> {
        return DailyAnalytics.query(on: req).all()
    }
}
