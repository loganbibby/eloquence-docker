# Eloquence Docker image

A Docker image for running the [Eloquence database](https://eloquence.marxmeier.com/) as a Docker container. 

_Note: I am not affiliated with or endorsed by Eloquence or Marxmeier Software AG._

## Usage

**Using Docker Compose (recommended)**

```
services:
    eloquence:
        image: ghcr.io/loganbibby/eloquence-docker:latest
        restart: unless-stopped
        ports:
            - 8102:8102
        volumes:
            - /path/to/eloquence/data:/var/lib/eloquence/data
```

**Using Docker CLI**

```
docker run \
    --name=eloquence \
    -p 8102:8102 \
    -v /path/to/eloquence/data:/var/lib/eloquence/data \
    --restart=unless-stopped \
    ghcr.io/loganbibby/eloquence-docker:latest
```

## Evironment Variables

* `ELOQ_VERSION`: Version ID for Eloquence (defaults to `8.3`)
* `ELOQ_PACKAGE`: Name of the Eloquence package (defaults to `b0830`)
* `ELOQ_DIR`: Primary directory for Eloquence data (defaults to `/var/lib/eloquence`)
* `ELOQ_DATA_DIR`: Directory for Eloquence database data (defaults to `$ELOQ_DIR/data`)
* `ELOQ_CFG`: Location of the configuration file (defaults to `$ELOQ_DIR/eloqdb.cfg`)

## Custom configuration file

You can specify a custom configuration file using a bind mount volume:
```
docker run \
    --name=eloquence \
    -p 8102:8102 \
    -v /path/to/eloquence/data:/var/lib/eloquence/data \
    -v /path/to/custom/eloqdb.cfg:/var/lib/eloquence/eloqdb.cfg \
    --restart=unless-stopped \
    ghcr.io/loganbibby/eloquence-docker:latest
```

If the file specified in `ELOQ_CFG` is not blank, `00-create-cfg-file.sh` will not be ran. 

## Versions

* **1.0.0**: Initial release