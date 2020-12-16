variable "bucket" { type = string }
variable "name" { type = string }
variable "runtime" { type = string }
variable "module_version" { type = string }
variable "layer_path" {type = string }
variable "name_suffix" {
  type = string
  default = ""
}
variable "hash_script" {
  description = "Path to script to generate hash of source contents"
  type        = string
  default     = ""
}

variable "touch_script" {
  description = "Path to script to touch layer ZIP"
  type        = string
  default     = ""
}


variable "build_script" {
  description = "Path to script to build Docker image and extract layer ZIP"
  type        = string
  default     = ""
}
