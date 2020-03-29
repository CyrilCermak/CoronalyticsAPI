import FluentMySQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentMySQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Configure a SQLite database
    /// Register middleware
   var middlewares = MiddlewareConfig() // Create _empty_ middleware config
   /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
   middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
   services.register(middlewares)

   let mysql = MySQLDatabase(config: MySQLDatabaseConfig(hostname: "127.0.0.1", port: 3306, username: "root", password: "root", database: "Coronalytics", capabilities: .default, characterSet: .utf8mb4_unicode_ci, transport: .cleartext))
   /// Register the configured MySQL database to the database config.
   
   var databases = DatabasesConfig()
   databases.enableLogging(on: .mysql)
   databases.add(database: mysql, as: .mysql)
   services.register(databases)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: DailyAnalytics.self, database: .mysql)
    migrations.add(model: MyContact.self, database: .mysql)
    migrations.add(model: MyContactFriend.self, database: .mysql)
    services.register(migrations)
    
}
