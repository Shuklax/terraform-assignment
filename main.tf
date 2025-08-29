
locals {
  name_prefix = "${var.project_name}-${var.env}"
}

module "vpc" {
  source = "./modules/vpc"

  project_name = local.name_prefix
  region       = var.region
}

module "s3" {
  source = "./modules/s3"

  project_name = local.name_prefix
}

module "ecs" {
  source = "./modules/ecs"

  project_name    = local.name_prefix
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  use_arm         = var.use_arm
  aws_region      = var.region
  alb_sg_id       = module.vpc.alb_sg_id
  ecs_sg_id       = module.vpc.ecs_sg_id

}

module "cloudwatch" {
  source = "./modules/cloudwatch"

  project_name     = local.name_prefix
  ecs_cluster_name = module.ecs.cluster_name
  ecs_service_name = module.ecs.service_name
  ecs_task_family  = module.ecs.task_family
}