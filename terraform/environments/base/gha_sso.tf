module "gha_sso" {
  source = "../../modules/gha_sso"

  github_org   = var.github_org
  github_repos = var.github_repos
  ecr_arns = [
    module.ecr_base_image.repository_arn,
    module.ecr_app.repository_arn,
  ]
}
