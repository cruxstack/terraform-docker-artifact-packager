# Terraform Module: Docker Artifact Packager

This Terraform module provides a reusable, customizable solution for building
Docker images and extracting artifacts from them.

## Features

- Builds Docker images using provided build context and arguments
- Creates a unique tag for each Docker image built
- Generates a zip archive of the specified directory
- Copies an artifact from the Docker container to a specified path
- Supports both Linux and Windows Docker containers

## Usage

```hcl
module "docker_builder" {
  source = "sgtoj/artifact-packager/docker"

  docker_build_context = "${path.module}/example/aws-lambda-fn/fixures/echo-app"
  docker_build_target  = "package"
  docker_build_args    = {}
  artifact_src_path    = "/tmp/package.zip"
}
```

### Note

This module uses the `cloudposse/label/null` module for naming and tagging
resources. As such, it also includes a `context.tf` file with additional
optional variables you can set. Refer to the [`cloudposse/label` documentation](https://registry.terraform.io/modules/cloudposse/label/null/latest)
for more details on these variables.

## Requirements

- Terraform 0.13 and above
- Docker installed and running on the machine where Terraform is executed

## Inputs

| Name                     | Description                                                                         |     Type      | Default | Required |
|--------------------------|-------------------------------------------------------------------------------------|:-------------:|:-------:|:--------:|
| `docker_build_context`   | The context to use when building the Docker image.                                  |   `string`    |   n/a   |   yes    |
| `docker_build_target`    | The target to use when building the Docker image.                                   |   `string`    |   n/a   |   yes    |
| `docker_build_args`      | Additional arguments to pass to Docker during the build process.                    | `map(string)` |  `{}`   |    no    |
| `artifact_dst_directory` | The destination directory on the host machine to which the artifact will be copied. |   `string`    |   ""    |    no    |
| `artifact_src_path`      | The path in the Docker container from which to copy the artifact.                   |   `string`    |   n/a   |   yes    |
| `force_rebuild_id`       | A unique identifier that, when changed, will force the Docker image to be rebuilt.  |   `string`    |   ""    |    no    |
| `os_compatibility`       | The operating system of Terrafrom environment. Accepts 'unix' or 'windows'.         |   `string`    | `unix`  |    no    |

## Outputs

| Name                    | Description                                    |
|-------------------------|------------------------------------------------|
| `artifact_package_path` | The local path where the artifact is copied to |

## Development Environment

This repository includes a configuration for a development container using the
[VS Code Remote - Containers extension](https://code.visualstudio.com/docs/remote/containers).
This setup allows you to develop within a Docker container that already has all
the necessary tools and dependencies installed.

The development container is based on Ubuntu 20.04 (Focal) and includes the
following tools:

- AWS CLI
- Node.js
- TypeScript
- Docker CLI
- Terraform

### Prerequisites

- [Docker](https://www.docker.com/products/docker-desktop) installed on your
  local machine.
- [Visual Studio Code](https://code.visualstudio.com/) installed on your
  local machine.
- [Remote - Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
  for Visual Studio Code.

### Usage

1. Clone this repository:

    ```bash
    git clone https://github.com/sgtoj/terraform-docker-artifact-packager.git
    ```

2. Open the repository in Visual Studio Code:

    ```bash
    code terraform-docker-artifact-packager
    ```

3. When prompted to "Reopen in Container", click "Reopen in Container". This
   will start building the Docker image for the development container. If you're
   not prompted, you can open the Command Palette (F1 or Ctrl+Shift+P), and run
   the "Remote-Containers: Reopen Folder in Container" command.

4. After the development container is built and started, you can use the
   Terminal in Visual Studio Code to interact with the container. All commands
  you run in the Terminal will be executed inside the container.

### Troubleshooting

If you encounter any issues while using the development container, you can try
rebuilding the container. To do this, open the Command Palette and run the
"Remote-Containers: Rebuild Container" command.
