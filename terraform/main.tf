terraform {
  backend "s3" {
    region         = "us-east-1"
    key            = "lambda-layers.tfstate"
    dynamodb_table = "aws-locks"
    encrypt        = true
  }
}

module "py310_geopandas_0144" {
  source         = "./modules/lambda_layer"
  bucket         = local.core.gfw_pipelines_bucket_name
  name           = "geopandas"
  module_version = "0.14.4"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/geopandas_0.14.4/"
}

module "py310_mercantile_121" {
  source         = "./modules/lambda_layer"
  bucket         = local.core.gfw_pipelines_bucket_name
  name           = "mercantile"
  module_version = "1.2.1"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/mercantile_1.2.1/"
}

module "py310_numpy_1264" {
  source         = "./modules/lambda_layer"
  bucket         = local.core.gfw_pipelines_bucket_name
  name           = "numpy"
  module_version = "1.26.4"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/numpy_1.26.4/"
}

module "py310_pandas_153" {
  source         = "./modules/lambda_layer"
  bucket         = local.core.gfw_pipelines_bucket_name
  name           = "pandas"
  module_version = "1.5.3"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/pandas_1.5.3/"
}

module "py310_pillow_950" {
  source         = "./modules/lambda_layer"
  bucket         = local.core.gfw_pipelines_bucket_name
  name           = "pillow"
  module_version = "9.5.0"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/pillow_9.5.0/"
}

module "py310_rasterio_138" {
  source         = "./modules/lambda_layer"
  bucket         = local.core.gfw_pipelines_bucket_name
  name           = "rasterio"
  module_version = "1.3.8"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/rasterio_1.3.8/"
}

module "py310_shapely_185" {
  source         = "./modules/lambda_layer"
  bucket         = local.core.gfw_pipelines_bucket_name
  name           = "shapely"
  module_version = "1.8.5"
  runtime        = "python3.10"
  name_suffix    = local.name_suffix
  layer_path     = "${path.root}/layers/python3.10/shapely_1.8.5post1/"
}

# These are temporary:
module "py310_geopandas_no_numpy_no_pandas" {
  source         = "./modules/lambda_layer"
  bucket         = local.core.gfw_pipelines_bucket_name
  name           = "geopandas_no_numpy_no_pandas"
  module_version = "0.14.4"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/geopandas_no_numpy_no_pandas/"
}

module "py310_numpy" {
  source         = "./modules/lambda_layer"
  bucket         = local.core.gfw_pipelines_bucket_name
  name           = "numpy"
  module_version = "1.26.4"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/numpy/"
}

module "py310_pandas_no_numpy" {
  source         = "./modules/lambda_layer"
  bucket         = local.core.gfw_pipelines_bucket_name
  name           = "pandas_no_numpy"
  module_version = "1.5.3"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/pandas_no_numpy/"
}

module "py310_rasterio_no_numpy" {
  source         = "./modules/lambda_layer"
  bucket         = local.core.gfw_pipelines_bucket_name
  name           = "rasterio_no_numpy"
  module_version = "1.3.8"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/rasterio_no_numpy/"
}

module "py310_shapely_no_numpy" {
  source         = "./modules/lambda_layer"
  bucket         = local.core.gfw_pipelines_bucket_name
  name           = "shapely_no_numpy"
  module_version = "1.8.5"
  runtime        = "python3.10"
  name_suffix    = local.name_suffix
  layer_path     = "${path.root}/layers/python3.10/shapely_no_numpy/"
}

# These are new:
module "py313_geopandas_112" {
  source         = "./modules/lambda_layer"
  bucket         = local.core.gfw_pipelines_bucket_name
  name           = "py313_geopandas_112"
  module_version = "1.1.2"
  runtime        = "python3.13"
  layer_path     = "${path.root}/layers/python3.13/geopandas_1.1.2/"
}

module "py313_mercantile_121" {
  source         = "./modules/lambda_layer"
  bucket         = local.core.gfw_pipelines_bucket_name
  name           = "py313_mercantile_121"
  module_version = "1.2.1"
  runtime        = "python3.13"
  layer_path     = "${path.root}/layers/python3.13/mercantile_1.2.1/"
}

module "py313_numpy_242" {
  source         = "./modules/lambda_layer"
  bucket         = local.core.gfw_pipelines_bucket_name
  name           = "py313_numpy_242"
  module_version = "2.4.2"
  runtime        = "python3.13"
  layer_path     = "${path.root}/layers/python3.13/numpy_2.4.2/"
}

module "py313_pandas_233" {
  source         = "./modules/lambda_layer"
  bucket         = local.core.gfw_pipelines_bucket_name
  name           = "py313_pandas_233"
  module_version = "2.3.3"
  runtime        = "python3.13"
  layer_path     = "${path.root}/layers/python3.13/pandas_2.3.3/"
}

module "py313_pillow_1210" {
  source         = "./modules/lambda_layer"
  bucket         = local.core.gfw_pipelines_bucket_name
  name           = "py313_pillow_1210"
  module_version = "12.1.0"
  runtime        = "python3.13"
  layer_path     = "${path.root}/layers/python3.13/pillow_12.1.0/"
}

module "py313_rasterio_144" {
  source         = "./modules/lambda_layer"
  bucket         = local.core.gfw_pipelines_bucket_name
  name           = "py313_rasterio_144"
  module_version = "1.4.4"
  runtime        = "python3.13"
  layer_path     = "${path.root}/layers/python3.13/rasterio_1.4.4/"
}

module "py313_shapely_212" {
  source         = "./modules/lambda_layer"
  bucket         = local.core.gfw_pipelines_bucket_name
  name           = "py313_shapely_212"
  module_version = "2.1.2"
  runtime        = "python3.13"
  name_suffix    = local.name_suffix
  layer_path     = "${path.root}/layers/python3.13/shapely_2.1.2/"
}

module "ssm" {
  source      = "git::https://github.com/wri/gfw-terraform-modules.git//terraform/modules/ssm?ref=v0.4.2.12"
  environment = var.environment
  namespace   = "gfw-lambda-layers"
  contract = {
    py310_geopandas_0144_arn    = module.py310_geopandas_0144.layer_arn
    py310_mercantile_121_arn    = module.py310_mercantile_121.layer_arn
    py310_numpy_1264_arn        = module.py310_numpy_1264.layer_arn
    py310_numpy_arn             = module.py310_numpy.layer_arn
    py310_pandas_no_numpy_arn   = module.py310_pandas_no_numpy.layer_arn
    py310_pillow_950_arn        = module.py310_pillow_950.layer_arn
    py310_rasterio_no_numpy_arn = module.py310_rasterio_no_numpy.layer_arn
    py310_shapely_no_numpy_arn  = module.py310_shapely_no_numpy.layer_arn
    py313_geopandas_112_arn     = module.py313_geopandas_112.layer_arn
    py313_mercantile_121_arn    = module.py313_mercantile_121.layer_arn
    py313_numpy_242_arn         = module.py313_numpy_242.layer_arn
    py313_pandas_233_arn        = module.py313_pandas_233.layer_arn
    py313_pillow_1210_arn       = module.py313_pillow_1210.layer_arn
    py313_rasterio_144_arn      = module.py313_rasterio_144.layer_arn
    py313_shapely_212_arn       = module.py313_shapely_212.layer_arn
  }
  lists = {}
  strings = {}
  secure_strings = {}
}
