# docker-cmsmadesimple

Docker image for CMS Made Simple, an Open Source Content Management System built using PHP and the Smarty Engine, which keeps content, functionality, and templates separated (<https://www.cmsmadesimple.org>).

This image sets up a development/testing environment based on Debian Linux, Apache 2 and PHP 8.

## How to use this image

CMS Made Simple requires a MySQL (or compatible) database as backend. You can launch a dockerized one using the following command (fill in the passwords accordingly):

    docker run --name mysqlcms -e MYSQL_ROOT_PASSWORD=<root_password> -e MYSQL_DATABASE=cmsmadesimpledb -e MYSQL_USER=cmsmadesimple -e MYSQL_PASSWORD=<user_password> -d mysql:9

Then start a CMS Made Simple instance listening on port 80:

    docker run -d -p 80:80 --name cmsmadesimple --link mysqlcms:mysql mablanco/cmsmadesimple

If you'd like website persistance, create a volume for that purpose:

    docker volume create cmsmadesimple_web
    docker run -d -p 80:80 --name cmsmadesimple --link mysqlcms:mysql -v cmsmadesimple_web:/var/www/html mablanco/cmsmadesimple

Once the container is running for the first time, navigate to `http://localhost/cmsms-<version>-install.php` to open the installation assistant. When setting up the database connection use the values provided in the environment variables for the MySQL container.
