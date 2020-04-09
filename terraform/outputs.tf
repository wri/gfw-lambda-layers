
output "lambda_layer_shapely_pyyaml_arn" {
  value = aws_lambda_layer_version.shapely_pyyaml.arn
}

output "lambda_layer_rasterio_arn" {
  value = aws_lambda_layer_version.rasterio.arn
}
