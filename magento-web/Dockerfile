FROM alexcheng/apache2-php5:5.6.33

RUN a2enmod rewrite

RUN apt-get update && \
    apt-get install -y mysql-client-5.7 libxml2-dev libmcrypt4 libmcrypt-dev libpng-dev libjpeg-dev libfreetype6 libfreetype6-dev
RUN docker-php-ext-install soap
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install mcrypt
RUN docker-php-ext-configure gd --with-jpeg-dir=/usr/lib/ --with-freetype-dir=/usr/lib/ && \
    docker-php-ext-install gd

RUN bash -c 'bash < <(curl -s -L https://raw.github.com/colinmollenhour/modman/master/modman-installer)'
RUN mv ~/bin/modman /usr/local/bin

COPY bin/install-magento /usr/local/bin/install-magento
COPY sampledata/magento-sample-data-1.9.1.0.tgz /opt/
COPY bin/install-sampledata-1.9 /usr/local/bin/install-sampledata

RUN chmod +x /usr/local/bin/install-magento
RUN chmod +x /usr/local/bin/install-sampledata

WORKDIR /var/www/html

#COPY redis.conf /var/www/htdocs/app/etc/