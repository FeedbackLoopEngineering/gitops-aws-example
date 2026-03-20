variable "github_org" {
  type        = string
  description = "GitHub organization name"
}

variable "github_repos" {
  type        = list(string)
  description = "GitHub repositories that need OIDC access"
}

variable "ecr_arns" {
  type        = list(string)
  description = "ARNs of ECR repositories the deployment role needs access to"
}
