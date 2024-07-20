import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    let response = try await app.client.get("https://token.actions.githubusercontent.com/.well-known/jwks")
    try await app.jwt.keys.use(jwksJSON: String(buffer: response.body!))

    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    // register routes
    try routes(app)
}
