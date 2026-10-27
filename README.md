# docker-cmsmadesimple

Docker image for CMS Made Simple, an Open Source Content Management System built using PHP and the Smarty Engine, which keeps content, functionality, and templates separated (<https://www.cmsmadesimple.org>).

This image sets up a **development/testing** environment based on Debian Linux, Apache 2 and PHP 8.3 (with `php.ini-development`, so errors are displayed). It should **NEVER** be used in production.

## How to use this image

CMS Made Simple requires a MySQL (or compatible) database as backend. Create a network so both containers can reach each other by name, then launch a dockerized database (fill in the passwords accordingly):

    docker network create cmsms
    docker run -d --name mysqlcms --network cmsms -e MYSQL_ROOT_PASSWORD=<root_password> -e MYSQL_DATABASE=cmsmadesimpledb -e MYSQL_USER=cmsmadesimple -e MYSQL_PASSWORD=<user_password> mysql:9

Then start a CMS Made Simple instance listening on port 80:

    docker run -d -p 80:80 --name cmsmadesimple --network cmsms mablanco/cmsmadesimple

If you'd like website persistance, create a volume for that purpose:

    docker volume create cmsmadesimple_web
    docker run -d -p 80:80 --name cmsmadesimple --network cmsms -v cmsmadesimple_web:/var/www/html mablanco/cmsmadesimple

Once the container is running for the first time, navigate to `http://localhost/cmsms-<version>-install.php` to open the installation assistant. When setting up the database connection use `mysqlcms` as the database hostname and the values provided in the environment variables for the MySQL container.

CMS Made Simple stores its own URL during the installation, so publish the container on port 80 (or use the same host and port you will browse it with), otherwise the admin console will redirect to the wrong address.

## Upgrading from 2.2.22

Images up to `2.2.22` ship CMS Made Simple 2.2.22. A persistent volume keeps the files of the version it was created with, so switching to a newer image tag does not upgrade an existing site. Back up the volume and the database first, then follow the [CMS Made Simple upgrade guide](https://docs.cmsmadesimple.org/upgrading).

## Building the image

    docker build -t mablanco/cmsmadesimple .

The CMS Made Simple version is set with the `CMSMADESIMPLE_VERSION` build argument. Its download folder on the CMSMS file server (`DOWNLOAD_SUBFOLDER`) and the SHA-256 of the installer zip (`CMSMADESIMPLE_SHA256`) change with every release, so update the three together.
