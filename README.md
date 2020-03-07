OpenVPN client Docker image
===========================

About
=====

[OpenVPN](https://openvpn.net/) client in the `Docker` container.

Upstream Links
--------------
* Docker Registry @[monstrenyatko/openvpn-client](https://hub.docker.com/r/monstrenyatko/openvpn-client/)
* GitHub @[monstrenyatko/docker-openvpn-client](https://github.com/monstrenyatko/docker-openvpn-client)

Quick Start
===========

TBD

Container is already configured for automatic restart (See `docker-compose.yml`).

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
