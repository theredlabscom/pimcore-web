# theredlabs/pimcore-web docker image

This is a docker image based on PHP-7.3:apache2 that includes all major dependencies for PHP to run Pimcore.

This docker images doesn't include any Pimcore compatible database engine, which means that you've got to have a separate container running either MariaDB, Mysql or PerconaDB and that they are on the same docker network.

## Known Issues

* You have to increase the amount of available RAM to your container to at least 4GB.
* It is also recommended that you have at least 2 CPU cores available for this container.

## How to use

To use it, simply create a container based on theredlabs/pimcore-web and map the *pimcore root folder* to the container's `/pimcore` directory.

    docker run -d -name my-pimcore-container -v <pimcore_root_folder>:/pimcore:delegated -p 80:80 theredlabs/pimcore-web

Where `<pimcore_root_folder>` is the path to your pimcore project.

Because of filesystem performance it is important that you add the `:delegated` parameter.

## Common tasks

*Install pimcore's PHP dependencies*: To install the dependencies via composer, you can run:

    docker exec -it -u www-data my-pimcore-container composer install

*Running the Installation Script*: This can be achieved by running from your terminal:

    docker exec -it -u www-data my-pimcore-container vendor/bin/pimcore-install

*Rebuilding Pimcore Classes*: You can rebuild the pimcore classes at any point running:

    docker exec -u www-data my-pimcore-container bin/console pimcore:deployment:classes-rebuild -c

## Installed Extensions

* mysqli
* pdo
* pdo_mysql
* zip
* bz2
* intl
* soap
* bcmath
* opcache
* exif
* xsl
* gd
* imap
* redis
* xdebug
* mcrypt
* imagick

## Extra software available

* wkhtml2pdf
* imagick
* graphviz
* ffpmeg
* JRE
* libreoffice
* g++
