echo "***************MYSQL**********************"
sudo apt  -y install mysql-server
mysql -u root -p'admin1234' -e "CREATE USER magento2@localhost IDENTIFIED BY 'admin1234'; ALTER USER 'magento2'@'localhost' IDENTIFIED WITH mysql_native_password BY 'admin1234'; GRANT ALL PRIVILEGES ON *.* TO 'magento2'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;"
mysql -u magento2 -p'admin1234' -e "CREATE DATABASE magento2;"