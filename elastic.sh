sudo apt -y install openjdk-11-jdk
java -version
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic.gpg
echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt -y update
sudo apt -y install elasticsearch
sudo a2enmod proxy && sudo a2enmod proxy_http && sudo service apache2 restart
sudo systemctl restart apache2
cd data
sudo cp ports.conf  /etc/apache2/
sudo cp 000-default.conf /etc/apache2/sites-available/
cd ..
sudo a2ensite 000-default.conf
sudo service apache2 restart
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch
curl -i http://localhost:8080/_cluster/health
curl -X GET "localhost:9200"
