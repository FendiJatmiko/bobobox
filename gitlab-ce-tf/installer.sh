#!/bin/bash
sudo apt update -y 
sudo apt install apache2 -y 
sudo systemctl enable apache2
sudo systemctl start apache2
sudo chown -R www-data:www-data /var/www/html/
sudo echo "<h2> MARK 5 ,, This is the first working apache web server with terraform</h2>" > /var/www/html/index.html
