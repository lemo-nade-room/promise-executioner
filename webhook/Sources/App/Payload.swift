import JWT

struct Payload: JWTPayload {
    func verify(using algorithm: some JWTKit.JWTAlgorithm) async throws {
        try exp.verifyNotExpired()
    }
    var jti: IDClaim
    var sub: SubjectClaim
    var aud: AudienceClaim
    var ref: String
    var sha: String
    var repository: String
    var repositoryOwner: String
    var repositoryOwnerId: String
    var runId: String
    var runNumber: String
    var runAttempt: String
    var repositoryVisibility: String
    var repositoryId: String
    var actorId: String
    var actor: String
    var workflow: String
    var headRef: String
    var baseRef: String
    var eventName: String
    var refProtected: BoolClaim
    var refType: String
    var workflowRef: String
    var workflowSha: String
    var jobWorkflowRef: String
    var jobWorkflowSha: String
    var runnerEnvironment: String
    var iss: String
    var nbf: Int
    var exp: ExpirationClaim
    var iat: Int

    enum CodingKeys: String, CodingKey {
        case jti
        case sub
        case aud
        case ref
        case sha
        case repository
        case repositoryOwner = "repository_owner"
        case repositoryOwnerId = "repository_owner_id"
        case runId = "run_id"
        case runNumber = "run_number"
        case runAttempt = "run_attempt"
        case repositoryVisibility = "repository_visibility"
        case repositoryId = "repository_id"
        case actorId = "actor_id"
        case actor
        case workflow
        case headRef = "head_ref"
        case baseRef = "base_ref"
        case eventName = "event_name"
        case refProtected = "ref_protected"
        case refType = "ref_type"
        case workflowRef = "workflow_ref"
        case workflowSha = "workflow_sha"
        case jobWorkflowRef = "job_workflow_ref"
        case jobWorkflowSha = "job_workflow_sha"
        case runnerEnvironment = "runner_environment"
        case iss
        case nbf
        case exp
        case iat
    }
}
