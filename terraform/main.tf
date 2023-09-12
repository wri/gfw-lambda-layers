terraform {
  backend "s3" {
    region         = "us-east-1"
    key            = "lambda-layers.tfstate"
    dynamodb_table = "aws-locks"
    encrypt        = true
  }
}

data "terraform_remote_state" "core" {
  backend = "s3"
  config = {
    bucket = local.tf_state_bucket
    region = "us-east-1"
    key    = "core.tfstate"
  }
}

module "py37_shapely_164" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "shapely_pyyaml"
  module_version = "1.6.4"
  runtime        = "python3.7"
  name_suffix    = local.name_suffix
  layer_path     = "${path.root}/layers/python3.7/shapely_pyyaml_1.6.4/"
}

module "py37_rasterio_115" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "rasterio"
  module_version = "1.1.5"
  runtime        = "python3.7"
  layer_path     = "${path.root}/layers/python3.7/rasterio_1.1.5/"
}

module "py37_pandas_110" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "pandas"
  module_version = "1.1.0"
  runtime        = "python3.7"
  layer_path     = "${path.root}/layers/python3.7/pandas_1.1.0/"
}

module "py38_mercantile_121" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "mercantile"
  module_version = "1.2.1"
  runtime        = "python3.8"
  layer_path     = "${path.root}/layers/python3.8/mercantile_1.2.1/"
}

module "py38_rasterio_1210" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "rasterio"
  module_version = "1.2.10"
  runtime        = "python3.8"
  layer_path     = "${path.root}/layers/python3.8/rasterio_1.2.10/"
}

module "py38_pillow_831" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "pillow"
  module_version = "8.3.1"
  runtime        = "python3.8"
  layer_path     = "${path.root}/layers/python3.8/pillow_8.3.1/"
}

module "py310_mercantile_121" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "mercantile"
  module_version = "1.2.1"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/mercantile_1.2.1/"
}

module "py310_pandas_153" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "pandas"
  module_version = "1.5.3"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/pandas_1.5.3/"
}

module "py310_pillow_950" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "pillow"
  module_version = "9.5.0"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/pillow_9.5.0/"
}

module "py310_rasterio_138" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "rasterio"
  module_version = "1.3.8"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/rasterio_1.3.8/"
}

module "py310_shapely_185" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "shapely"
  module_version = "1.8.5"
  runtime        = "python3.10"
  name_suffix    = local.name_suffix
  layer_path     = "${path.root}/layers/python3.10/shapely_1.8.5post1/"
}