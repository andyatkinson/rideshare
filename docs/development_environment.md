# Development Environment

## Get started with Docker

[Docker](https://docs.docker.com/) provides a way to run applications securely isolated in a container,
packaged with all its dependencies and libraries.

Set up your [Docker environment](https://docs.docker.com/get-started/) and run:

```bash
docker --version
docker compose --version
```

## Run Services in Docker Environment

A [Docker Compose](https://docs.docker.com/compose/compose-file/) defines all services in `.devcontainer/compose.yaml` for this app.
In order to run all servies:

```bash
docker compose -f .devcontainer/compose.yaml up -d
```

## Dev Containers

The application is configured with [devcontainers](https://code.visualstudio.com/docs/devcontainers/containers).

[A development container](https://containers.dev/overview) defines an environment
in which you develop your application before you are ready to deploy.

A `devcontainer.json` file in your project tells
[tools and services that support the dev container spec](https://containers.dev/supporting)
how to access (or create) a dev container with a well-defined tool and runtime stack.

### Install Dev Containers CLI (optional)

[This CLI](https://containers.dev/implementors/reference/) can take a `devcontainer.json` and create and configure
a dev container from it.

```bash
brew install devcontainer
```

### Build and Run Dev Container

```bash
devcontainer build --workspace-folder .
devcontainer up --workspace-folder .
devcontainer exec --workspace-folder . db/setup.sh
```

### Run Rails in Dev Containers

```bash
devcontainer exec --workspace-folder . bin/rails test
devcontainer exec --workspace-folder . bin/rails server
# or
$ devcontainer exec --workspace-folder . zsh
/app $ bin/rails test
/app $ bin/dev
```

When finish work, exit the workspace and run `docker stop $(docker container ls -q)`.
