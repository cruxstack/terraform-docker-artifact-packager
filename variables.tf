variable "artifact_src_path" {
  type        = string
  description = "The path in the Docker container from which to copy the artifact."
}

variable "artifact_dst_directory" {
  type        = string
  description = "The destination directory on the host machine to which the artifact will be copied."
  default     = ""
}

variable "docker_build_context" {
  type        = string
  description = "The context to use when building the Docker image."
}

variable "docker_build_target" {
  type        = string
  description = "The target to use when building the Docker image."
}

variable "docker_build_args" {
  type        = map(string)
  description = "Additional arguments to pass to Docker during the build process."
  default     = {}
}

variable "force_rebuild_id" {
  type        = string
  description = "A unique identifier that, when changed, will force the Docker image to be rebuilt."
  default     = ""
}

variable "os_compatibility" {
  description = "The operating system of Terrafrom environment. Accepts 'unix' or 'windows'."
  type        = string
  default     = "unix"

  validation {
    condition     = var.os_compatibility == "unix" || var.os_compatibility == "windows"
    error_message = "The `os_compatibility` variable must be set to either 'unix' or 'windows'."
  }
}
