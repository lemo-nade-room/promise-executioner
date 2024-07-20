import JWT
import SwiftCommand
import Vapor
import struct SystemPackage.FilePath

func routes(_ app: Application) throws {
    app.post("webhook", "deploy", "api") { req async throws -> HTTPStatus in
        let payload = try await req.jwt.verify(as: Payload.self)

        let repository = Environment.get("GITHUB_REPOSITORY")
        guard payload.repository == repository else {
            req.logger.warning("【repository】予期: \"\(repository ?? "nil")\", 実際: \"\(payload.repository)\"")
            throw Abort(.unauthorized)
        }

        let repositoryOwner = Environment.get("GITHUB_REPOSITORY_OWNER")
        guard payload.repositoryOwner == repositoryOwner else {
            req.logger.warning(
                "【repository_owner】予期: \"\(repositoryOwner ?? "nil")\", 実際: \"\(payload.repositoryOwner)\""
            )
            throw Abort(.unauthorized)
        }

        let iss = "https://token.actions.githubusercontent.com"
        guard payload.iss == iss else {
            req.logger.warning("【iss】予期: \"\(iss)\" does not match payload issuer \"\(payload.iss)\"")
            throw Abort(.unauthorized)
        }

        guard let workDirStr = Environment.get("WORKDIR") else {
            throw Abort(.internalServerError, reason: "WORKDIR environment variable not set")
        }
        let workDir = FilePath(workDirStr)

        guard try Command.findInPath(withName: "docker")!
            .addArgument("compose")
            .addArgument("pull")
            .setCWD(workDir)
            .wait()
            .terminatedSuccessfully
        else {
            throw Abort(.internalServerError, reason: "Failed to docker compose pull")
        }
        guard try Command.findInPath(withName: "docker")!
            .addArgument("compose")
            .addArgument("up")
            .addArgument("-d")
            .setCWD(workDir)
            .wait()
            .terminatedSuccessfully
        else {
            throw Abort(.internalServerError, reason: "Failed to docker compose up -d")
        }

        return .noContent
    }
}
