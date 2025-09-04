# [Pimsync](https://pimsync.whynothugo.nl/ "Official Documentation")-DOCKERIZED
[![GitHub Release](https://img.shields.io/github/v/release/Bleala/Pimsync-DOCKERIZED?style=flat&label=Version)](https://github.com/Bleala/Pimsync-DOCKERIZED/releases)
[![Docker Stars](https://img.shields.io/docker/stars/bleala/pimsync?style=flat&label=Docker%20Stars)](https://hub.docker.com/r/bleala/pimsync)
[![Docker Pulls](https://img.shields.io/docker/pulls/bleala/pimsync?style=flat&label=Docker%20Pulls)](https://hub.docker.com/r/bleala/pimsync)
[![Container Build Check 🐳✅](https://github.com/Bleala/Pimsync-DOCKERIZED/actions/workflows/container-build-check.yaml/badge.svg)](https://github.com/Bleala/Pimsync-DOCKERIZED/actions/workflows/container-build-check.yaml)

Pimsync - a command line tool to synchronise calendars and contacts between different storages, including CalDAV and CardDAV. Pimsync is a successor and reimplementation of Vdirsyncer, and is free and open source software. DOCKERIZED! 

---

## About Pimsync
**Disclaimer:** I am just the maintainer of this docker container, I did not write the software. Visit the [Official Pimsync Website](https://pimsync.whynothugo.nl/ "Official Pimsync Website") or the [Official Sourcehut Repository](https://git.sr.ht/~whynothugo/pimsync "Pimsync Sourcehut Repository") to thank the author(s)! :)

Pimsync is a command line tool to synchronise calendars and contacts between different storages, including CalDAV and CardDAV. Pimsync is a successor and reimplementation of Vdirsyncer, and is free and open source software.

Pimsync synchronises documentation across storages. Currently supported storages are:
* **CalDAV:** HTTP extension which provides read and write access to calendars on servers.
* **CardDAV:** HTTP extension which provides read and write access to address books on servers.
* **Vdir:** Convention for storing calendars and address books in local directories using standardised and well-documented formats.
* **WebCal:** Convention for exposing a calendar or event read-only using HTTP.

Common use cases include:
* Synchronising a CalDAV or CardDAV server with a local directory. Local data can then be accessed and manipulated by a variety of programs, none of which have to know or worry about synchronisation, network connectivity, or remote servers. The changes are then synced back to the server periodically.
* Synchronising from server to a local directory with the intent of keeping back-ups using a tool that backs up local directory trees.
* Synchronising data between two different CalDAV or CardDAV servers.

Pimsync is configured via a configuration file. It can then be used to synchronise data once (via the pimsync sync command) or to keep data synchronised continuously (via the pimsync daemon command).

---

## Links

Official Website: https://pimsync.whynothugo.nl/

Official Sourcehut Repository: https://git.sr.ht/~whynothugo/pimsync

Docs: https://pimsync.whynothugo.nl/

My Github Repository: https://github.com/Bleala/Pimsync-DOCKERIZED

---

## Downloads

Docker Hub: https://hub.docker.com/r/bleala/pimsync

Github Container Registry: https://github.com/-/bleala/packages/container/package/pimsync

Quay.io: https://quay.io/repository/bleala/pimsync

---

## Image, Versions and Architecture

I built this image based on [Alpine Linux](https://hub.docker.com/_/alpine "Alpine Linux Image") and compiled pimsync during the container build.

There will always be a latest image and the semantic versioning images:

| Tag | Content |
| ------------- |:-------------:|
| Latest    | Contains the latest stable version |
| x.x.x     | Contains the Pimsync and Alpine versions mentioned at the bottom of the page and in the release notes | 

I am using semantic versioning for this image. For all supported architectures there are the following versioned tags:

* Latest
* Major (1)
* Minor (1.0)
* Patch (1.0.0)

There are also several platforms supported:

Platforms:
* linux/amd64
* linux/arm64 
* linux/arm/v7

---

## Image Signing & Verification

To ensure the authenticity and integrity of my images, all `bleala/pimsync` images pushed to `Docker Hub`, `GitHub Container Registry` and `Quay.io` (and maybe more in the future) are signed using [Cosign](https://github.com/sigstore/cosign "Cosign").

I use a static key pair for signing. The public key required for verification, `cosign.pub`, is available in the root of this GitHub repository:
* **Public Key:** [`cosign.pub`](https://github.com/Bleala/Pimsync-DOCKERIZED/blob/main/cosign.pub "cosign.pub")

### How to Verify an Image

You can verify the signature of an image to ensure it hasn't been tampered with and originates from me.

1.  **Install Cosign:**
    If you don't have Cosign installed, follow the official installation instructions: [Cosign Installation Guide](https://docs.sigstore.dev/cosign/system_config/installation/ "Cosign Installation Guide").

2.  **Obtain the Public Key:**
    Download the [`cosign.pub`](https://github.com/Bleala/Pimsync-DOCKERIZED/blob/main/cosign.pub "cosign.pub") file from this repository or clone the repository to access it locally.

3.  **Verify the Image:**
    Use the `cosign verify` command. It is highly recommended to verify against the image **digest** (e.g., `sha256:...`) rather than a mutable tag (like `latest` or `1.23.0`). You can find image digests on Docker Hub or GitHub Container Registry.

    ```bash
    # Ensure 'cosign.pub' is in your current directory, or provide the full path to it.
    # Replace <registry>/bleala/pimsync@sha256:<image-digest> with the actual image reference and its digest.

    # Example for an image on Docker Hub:
    cosign verify --key cosign.pub docker.io/bleala/pimsync@sha256:<ACTUAL_IMAGE_DIGEST_HERE>

    # Example for an image on GitHub Container Registry:
    cosign verify --key cosign.pub ghcr.io/bleala/pimsync@sha256:<ACTUAL_IMAGE_DIGEST_HERE>
    ```

    For instance, to verify the `dev` tag with the following digest `sha256:bd9b65a3a65425bd4b67de6a61670aa0e551f996ac5f466da8aa603ab9acd005`:
    ```bash
    cosign verify --key cosign.pub docker.io/bleala/pimsync@sha256:bd9b65a3a65425bd4b67de6a61670aa0e551f996ac5f466da8aa603ab9acd005
    ```

    A successful verification will output information like this:

    ```
    cosign verify --key cosign.pub docker.io/bleala/pimsync@sha256:bd9b65a3a65425bd4b67de6a61670aa0e551f996ac5f466da8aa603ab9acd005

    Verification for index.docker.io/bleala/pimsync@sha256:bd9b65a3a65425bd4b67de6a61670aa0e551f996ac5f466da8aa603ab9acd005 --
    The following checks were performed on each of these signatures:
      - The cosign claims were validated
      - Existence of the claims in the transparency log was verified offline
      - The signatures were verified against the specified public key

    [{"critical":{"identity":{"docker-reference":"index.docker.io/bleala/pimsync"},"image":{"docker-manifest-digest":"sha256:bd9b65a3a65425bd4b67de6a61670aa0e551f996ac5f466da8aa603ab9acd005"},"type":"cosign container image signature"},"optional":{"Bundle":{"SignedEntryTimestamp":"MEUCIQDRzntAex381nJLU3DpBVYbpRJB4ikVD27AfxbmQVrrwgIgVExRV2P1jOIZjUjAw6N9cwLOWIDPo1RIK0+qF/zeoUY=","Payload":{"body":"eyJhcGlWZXJzaW9uIjoiMC4wLjEiLCJraW5kIjoiaGFzaGVkcmVrb3JkIiwic3BlYyI6eyJkYXRhIjp7Imhhc2giOnsiYWxnb3JpdGhtIjoic2hhMjU2IiwidmFsdWUiOiIzZTgzNjY5MWM5NzM3NGNhMmExNjllMjUwNTllMjY4MGI4ZjRkODEyZTcyMDliZTAzNjEwMDAwMDI5YTBjZjNlIn19LCJzaWduYXR1cmUiOnsiY29udGVudCI6Ik1FVUNJUUM4WnFrZDIrblB1czVKNUJvQVUweFYyZGxRaW5tSlpubXlUeSt2VXIwSlJnSWdRSFFNZ01lYy9hVk93ODVKMGFXangyblg5MlhmTnJWTWU2VTlMdFpyTzVRPSIsInB1YmxpY0tleSI6eyJjb250ZW50IjoiTFMwdExTMUNSVWRKVGlCUVZVSk1TVU1nUzBWWkxTMHRMUzBLVFVacmQwVjNXVWhMYjFwSmVtb3dRMEZSV1VsTGIxcEplbW93UkVGUlkwUlJaMEZGU0VWWFRFYzVjVVI2VFdGdlJ6TlJTSGxXTUhoVFRVZzNRblF3VGdvMVRVWkRNWEV3VFhabE5DOHZVMmwxZVZWbU5VRnBaRVJZY2s5S1kwaEdSalYxZERWUVMyNVViMUZ6YjNWNWRGVTBXVmhoWlM5bU1UQlJQVDBLTFMwdExTMUZUa1FnVUZWQ1RFbERJRXRGV1MwdExTMHRDZz09In19fX0=","integratedTime":1756893469,"logIndex":463255555,"logID":"c0d23d6ad406973f9559f3ba2d1ca01f84147d8ffc5b8445c224f98b9591801d"}}}}]
    ```

---

## Usage

To start the container you can run the following

```
docker run -d -v /path/to/your/config:/pimsync/pimsync.conf \
        bleala/pimsync:latest
```

But since docker compose is easier to maintain, I'll give you a valid docker compose example.


```docker-compose.yml
networks:
  pimsync:
    driver: bridge

volumes:
  pimsync:
    name: pimsync
    driver: local

services:
  # Pimsync - a command line tool to synchronise calendars and contacts between different storages, including CalDAV and CardDAV. 
  # Pimsync is a successor and reimplementation of Vdirsyncer, and is free and open source software. DOCKERIZED!
  # https://hub.docker.com/r/bleala/pimsync
  # https://github.com/Bleala/Pimsync-DOCKERIZED
  pimsync:
    image: bleala/pimsync:latest
    container_name: pimsync
    hostname: pimsync
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    environment:
      # Optional: set your timezone, for correct container and log time, default to `Europe/Vienna`
      TZ: Europe/Vienna
      # Optional: set the container mode, `auto` will run the PIMSYNC_COMMAND, `manual` will only run the container, so you can exec into it and run your commands manually, default to auto
      CONTAINER_MODE: auto
      # Optional: set the Pimsync command, default to `daemon`, can be extended with flags, e.g. "sync -n" or "daemon -r"
      PIMSYNC_COMMAND: daemon
      # Optional: set the Pimsync config path, default to `/pimsync/pimsync.conf`
      PIMSYNC_CONFIG: /pimsync/pimsync.conf
      # Optional: set the Pimsync executable path, default to `/usr/local/bin/pimsync`
      PIMSYNC_EXECUTABLE_PATH: /usr/local/bin/pimsync
      # Optional: set the Pimsync log level, default to `info`, other options are  `trace`, `debug`, `warn` or `error`
      PIMSYNC_LOG_LEVEL: info
    env_file:
      - path: .env
        required: false
    networks:
      pimsync:
    volumes:
      - type: volume
        source: pimsync
        target: /pimsync   
        read_only: true
      - type: bind
        source: /path/to/pimsync.conf
        target: /pimsync/pimsync.conf
        read_only: true
```

You can start the docker-compose.yml with the following command

```
docker compose up -d
```

If you want to see the container logs, you can run

```
docker compose logs -f
```

or

```
docker logs -f pimsync
```

---

## Config

You have to mount a local configuration file inside the container to work properly. [How to config](https://pimsync.whynothugo.nl/pimsync.1.html "Pimsync configuration")

In the `/pimsnyc` folder you will also find the `pimsync.conf.example` which I copied inside the container for a quick reference.<br>
You can also find the `pimsync.conf.example` in this GitHub repository. ([Link](https://github.com/Bleala/Pimsync-DOCKERIZED/blob/main/docker/files/examples/pimsync.conf.example "pimsync.conf.example"))

The configuration file name is `pimsync.conf`. Write everything like it is shown in the docs and in my `pimsync.conf.example`!

**Attention:** It is not recommended to use `CONTAINER_MODE: auto` and `PIMSYNC_COMMAND: daemon` by default, if you have never used `Pimsync` before! If you set it to `auto` and `daemon`, it will automatically start to sync your defined storages, so don't ruin your calender/contacts structure! **Use it only if you know what you are doing! --> DYOR and [READ THE DOCS!](https://pimsync.whynothugo.nl/ "Official Documentation")**

For first time use I recommend running the container with `CONTAINER_MODE: manual`.<br>
Now you can either exec into the container with `docker exec -it pimsync sh` or run the commands directly from your host.

After the container is started and your `pimsync.conf` is mounted, I suggest that you run `docker exec -it pimsync pimsync check` to validate your config file.

Now you can discover your defined pairs with `docker exec -it pimsync pimsync discover`, to check if the connection to your configured storages does work as expected.


After you ran `docker exec -it pimsync pimsync discover` you can either run `docker exec -it pimsync pimsync sync` or, if you have not set `CONTAINER_MODE: auto` and `PIMSYNC_COMMAND: daemon`, set it to `auto`/`daemon` and restart the container with `docker compose restart` or deploy it again with `docker compose up -d`. 

Now it will sync everything for the first time.

For futher collections/pairs you do not have to run `pimsync discover` again. `Pimsync` will do this automatically in `daemon` mode. You should only do it for the first time to unterstand how `Pimsync` does work.

Everything that is done by `Pimsync` will get written to the docker logs! Run `docker logs -f pimsync` or `docker compose logs -f` to watch the logs.

**Attention:** If you would like to use the a local storage, be sure that the folder already exists, otherwise `Pimsync` produces errors!

As you can see in the [pimsync.conf.example](https://github.com/Bleala/Pimsync-DOCKERIZED/blob/main/docker/files/examples/pimsync.conf.example "pimsync.conf.example"), I set `/pimsync/calendars/` as path for the local storage and for the pair `test` as local folder. So to work properly the path/folder `/pimsync/calendars/test` has to exist before you run your first sync!<br>
Either create it with `docker exec -it pimsync "mkdir -p /path/to/your/local/folder"` (in my example this would be `docker exec -it pimsync "mkdir -p /pimsync/calendars/test"`) or if you have mounted a local folder to `/pimsync` create the subfolder and make sure, that it is readable and writable by the `pimsync` user (`UID/GID 1000`)!

---

## User

`Pimsync` does run with an user called `pimsync` inside the container and not as root.

The `UID` and `GID` for this user are `1000` by default, so be careful if you mount your `pimsync.conf`, that it is readable for this user and if you use a bind mount instead of a docker volume.

If you need to set a custom `UID` and `GID`, add the `user` key to your `docker-compose.yml`.

Example:
`user: "your_UID:your_GID"`

<details>
<summary>Complete docker-compose.yml with the `user` key</summary><br>

```docker-compose.yml
networks:
  pimsync:
    driver: bridge

volumes:
  pimsync:
    name: pimsync
    driver: local

services:
  # Pimsync - a command line tool to synchronise calendars and contacts between different storages, including CalDAV and CardDAV. 
  # Pimsync is a successor and reimplementation of Vdirsyncer, and is free and open source software. DOCKERIZED!
  # https://hub.docker.com/r/bleala/pimsync
  # https://github.com/Bleala/Pimsync-DOCKERIZED
  pimsync:
    image: bleala/pimsync:latest
    container_name: pimsync
    hostname: pimsync
    restart: unless-stopped
    user: "your_UID:your_GID"
    security_opt:
      - no-new-privileges:true
    environment:
      # Optional: set your timezone, for correct container and log time, default to `Europe/Vienna`
      TZ: Europe/Vienna
      # Optional: set the container mode, `auto` will run the PIMSYNC_COMMAND, `manual` will only run the container, so you can exec into it and run your commands manually, default to auto
      CONTAINER_MODE: auto
      # Optional: set the Pimsync command for `auto` mode, default to `daemon`, can be extended with flags, e.g. "sync -n" or "daemon -r"
      PIMSYNC_COMMAND: daemon
      # Optional: set the Pimsync config path, default to `/pimsync/pimsync.conf`
      PIMSYNC_CONFIG: /pimsync/pimsync.conf
      # Optional: set the Pimsync executable path, default to `/usr/local/bin/pimsync`
      PIMSYNC_EXECUTABLE_PATH: /usr/local/bin/pimsync
      # Optional: set the Pimsync log level, default to `info`, other options are  `trace`, `debug`, `warn` or `error`
      PIMSYNC_LOG_LEVEL: info
    env_file:
      - path: .env
        required: false
    networks:
      pimsync:
    volumes:
      - type: volume
        source: pimsync
        target: /pimsync   
        read_only: true
      - type: bind
        source: /path/to/pimsync.conf
        target: /pimsync/pimsync.conf
        read_only: true
```

</details>

---

## Environment Variables

You can set a few different environment variables if you want to:

| **Variable** | **Info** | **Value** |
|:----:|:----:|:----:|
|   `TZ`   |   to set the correct container and log time   |   optional, default to `Europe/Vienna`, look [here](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones "Timezones") for possible values  |
|   `CONTAINER_MODE`   |   is used automatically run `pimsync ${PIMSYNC_COMMAND}` or to just start the container for manual `pimsync` commands   |   optional, default to `auto`, can be `manual`   |
|   `PIMSYNC_COMMAND`   |   is used to specify the `Pimsync` command in `auto` mode   |   optional, default to `daemon`, can be [any of these commands](https://pimsync.whynothugo.nl/pimsync.1.html#COMMANDS "Pimsync Commands")    |
|   `PIMSYNC_CONFIG`   |   is used to set the `Pimsync` config file location   |   optional, default to `/pimsync/pimsync.conf`   |
|   `PIMSYNC_EXECUTABLE_PATH`   |   is used to set the `Pimsync` executable path   |   optional, default to `/usr/local/bin/pimsync`, should not be changed!   |
|   `PIMSYNC_LOG_LEVEL`   |   is used to set the `Pimsync` log level   |   optional, default to `info`, can be `trace`, `debug`, `info`, `warn` or `error`   |

---

## Build instructions

Clone this repo and then:

```
cd Pimsync-DOCKERIZED/docker
docker build -t bleala/pimsync:dev .
```

Or you can use the provided [docker-compose.override.yml](https://github.com/Bleala/Pimsync-DOCKERIZED/blob/master/docker/docker-compose.override.yml "docker-compose.override.yml") file:

```
docker compose -f docker-compose.override.yml build
```

For more information on using multiple compose files [see here](https://docs.docker.com/compose/production/). You can also find a prebuilt docker image from [Docker Hub](https://hub.docker.com/r/bleala/pimsync/ "Docker Hub"), which can be pulled with this command:

```
docker pull bleala/pimsync:latest
```

---

## Contribution

I'm glad, if you want to contribute something to the `Pimsync` container.

Feel free to create a PR with your changes and I will merge it, if it's ok.

**Attention**: Please use the `main` branch for pull requests, a CI pipeline is going to run to check, if the container will build!

---

## Versions
**1.0.0 - 04.09.2025:**<br>
* Initial Release!<br>
* Build on Alpine 3.22.1 with Pimsmync Version 0.4.4.<br>
* [Official Documentation](https://pimsync.whynothugo.nl/ "Official Documentation").<br>

**Current Versions:**<br>
* Pimsync 0.4.4, Alpine 3.22.1

<details>
<summary>Old Version History</summary><br>

**1.0.0 - 04.09.2025:**<br>
* Initial Release!<br>
* Build on Alpine 3.22.1 with Pimsmync Version 0.4.4.<br>
* [Official Documentation](https://pimsync.whynothugo.nl/ "Official Documentation").<br>

</details>

---
### Hope you enjoy it! :)
---
