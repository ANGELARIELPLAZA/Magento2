sudo apt -y update
sudo apt -y install software-properties-common
sudo add-apt-repository --yes ppa:ondrej/php
sudo apt -y update
sudo apt -y install php7.4
sudo apt -y install  php7.4-cli php7.4-json php7.4-common php7.4-mysql php7.4-zip php7.4-gd php7.4-mbstring php7.4-curl php7.4-xml php7.4-bcmath  php7.4-intl php7.4-soap php7.4-zip php7.4-gd php7.4-json php7.4-curl php7.4-cli php7.4-xml php7.4-xmlrpc php7.4-gmp php7.4-common
php -v
cd data
sudo cp dir.conf /etc/apache2/mods-enabled/
cd ..
sudo phpenmod mbstring
sudo a2enmod rewrite
sudo systemctl reload apache2