locals {
  layer_name  = substr("${var.runtime}-${var.name}_${var.module_version}${var.name_suffix}", 0, 64)
  layer_path  = trimsuffix(var.layer_path, "/")
  source_hash = data.external.source_hash.result.hash
}

resource "null_resource" "build" {
  triggers = {
    source_hash = local.source_hash
  }

  provisioner "local-exec" {
    command     = "${coalesce(var.build_script, "${path.module}/scripts/build.sh")} ${local.layer_path} ${local.layer_name}"
    interpreter = ["bash", "-c"]
  }
}

resource "aws_s3_object" "default" {
  bucket      = var.bucket
  key         = "lambda_layers/${local.layer_name}.zip"
  source      = "${local.layer_path}/layer.zip"
  source_hash = local.source_hash

  depends_on = [null_resource.build]
}

resource "aws_lambda_layer_version" "default" {
  layer_name          = replace(local.layer_name, ".", "")
  s3_bucket           = aws_s3_object.default.bucket
  s3_key              = aws_s3_object.default.key
  compatible_runtimes = [var.runtime]
  source_code_hash    = base64sha256(local.source_hash)
}
