echo "install the apache2 package."
sudo apt -y install apache2
echo "check the installed Apache version"
sudo apache2ctl -v
echo "Apache Full"
sudo ufw allow 'Apache Full'
echo "Check the results"
sudo ufw status
echo "Apache Web Server"
echo "sudo systemctl status apache2"
echo "Use your browser access by link: 	http://your_server_ip"
echo "Setting Up Virtual Hosts for Website Domain"
cd  data/servername
echo "First, we need to create a directory containing the code. For example, it is possible to create a directory in /var/www/your-domain with the command below:"
sudo mkdir -p /var/www/html/magento2
echo "You can then upload the source code to this directory via FTP or SFTP."
sudo cp index.html  /var/www/html/magento2/index.html
echo "And copy the content below into magento2.conf file:"
sudo cp 000-default.conf /etc/apache2/sites-available/
sudo echo "ServerName 127.0.1.1" >>/etc/apache2/apache2.conf
cd ..
cd ..
echo"Then execute the command below to activate the virtual host just configured."
sudo a2ensite 000-default.conf
echo "Test for configuration errors."
sudo apache2ctl configtest
echo "Finally, Restart apache to make the changes."
sudo systemctl restart apache2
echo "reload apache2"
sudo systemctl reload apache2
