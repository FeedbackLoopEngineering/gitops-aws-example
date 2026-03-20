variable "region" {
  type    = string
  default = "us-east-1"
}

variable "project" {
  type        = string
  description = "Project name prefix for all resources"
}

variable "github_org" {
  type        = string
  description = "GitHub organization name"
}

variable "github_repos" {
  type        = list(string)
  description = "GitHub repositories that need OIDC access"
}
