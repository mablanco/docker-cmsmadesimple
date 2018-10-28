# docker-cmsmadesimple

Docker image for CMS Made Simple, an Open Source Content Management System built using PHP and the Smarty Engine, which keeps content, functionality, and templates separated (<https://www.cmsmadesimple.org>).

This image sets up a development environment and relies on Debian Linux, Apache 2 and PHP7.

## How to use this image

This will start a CMS Made Simple instance listening on port 80:

    $ docker run -d -p 80:80 --name cmsmadesimple mablanco/cmsmadesimple

If you'd like persistance, you can create a volume for that purpose:

    $ docker volume create cmsmadesimple_web
    $ docker run -d -p 80:80 --name cmsmadesimple -v cmsmadesimple_web:/var/www/html mablanco/cmsmadesimple

Once the container is running for the first time, navigate to `/cmsms-2.2.8-install.php` to be redirected to the upgrade and install scripts.
