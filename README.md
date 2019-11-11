# Pimcore-web docker image

This is a docker image based on PHP-7.3:apache2 that includes all major dependencies for PHP to run Pimcore.

## How to use

To use it, simply create a container based on theredlabs/pimcore-web and map the *pimcore root folder* to the container's `/pimcore` directory.

    docker run -name my-pimcore-container -v pimcore:/pimcore -p 80:80 theredlabs/pimcore-web

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
