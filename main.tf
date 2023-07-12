locals {
  docker_build_context = var.docker_build_context
  docker_build_target  = var.docker_build_target

  source_path = local.docker_build_context

  artifact_id       = try(random_string.this[0].id, "unknown")
  artifact_dst_dir  = var.artifact_dst_directory == "" ? "${path.module}/dist" : var.artifact_dst_directory
  artifact_dst_path = abspath("${local.artifact_dst_dir}/${module.artifact_label.id}-${local.artifact_id}${local.artifact_type_dst_suffix_map[var.artifact_src_type]}")
  artifact_src_path = var.artifact_src_path

  artifact_type_dst_suffix_map = {
    zip       = ".zip"
    directory = "/"
  }

  os_script_map = {
    windows = <<-EOT
      $ARTIFACT_DST_DIR=[System.IO.Path]::GetDirectoryName('$ARTIFACT_DST_PATH')
      New-Item -ItemType Directory -Force -Path $ARTIFACT_DST_DIR
      $ARTIFACT_CONTAINER_ID=$(docker create $ARTIFACT_IMAGE echo "ping")
      docker cp $ARTIFACT_CONTAINER_ID:$ARTIFACT_SRC_PATH $ARTIFACT_DST_PATH
      docker rm -fv $ARTIFACT_CONTAINER_ID
    EOT
    unix    = <<-EOT
      ARTIFACT_DST_DIR=$(dirname $ARTIFACT_DST_PATH)
      mkdir -p $ARTIFACT_DST_DIR
      ARTIFACT_CONTAINER_ID=$(docker create $ARTIFACT_IMAGE echo "ping")
      docker cp $ARTIFACT_CONTAINER_ID:$ARTIFACT_SRC_PATH $ARTIFACT_DST_PATH
      docker rm -fv $ARTIFACT_CONTAINER_ID
    EOT
  }
}

module "artifact_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  name        = coalesce(module.this.name, var.name, "artifact")
  label_order = ["name", "attributes"]
  context     = module.this.context
}

resource "docker_image" "this" {
  count = module.artifact_label.enabled ? 1 : 0

  name = module.artifact_label.id

  build {
    context = local.docker_build_context
    target  = local.docker_build_target
    tag     = ["${module.artifact_label.id}:${local.artifact_id}"]

    build_args   = var.docker_build_args
    dockerfile   = "Dockerfile"
    force_remove = false
    label        = {}
    no_cache     = false
    remove       = false
  }
}

data "archive_file" "this" {
  count = module.artifact_label.enabled ? 1 : 0

  type        = "zip"
  output_path = "${path.module}/dist/source-${module.artifact_label.id}.zip"
  source_dir  = local.source_path
}

resource "random_string" "this" {
  count = module.artifact_label.enabled ? 1 : 0

  length  = 6
  special = false
  upper   = false

  keepers = {
    artifact_sha      = data.archive_file.this[0].output_sha
    docker_build_args = jsonencode(var.docker_build_args)
    force_rebuild_id  = var.force_rebuild_id
  }
}

resource "null_resource" "this" {
  count = module.artifact_label.enabled ? 1 : 0

  triggers = {
    artifact_image = docker_image.this[0].image_id
    artifact_path  = local.artifact_dst_path
  }

  provisioner "local-exec" {
    command = local.os_script_map[var.os_compatibility]

    environment = {
      ARTIFACT_IMAGE    = docker_image.this[0].image_id
      ARTIFACT_SRC_PATH = local.artifact_src_path
      ARTIFACT_DST_PATH = local.artifact_dst_path
    }
  }
}
