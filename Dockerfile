FROM debian:buster

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y nginx mariadb-server php php-fpm php-mysql wget unzip curl && \
    apt-get install -y php-cli php-mbstring php-zip php-gd php-json php-curl php-xml && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzvf latest.tar.gz && \
    mv wordpress /var/www/html/wordpress && \
    chown -R www-data:www-data /var/www/html/wordpress && \
    chmod -R 755 /var/www/html/wordpress && \
    rm latest.tar.gz

RUN wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz && \
    tar -xzvf phpMyAdmin-latest-all-languages.tar.gz && \
    mv phpMyAdmin-*-all-languages /var/www/html/phpmyadmin && \
    chown -R www-data:www-data /var/www/html/phpmyadmin && \
    chmod -R 755 /var/www/html/phpmyadmin && \
    rm phpMyAdmin-latest-all-languages.tar.gz

COPY nginx.conf /etc/nginx/sites-available/default

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx-selfsigned.key \
    -out /etc/nginx/ssl/nginx-selfsigned.crt \
    -subj "/CN=localhost"

COPY start.sh /start.sh
RUN chmod +x /start.sh


EXPOSE 80 443


CMD ["/start.sh"]
