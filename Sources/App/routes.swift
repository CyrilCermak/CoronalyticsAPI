import Vapor

public func routes(_ router: Router) throws {

    router.get { req in
        return "It works!"
    }
    router.group("/api/v1/") { router in
        let analyticsController = DailyAnalyticsController()
        router.get("daily_analytics", use: analyticsController.get)

        router.group("contacts/") { router in
            let myContactsController = MyContactsController()
            /// Testing endpoint
            router.get("all", use: myContactsController.get)

            router.post("friends", use: myContactsController.getFriends)
            router.post("check_contact", use: myContactsController.checkContact)
            router.post("newInfection", use: myContactsController.newInfection)
        }
    }

}
