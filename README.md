# Terraform Module: Docker Artifact Packager

This Terraform module provides a reusable, customizable solution for building
Docker images and extracting artifacts from them. This utility module builds
artifacts with docker to prevent polluting host environment.

## Features

- Builds Docker images using provided build context and arguments
- Creates a unique tag for each Docker image built
- Generates a zip archive of the specified directory
- Copies an artifact from the Docker container to a specified path
- Supports both Linux and Windows Docker containers

## Usage

```hcl
module "artifact_packager" {
  source  = "cruxstack/artifact-packager/docker"
  version = "x.x.x"

  docker_build_context = "${path.module}/examples/aws-lambda-fn/fixures/echo-app"
  docker_build_target  = "package"
  artifact_src_path    = "/tmp/package.zip"
}
```

## Inputs

In addition to the variables documented below, this module includes several
other optional variables (e.g., `name`, `tags`, etc.) provided by the
`cloudposse/label/null` module. Please refer to the [`cloudposse/label` documentation](https://registry.terraform.io/modules/cloudposse/label/null/latest) for more details on these variables.


| Name                     | Description                                                                         |     Type      | Default | Required |
|--------------------------|-------------------------------------------------------------------------------------|:-------------:|:-------:|:--------:|
| `docker_build_context`   | The context to use when building the Docker image.                                  |   `string`    |   n/a   |   yes    |
| `docker_build_target`    | The target to use when building the Docker image.                                   |   `string`    |   n/a   |   yes    |
| `docker_build_args`      | Additional arguments to pass to Docker during the build process.                    | `map(string)` |  `{}`   |    no    |
| `artifact_dst_directory` | The destination directory on the host machine to which the artifact will be copied. |   `string`    |   ""    |    no    |
| `artifact_src_path`      | The path in the Docker container from which to copy the artifact.                   |   `string`    |   n/a   |   yes    |
| `artifact_src_type`      | "The type of artifact to copy. Accepts 'zip' or 'directory'."                       |   `string`    |  `zip`  |    no    |
| `force_rebuild_id`       | A unique identifier that, when changed, will force the Docker image to be rebuilt.  |   `string`    |   ""    |    no    |
| `os_compatibility`       | The operating system of Terrafrom environment. Accepts 'unix' or 'windows'.         |   `string`    | `unix`  |    no    |

## Outputs

| Name                    | Description                                |
|-------------------------|--------------------------------------------|
| `artifact_package_path` | The local path where the artifact located. |

## Contributing

We welcome contributions to this project. For information on setting up a
development environment and how to make a contribution, see [CONTRIBUTING](./CONTRIBUTING.md)
documentation.
