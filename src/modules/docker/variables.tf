
# REQUIRED

variable "abs_compose_file_path" {
  type = string
}

variable "abs_env_file_path" {
  type = string
}

# OPTIONAL

variable "project_name" {
  type    = string
  default = "kalypso"
}