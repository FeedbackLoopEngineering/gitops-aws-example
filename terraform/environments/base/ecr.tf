module "ecr_base_image" {
  source = "../../modules/ecr"

  name                 = "${var.project}/base-image"
  image_tag_mutability = "IMMUTABLE"
}

module "ecr_app" {
  source = "../../modules/ecr"

  name                 = "${var.project}/app"
  image_tag_mutability = "MUTABLE"
}
