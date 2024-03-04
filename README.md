# tetrode/openfire

- [Introduction](#introduction)
    - [Contributing](#contributing)
    - [Issues](#issues)
- [Getting started](#getting-started)
    - [Installation](#installation)
    - [Quickstart](#quickstart)
    - [Persistence](#persistence)
    - [Logs](#logs)
- [References](#references)

# Introduction

This image is a fork of nasqueron/openfire to be able to build images of any version
of [Openfire](http://www.igniterealtime.org/projects/openfire/).

Openfire is a real time collaboration (RTC) server licensed under the Open Source Apache License. It uses the only
widely adopted open protocol for instant messaging, XMPP (also called Jabber). Openfire is incredibly easy to set up and
administer, but offers rock-solid security and performance.

## Contributing

If you find this image useful here's how you can help:

- Send a pull request with your awesome features and bug fixes
- Help users resolve their [issues](../../issues?q=is%3Aopen+is%3Aissue).

## Issues

Before reporting a bug please try updating Docker to the latest version and check if it resolves the issue. Refer to the
Docker [installation guide](https://docs.docker.com/installation) for instructions.

SELinux users should try disabling SELinux using the command `setenforce 0` to see if it resolves the issue.

If the above recommendations do not help then [report your issue](../../issues/new) along with the following
information:

- Output of the `docker version` and `docker info` commands
- The `docker run` command or `docker-compose.yml` used to start the image. Mask out the sensitive bits.
- Please state if you are using [Boot2Docker](http://www.boot2docker.io), [VirtualBox](https://www.virtualbox.org), etc.

# Getting started

## Installation

Automated builds of the image are available on [Dockerhub](https://hub.docker.com/r/tetrode/openfire) and is the
recommended method of installation.

```bash
docker pull tetrode/openfire:4.8.1
```

Alternatively you can build the image yourself.

```bash
docker build -t tetrode/openfire github.com/tetrode/docker-openfire
```

## Quickstart

Start Openfire using:

```bash
docker run --name openfire -d --restart=always \
  --publish 9090:9090 --publish 5222:5222 --publish 7777:7777 \
  --volume ./config/openfire:/var/lib/openfire \
  tetrode/openfire:4.8.1
```

*Alternatively, you can use the
sample [docker-compose.yml](https://github.com/tetrode/docker-openfire/blob/main/docker-compose.yml) file to start the
container using [Docker Compose](https://docs.docker.com/compose/)*

Point your browser to http://localhost:9090 and follow the setup procedure to complete the installation.
The [Build A Free Jabber Server In 10 Minutes](https://www.youtube.com/watch?v=ytUB5qJm5HE#t=246s) video by HAKK5 should
help you with the configuration and also introduce you to some of its features.

## Persistence

For the Openfire to preserve its state across container shutdown and startup you should mount a volume
at `/var/lib/openfire`.

> *The [Quickstart](#quickstart) command already mounts a volume for persistence.*

SELinux users should update the security context of the host mountpoint so that it plays nicely with Docker:

```bash
mkdir -p /srv/docker/openfire
chcon -Rt svirt_sandbox_file_t /srv/docker/openfire
```

## Java VM options

You may append options to the startup command to configure the JVM:

```bash
docker run -name openfire -d \
  [DOCKER_OPTIONS] \
  tetrode/openfire:4.8.1 \
  -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode
```

## Logs

To access the Openfire logs, located at `/var/log/openfire`, you can use `docker exec`. For example, if you want to tail
the logs:

```bash
docker exec -it openfire tail -f /var/log/openfire/info.log
```

# Maintenance

## Upgrading

To upgrade to newer releases:

1. Download the updated Docker image:

  ```bash
  docker pull tetrode/openfire:4.8.1
  ```

2. Stop the currently running image:

  ```bash
  docker stop openfire
  ```

3. Remove the stopped container

  ```bash
  docker rm -v openfire
  ```

4. Start the updated image

  ```bash
  docker run -name openfire -d \
    [OPTIONS] \
    tetrode/openfire:4.8.1
  ```

## Shell Access

For debugging and maintenance purposes you may want access the containers shell. If you are using Docker version `1.3.0`
or higher you can access a running containers shell by starting `bash` using `docker exec`:

```bash
docker exec -it openfire bash
```

# References

* http://www.igniterealtime.org/projects/openfire/
