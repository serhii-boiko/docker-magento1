# Docker image for Magento 1.x
This repo creates a Docker image for [Magento 1.x](http://magento.com/).

#### Please note

> The primary goal of this repo is to create Docker images for Magento 1.x development and testing, especially for extensions and themes development. It lacks essential support for production deployment, e.g. Varnish and Redis. Use this wisely for production deployment.

## Magento versions

Version - 1.9.3.8

## How to use

```bash
make build
make up
```

## Magento sample data

Installation script for Magento sample data is also provided.

__Please note:__ Sample data must be installed __before__ Magento itself.

```bash
make sampledata
```

Magento 1.9 sample data is compressed version from [Vinai/compressed-magento-sample-data](https://github.com/Vinai/compressed-magento-sample-data)

## Magento installation script

This script can install Magento without using web UI. This script requires certain environment variables to run:

Environment variable      | Description | Default value (used by Docker Compose - `build.env` file)
--------------------      | ----------- | ---------------------------
MYSQL_HOST                | MySQL host  | mysql
MYSQL_DATABASE            | MySQL db name for Magento | magento
MYSQL_USER                | MySQL username | magento
MYSQL_PASSWORD            | MySQL password | magento
MAGENTO_LOCALE            | Magento locale | en_GB
MAGENTO_TIMEZONE          | Magento timezone |Pacific/Auckland
MAGENTO_DEFAULT_CURRENCY  | Magento default currency | NZD
MAGENTO_URL               | Magento base url | http://local.magento
MAGENTO_ADMIN_FIRSTNAME   | Magento admin firstname | Admin
MAGENTO_ADMIN_LASTNAME    | Magento admin lastname | MyStore
MAGENTO_ADMIN_EMAIL       | Magento admin email | admin@example.com
MAGENTO_ADMIN_USERNAME    | Magento admin username | admin
MAGENTO_ADMIN_PASSWORD    | Magento admin password | magentorocks1


```bash
make install
```

If Docker Compose is used, you can just modify `build.env` file in the same directory of `docker-compose.yml` file to update those environment variables.

After calling `make install`, Magento is installed and ready to use. Use provided admin username and password to log into Magento backend.

If you use default base url (http://local.magento) or other test url, you need to [modify your host file](http://www.howtogeek.com/howto/27350/beginner-geek-how-to-edit-your-hosts-file/) to map the host name to docker container.

**Important**: If you do not use the default `MAGENTO_URL` you must use a hostname that contains a dot within it (e.g `foo.bar`), otherwise the [Magento admin panel login won't work](http://magento.stackexchange.com/a/7773).

### Stop and destroy

1. Run `make down` to stop all of the containers.
1. Run `make destroy` to remove all generated data - docker containers, volumes, networks. `./db-data` and `./magento` directories will be removed too.

### Run magento commands

Run `make login` to login inside magento-web container.

### Aditional commands

1. Run `make mysql` to open mysql console on magento DB.
1. Run `make down` to stop and `make up` to start all builded containers. Short analog of `docker-compose up/down`
1. Run `make ps` to show all the containers status. Short analog of `docker-compose ps`.
