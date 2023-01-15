cd /var/www/html
sudo rm -r magento2
echo "Public Key: 5ca1a03744903052195b60547722eb27  private Key: 49ecc02e687ac219e7e38ff2c097201f"
#sudo cp auth.json  /root/.config/composer/
sudo composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition magento2
cd /var/www/html/magento2
sudo find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
sudo find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
sudo chown -R :www-data .
sudo chmod u+x bin/magento
cd /var/www/html/magento2
sudo php bin/magento setup:install \
--base-url=http://192.168.0.22 \
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
cd 
cd data/sites-available
sudo cp 000-default.conf /etc/apache2/sites-available/
sudo systemctl restart apache2
sudo apache2ctl configtest
sudo systemctl restart apache2
sudo mysql -u magento2 -p'admin1234' -e "use magento2; UPDATE core_config_data SET value='http://192.168.0.22' WHERE path='web/unsecure/base_url';"
cd /var/www/html/magento2/
sudo php bin/magento deploy:mode:set developer
sudo php /var/www/html/magento2/bin/magento cache:flush
sudo chmod -R 777 /var/www/html/magento2/var
sudo chmod -R 777 /var/www/html/magento2/pub/static
sudo chmod -R 777 var pub generated
sudo chmod -R 777 /var/www/html/magento2/generated
sudo chmod -R 777 /var/www/html/magento2/generated/
sudo php bin/magento s:up
sudo php bin/magento s:s:d -f
sudo php bin/magento c:f
sudo php bin/magento module:disable Magento_TwoFactorAuth
sudo cat app/etc/env.php