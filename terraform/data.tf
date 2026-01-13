data "aws_ssm_parameter" "core_contract" {
  name = "/infra/${var.environment}/gfw-aws-core-infra/contract"
}
