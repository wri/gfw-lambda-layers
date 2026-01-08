locals {
  project         = "lambda-layers"
  name_suffix     = terraform.workspace == "default" ? "" : "-${terraform.workspace}"
  tags = {
    Project     = var.project,
    Environment = var.environment,
    BuiltBy     = "Terraform"
  }
  core          = jsondecode(data.aws_ssm_parameter.core_contract.value)
}