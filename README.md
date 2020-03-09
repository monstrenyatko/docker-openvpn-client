OpenVPN client Docker image
===========================

[![Build Status](https://travis-ci.org/monstrenyatko/docker-openvpn-client.svg?branch=master)](https://travis-ci.org/monstrenyatko/docker-openvpn-client)

About
=====

[OpenVPN](https://openvpn.net/) client in the `Docker` container.

Upstream Links
--------------
* Docker Registry @[monstrenyatko/openvpn-client](https://hub.docker.com/r/monstrenyatko/openvpn-client/)
* GitHub @[monstrenyatko/docker-openvpn-client](https://github.com/monstrenyatko/docker-openvpn-client)

Quick Start
===========

Container is already configured for automatic restart (See `docker-compose.yml`).

Container configures firewall to block all traffic while VPN network is disconnected.

* Configure environment:

  - `OPENVPN_CLIENT_CONFIG`: path to `ovpn` file:

    ```sh
      export OPENVPN_CLIENT_CONFIG="<path-to-ovpn-file>"
    ```
  - `NET_LOCAL`: [**OPTIONAL**] local network to setup back route rule,
  this is required to allow connections from your local network to the service working over VPN client network:

    ```sh
      export NET_LOCAL="192.168.0.0/16"
    ```
  - `DOCKER_REGISTRY`: [**OPTIONAL**] registry prefix to pull image from a custom `Docker` registry:

    ```sh
      export DOCKER_REGISTRY="my_registry_hostname:5000/"
    ```
* Pull prebuilt `Docker` image:

  ```sh
    docker-compose pull
  ```
* Start prebuilt image:

  ```sh
    docker-compose up -d
  ```
* Stop/Restart:

  ```sh
    docker-compose stop
    docker-compose start
  ```
* Configuration:

  - [**OPTIONAL**] Allow incoming connections to some port from local network:

    + Set `NET_LOCAL` environment variable, see **Configure environment** section
    + Add to `docker-compose.yml` the `ports` section:

      ```yaml
        openvpn-client:
          ports:
            - 8080:8080
      ```
* Start service working over VPN. The simplest way to do this is to utilize the network stack of
  the VPN client container:

  - Add `--network=container:openvpn-client` option to `docker run` command
  - Start service container:

    ```sh
      docker run --rm -it --network=container:openvpn-client alpine:3 /bin/sh
    ```

  **NOTE:** The service container needs to be restarted/recreated when VPN container is restarted/recreated,
  otherwise network connection will not be recovered.

Build own image
===============

* `default` target platform:

  ```sh
    cd <path to sources>
    DOCKER_BUILDKIT=1 docker build --tag <tag name> .
  ```
* `arm/v6` target platform:

  ```sh
    cd <path to sources>
    DOCKER_BUILDKIT=1 docker build --platform=linux/arm/v6 --tag <tag name> .
  ```
