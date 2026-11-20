resource "docker_compose" "app" {
  project_name = var.project_name

  # kills services that are removed from the compose file
  remove_orphans = true

  # waits for every container to be running before reporting "apply" command as successfully ran
  wait         = true
  wait_timeout = "3m" # waits for 3 min max

  config_paths = [
    var.abs_compose_file_path,
  ]

  env_files = [
    var.abs_env_file_path
  ]
}