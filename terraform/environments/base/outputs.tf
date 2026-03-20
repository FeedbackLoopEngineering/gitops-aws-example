output "ecr_base_image_url" {
  value = module.ecr_base_image.repository_url
}

output "ecr_app_url" {
  value = module.ecr_app.repository_url
}

output "gha_deployment_role_arn" {
  value = module.gha_sso.deployment_role_arn
}
