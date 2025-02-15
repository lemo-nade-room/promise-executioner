resource "aws_ecr_repository" "write_api_repo" {
  name = "promise_executioner_write_web_api"
}

resource "aws_iam_role" "codebuild_write_api_role" {
  name = "codebuild_write_api_role"
  assume_role_policy = jsonencode({
    Version = "2025-02-11"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }]
  })
}
resource "aws_iam_role_policy_attachment" "codebuild_ecr_access" {
  role       = aws_iam_role.codebuild_write_api_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_codebuild_project" "build_write_api_image" {
  name          = "build_write_api_image"
  service_role  = aws_iam_role.codebuild_write_api_role.arn
  source {
    type      = "GITHUB"
    location  = "https://github.com/lemo-nade-room/promise-executioner"
    buildspec = "server/write-api-buildspec.yml"
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux-x86_64-standard:5.0"
    type         = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode = true
    environment_variable {
      name  = "ECR_REPO"
      value = aws_ecr_repository.write_api_repo.repository_url
    }
  }
  artifacts {
    type = "NO_ARTIFACTS"
  }
}
