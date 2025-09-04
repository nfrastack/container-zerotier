# nfrastack/container-zerotier

## About

This will build a container image for [Zerotier One](https://zerotier.com), A virtual ethernet switch client.

- Includes Zerotier One for setting up virtual private networks
- Also includes the management console [ZTNET](https://github.com/sinamics/next_ztnet)
- Nginx as proxy to ZTNET for logging and authentication

## Maintainer

- [Nfrastack](https://www.nfrastack.com)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Prerequisites and Assumptions](#prerequisites-and-assumptions)
- [Installation](#installation)
  - [Prebuilt Images](#prebuilt-images)
    - [Multi-Architecture Support](#multi-architecture-support)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
- [Environment Variables](#environment-variables)
  - [Base Images used](#base-images-used)
  - [Container Options](#container-options)
  - [Controller Options](#controller-options)
  - [UI Options](#ui-options)
  - [DNS Options](#dns-options)
- [Users and Groups](#users-and-groups)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [Support & Maintenance](#support--maintenance)
- [References](#references)
- [License](#license)

## Prerequisites and Assumptions

- Assumes you are using some sort of SSL terminating reverse proxy such as:
  - [Traefik](https://github.com/tiredofit/docker-traefik)
  - [Nginx](https://github.com/jc21/nginx-proxy-manager)
  - [Caddy](https://github.com/caddyserver/caddy)
- Requires access to a PostgreSQL Server if using the UI

## Installation

### Prebuilt Images

Feature limited builds of the image are available on the [Github Container Registry](https://github.com/nfrastack/container-zerotier/pkgs/container/container-zerotier) and [Docker Hub](https://hub.docker.com/r/nfrastack/zerotier).

To unlock advanced features, one must provide a code to be able to change specific environment variables from defaults. Support the development to gain access to a code.

To get access to the image use your container orchestrator to pull from the following locations:

```sh
ghcr.io/nfrastack/container-zerotier:(image_tag)
docker.io/nfrastack/zerotier:(image_tag)
```

Image tag syntax is:

`<image>:<optional tag>-<optional_distribution>_<optional_distribution_variant>`

Example:

- `ghcr.io/nfrastack/container-zerotier:latest` or
- `ghcr.io/nfrastack/container-zerotier:1.0`

- `latest` will be the most recent commit
- An optional `tag` may exist that matches the [CHANGELOG](CHANGELOG.md) - These are the safest
- If it is built for multiple distributions there may exist a value of `alpine` or `debian`
- If there are multiple distribution variations it may include a version - see the registry for availability

Have a look at the container registries and see what tags are available.

#### Multi-Architecture Support

Images are built for `amd64` by default, with optional support for `arm64` and other architectures.

### Quick Start

- The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [compose.yml](examples/compose.yml) that can be modified for your use.

- Map [persistent storage](#persistent-storage) for access to configuration and data files for backup.
- Set various [environment variables](#environment-variables) to understand the capabilities of this image.

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory | Description                   |
| --------- | ----------------------------- |
| `/data/`  | ZeroTier state information    |
| `/logs/`  | zerotier Log Output Directory |

### Environment Variables

#### Base Images used

This image relies on a customized base image in order to work.
Be sure to view the following repositories to understand all the customizable options:

| Image                                                   | Description     |
| ------------------------------------------------------- | --------------- |
| [OS Base](https://github.com/nfrastack/container-base/) | Base Image      |
| [Nginx](https://github.com/nfrastack/container-nginx/)  | Webserver Image |

Below is the complete list of available options that can be used to customize your installation.

- Variables showing an 'x' under the `Advanced` column can only be set if the containers advanced functionality is enabled.

#### Container Options

| Variable   | Description                                                  | Default         | `_FILE` |
| ---------- | ------------------------------------------------------------ | --------------- | ------- |
| `MODE`     | What mode `CONTROLLER` `UI` `STANDALONE` seperated by commas | `CONTROLLER,UI` |         |
| `LOG_PATH` | Where to store logs                                          | `/logs/`        |         |

#### Controller Options

| Variable                              | Description                                                    | Default             | `_FILE` |
| ------------------------------------- | -------------------------------------------------------------- | ------------------- | ------- |
| `CONTROLLER_ALLOW_TCP_FALLBACK_RELAY` | Enable TCP relay                                               | `TRUE`              |         |
| `CONTROLLER_DATA_PATH`                | Zerotier volatile data                                         | `/data/controller/` |         |
| `CONTROLLER_ENABLE_METRICS`           | Enabler or disable prometheus metrics                          | `FALSE`             |         |
| `CONTROLLER_ENABLE_PORT_MAPPING`      | Enable Port mapping                                            | `TRUE`              |         |
| `CONTROLLER_LISTEN_PORT`              | Zerotier Controller listen port                                | `9993`              |         |
| `CONTROLLER_LOG_FILE`                 | Controller Log File                                            | `controller.log`    |         |
| `CONTROLLER_MANAGEMENT_NETWORKS`      | Comma seperated value of networks allowed to manage controller | `0.0.0.0/0`         |         |
| `CONTROLLER_USER`                     | What username to run controller as                             | `root`              |         |
| `CONTROLLER_NETWORK`                  | (optional) Networks to join as Controller                      |                     | x       |
| `CONTROLLER_IDENTITY_PRIVATE`         | (optional) Pre generated private identity                      |                     | x       |
| `CONTROLLER_IDENTITY_PUBLIC`          | (optional) Pre generated public identity                       |                     | x       |

#### UI Options

| Variable            | Description                                        | Default                                      | `_FILE` |
| ------------------- | -------------------------------------------------- | -------------------------------------------- | ------- |
| `ENABLE_NGINX`      | If wanting to use Nginx as proxy to UI_LISTEN_PORT | `TRUE`                                       |         |
| `NGINX_LISTEN_PORT` | Nginx Listening Port                               | `80`                                         |         |
| `UI_CONTROLLER_URL` | How can the UI access the controller               | `http://localhost:${CONTROLLER_LISTEN_PORT}` |         |
| `UI_DB_HOST`        | DB Host for Postgresql                             |                                              |         |
| `UI_DB_NAME`        | DB Name for UI                                     |                                              |         |
| `UI_DB_PASS`        | Password for UI_DB_USER                            |                                              |         |
| `UI_DB_PORT`        | DB Port for Postgresql                             | `5432`                                       |         |
| `UI_DB_USER`        | DB User for UI_DB_NAME                             |                                              |         |
| `UI_LISTEN_PORT`    | What port for the UI to listen on                  | `3000`                                       |         |
| `UI_SECRET`         | Random secret for session and cookie storage       | `random`                                     |         |
| `UI_SITE_NAME`      | Site name to display on UI                         | `ZTNET`                                      |         |

#### DNS Options

| Variable          | Description                                                                                         | Default                 | `_FILE` |
| ----------------- | --------------------------------------------------------------------------------------------------- | ----------------------- | ------- |
| `ZTNET_API_HOST`  | API Hostname of ZTNET Api Server                                                                    | `http://localhost:3000` |         |
| `ZTNET_API_TOKEN` | API Token able to fetch information from ZTNET Server                                               |                         |         |
| `ZT_NETWORKS`     | Networks as org:dnsname:network (multiple networks separated by comma) eg org123:example.com:net123 |                         |         |

## Users and Groups

| Type  | Name       | ID   |
| ----- | ---------- | ---- |
| User  | `zerotier` | 9376 |
| Group | `zerotier` | 9376 |

* * *

## Maintenance

### Shell Access

For debugging and maintenance, `bash` and `sh` are available in the container.

## Support & Maintenance

- For community help, tips, and community discussions, visit the [Discussions board](/discussions).
- For personalized support or a support agreement, see [Nfrastack Support](https://nfrastack.com/).
- To report bugs, submit a [Bug Report](issues/new). Usage questions will be closed as not-a-bug.
- Feature requests are welcome, but not guaranteed. For prioritized development, consider a support agreement.
- Updates are best-effort, with priority given to active production use and support agreements.

## References

- <https://zerotier.com>

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
