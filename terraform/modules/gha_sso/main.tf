data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
}

locals {
  oidc_subject_claims = [
    for repo in var.github_repos :
    "repo:${var.github_org}/${repo}:*"
  ]
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = local.oidc_subject_claims
    }
  }
}

resource "aws_iam_role" "deployment" {
  name               = "gha-deployment"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "ecr" {
  statement {
    sid    = "ECRAuth"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "ECRPushPull"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:ListImages",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
    ]
    resources = var.ecr_arns
  }
}

resource "aws_iam_policy" "ecr" {
  name   = "gha-deployment-ecr"
  policy = data.aws_iam_policy_document.ecr.json
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.deployment.name
  policy_arn = aws_iam_policy.ecr.arn
}

data "aws_iam_policy_document" "secrets_manager" {
  statement {
    sid    = "SecretsManagerRead"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "secrets_manager" {
  name   = "gha-deployment-secrets-manager"
  policy = data.aws_iam_policy_document.secrets_manager.json
}

resource "aws_iam_role_policy_attachment" "secrets_manager" {
  role       = aws_iam_role.deployment.name
  policy_arn = aws_iam_policy.secrets_manager.arn
}

data "aws_iam_policy_document" "sts" {
  statement {
    sid    = "STSGetCallerIdentity"
    effect = "Allow"
    actions = [
      "sts:GetCallerIdentity",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "sts" {
  name   = "gha-deployment-sts"
  policy = data.aws_iam_policy_document.sts.json
}

resource "aws_iam_role_policy_attachment" "sts" {
  role       = aws_iam_role.deployment.name
  policy_arn = aws_iam_policy.sts.arn
}
