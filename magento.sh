# !/bin/bash
# Programa para instalar  apache
#sudo apt -y update
#sudo apt -y upgrade
 sudo apt -y install shfmt
#sudo rm /var/lib/dpkg/lock
#sudo rm /var/lib/apt/lists/lock
#sudo rm /var/cache/apt/archives/lock
#Public Key: 5ca1a03744903052195b60547722eb27
#Private Key: 49ecc02e687ac219e7e38ff2c097201f

echo "Hola bienvenido a la instalacion de magento2.4"
read -p "Deseas continuar:[y/n]" option
if  [ $option = "y" ] ; then
    echo "***************APACHE**********************"
    sudo apt -y install apache2
    echo " version instalada: "
    sudo apache2ctl -v
    echo " Vamos a verificar el cortafuegos con los siguientes comandos, uno por uno: "
    sudo ufw app list
    sudo ufw allow 'Apache'
    sudo ufw status
    echo " Vamos a verificar el servidor apache con los siguientes comandos: "
    sudo systemctl start apache2
    sudo systemctl status --no-pager apache2
    sudo systemctl enable apache2
    echo " Vamos a configurar nuestro Host Virtual, esto para asignarle un dominio, con los siguientes
    comandos, tomaremos como nombre “magento2”: "
    if [ -d /var/www/html/magento2 ];
    then
        echo "Sí, sí existe /var/www/html/magento2."
        if [ -f /var/www/html/magento2/index.html ];
        then
            echo "Sí, sí existe /var/www/html/magento2/index.html."
        else
            echo "No, no existe /var/www/html/magento2/index.html - se acaba de crear"
            sudo touch chmod +x /var/www/html/magento2/index.html
        fi
    else
        echo "No, no existe /var/www/html/magento2 - se acaba de crear"
        sudo mkdir +x /var/www/html/magento2
    fi
    sudo rm /etc/apache2/sites-available/000-default.conf 
    sudo touch /etc/apache2/sites-available/000-default.conf
    sudo chmod +x /etc/apache2/sites-available/000-default.conf
    sudo echo -e "
    <VirtualHost *:80>
        ServerAdmin webmaster@localhost
        ServerName magento2
        ServerAlias www.magento2
        DocumentRoot /var/www/html/magento2
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
    </VirtualHost>
    " >>/etc/apache2/sites-available/000-default.conf
    cat /etc/apache2/sites-available/000-default.conf
    sudo echo "ServerName 127.0.1.1" >>  /etc/apache2/apache2.conf
    sudo a2ensite 000-default.conf
    sudo apache2ctl configtest
    sudo systemctl restart apache2
    echo "***************MYSQL**********************"
    sudo apt  -y install mysql-server
    mysql -u root -p'admin1234' -e "CREATE USER magento2@localhost IDENTIFIED BY 'admin1234'; ALTER USER 'magento2'@'localhost' IDENTIFIED WITH mysql_native_password BY 'admin1234'; GRANT ALL PRIVILEGES ON *.* TO 'magento2'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;"
    mysql -u magento2 -p'admin1234' -e "CREATE DATABASE magento2;"
    sudo apt -y update
    sudo apt -y install software-properties-common
    sudo add-apt-repository --yes ppa:ondrej/php
    sudo apt -y update
    sudo apt -y install php7.4
    sudo apt -y install  php7.4-cli php7.4-json php7.4-common php7.4-mysql php7.4-zip php7.4-gd php7.4-mbstring php7.4-curl php7.4-xml php7.4-bcmath
    php -v
    sudo rm /etc/apache2/mods-enabled/dir.conf
    sudo touch /etc/apache2/mods-enabled/dir.conf
    sudo chmod +x /etc/apache2/mods-enabled/dir.conf
    sudo echo -e "
    <IfModule mod_dir.c>
    DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
    </IfModule>
    # vim: syntax=apache ts=4 sw=4 sts=4 sr noet
    " >>/etc/apache2/mods-enabled/dir.conf
    sudo a2enmod rewrite
    sudo apt -y install  php7.4-bcmath php7.4-intl php7.4-soap php7.4-zip php7.4-gd php7.4-json php7.4-curl php7.4-cli php7.4-xml php7.4-xmlrpc php7.4-gmp php7.4-common
    sudo systemctl reload apache2
    sudo systemctl start apache2
    sudo systemctl status --no-pager apache2
    sudo systemctl enable apache2
    echo "***************Elasticsearch**********************"
    sudo apt -y install  openjdk-11-jdk
    java -version
    sudo curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
    sudo echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
    sudo apt update
    sudo apt -y install  elasticsearch=7.9.3
    sudo a2enmod proxy && sudo a2enmod proxy_http && sudo service apache2 restart
    sudo rm /etc/apache2/ports.conf
    sudo touch /etc/apache2/ports.conf
    sudo chmod +x /etc/apache2/ports.conf
    sudo echo -e "
    # If you just change the port or add more ports here, you will likely also
    # have to change the VirtualHost statement in
    # /etc/apache2/sites-enabled/000-default.conf
    Listen 80
    Listen 8080
    <IfModule ssl_module>
        Listen 443
    </IfModule>
    <IfModule mod_gnutls.c>
        Listen 443
    </IfModule>
    # vim: syntax=apache ts=4 sw=4 sts=4 sr noet
    " >>/etc/apache2/ports.conf
    sudo echo '<VirtualHost *:8080>
    ProxyPass "/" "http://localhost:9200/"
    ProxyPassReverse "/" "http://localhost:9200/"
    </VirtualHost> ' >>   /etc/apache2/sites-available/000-default.conf
    sudo a2ensite 000-default.conf
    sudo service apache2 restart
    sudo systemctl start elasticsearch
    sudo systemctl enable elasticsearch
    curl -i http://localhost:8080/_cluster/health
    curl -X GET "localhost:9200"
    echo "***************Composer**********************"
    sudo curl -sS https://getcomposer.org/installer -o composer-setup.php
    sudo php composer-setup.php --install-dir=/usr/bin --filename=composer -y
    composer
    echo "***************Magento**********************"
    cd /var/www/html
    sudo rm -r magento2
    sudo composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition magento2
    cd /var/www/html/magento2
    sudo find /var/www/html/magento2/var /var/www/html/magento2/generated /var/www/html/magento2/vendor /var/www/html/magento2/pub/static /var/www/html/magento2/pub/media  /var/www/html/magento2/app/etc -type f -exec chmod g+w {} +
    sudo find /var/www/html/magento2/var /var/www/html/magento2/generated /var/www/html/magento2/vendor /var/www/html/magento2/pub/static /var/www/html/magento2/pub/media  /var/www/html/magento2/app/etc -type d -exec chmod g+ws {} +
    sudo chown -R :www-data .
    sudo chmod u+x /var/www/html/magento2/bin/magento
    cd /var/www/html/magento2
    sudo php bin/magento setup:install \
    --base-url=http://192.168.0.37 \
    --db-host=localhost \
    --db-name=magento2 \
    --db-user=magento2 \
    --db-password=admin1234 \
    --admin-firstname=Admin \
    --admin-lastname=Admin \
    --admin-email=admin@admin.com \
    --admin-user=admin \
    --admin-password=admin1234 \
    --language=en_US \
    --currency=USD \
    --timezone=America/Chicago \
    --use-rewrites=1 \
    --search-engine=elasticsearch7 \
    --elasticsearch-host=localhost \
    --elasticsearch-port=8080
    sudo rm /etc/apache2/sites-available/000-default.conf
    sudo touch /etc/apache2/sites-available/000-default.conf
    sudo chmod +x /etc/apache2/sites-available/000-default.conf
    sudo echo -e "
    <VirtualHost *:80>
        ServerAdmin webmaster@localhost
        ServerName magento2
        ServerAlias www.magento2
        DocumentRoot /var/www/html/magento2/pub
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
        <Directory "/var/www/html/magento2">
                    AllowOverride all
        </Directory>
    </VirtualHost>
    " >>/etc/apache2/sites-available/000-default.conf
    cat /etc/apache2/sites-available/000-default.conf
    sudo a2ensite 000-default.conf
    sudo apache2ctl configtest
    sudo systemctl restart apache2
    sudo mysql -u magento2 -p'admin1234' -e "use magento2; UPDATE core_config_data SET value='http://192.168.0.37' WHERE path='web/unsecure/base_url';"
    sudo php /var/www/html/magento2/bin/magento deploy:mode:set developer
    sudo php /var/www/html/magento2/bin/magento cache:flush
    sudo chmod -R 777 /var/www/html/magento2/var
    sudo chmod -R 777 /var/www/html/magento2/pub/static
    sudo chmod -R 777 /var/www/html/magento2/generated
    sudo chmod -R 777 /var/www/html/magento2/generated/
    sudo  php /var/www/html/magento2/bin/magento s:up
    sudo  php /var/www/html/magento2/bin/magento s:s:d -f
    sudo  php /var/www/html/magento2/bin/magento c:f
    sudo php /var/www/html/magento2/bin/magento module:disable Magento_TwoFactorAuth
    sudo cat /var/www/html/magento2/app/etc/env.php
else
    exit
fi
