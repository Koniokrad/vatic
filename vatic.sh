#https://gitlab.com/EAVISE/publicwiki/wikis/install-vatic

sudo apt-get install -y git python-setuptools python-dev libfreetype6 libfreetype6-dev apache2 libapache2-mod-wsgi mysql-server-5.7 mysql-client-5.7 libmysqlclient-dev

sudo easy_install -U cython==0.20
sudo easy_install -U SQLAlchemy wsgilog  mysql-python munkres parsedatetime argparse
sudo easy_install -U numpy
sudo add-apt-repository ppa:jonathonf/ffmpeg-3
sudo apt-get update
sudo apt-get install ffmpeg

cd ~/Desktop
mkdir vatic
cd vatic

git clone https://github.com/cvondrick/turkic.git
git clone https://github.com/cvondrick/pyvision.git
git clone https://github.com/cvondrick/vatic.git

cd turkic
sudo python setup.py install
cd ..

cd pyvision
sudo python setup.py install
cd ..

sudo cp /etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf.backup

#change path in 000-default.conf 
sudo nano /etc/apache2/sites-enabled/000-default.conf

#change all data from 000-default.conf to below, make sure paths are correct

#    WSGIDaemonProcess www-data
#   WSGIProcessGroup www-data

#    <VirtualHost *:80>
#        ServerName localhost
#        DocumentRoot /home/administrator/Desktop/vatic/vatic/public

#        WSGIScriptAlias /server /home/administrator/Desktop/vatic/vatic/server.py
#        CustomLog /var/log/apache2/access.log combined
#    </VirtualHost>

#change path in apache2.conf
sudo nano /etc/apache2/apache2.conf

#copy all lines below into apache2.conf, make sure paths are correct and tabs are equal to other (see in nano editor)

#<Directory /home/administrator/Desktop/vatic/vatic/>
#        Options Indexes FollowSymLinks
#        AllowOverride None
#        Require all granted
#</Directory>

sudo cp /etc/apache2/mods-available/headers.load /etc/apache2/mods-enabled
sudo apache2ctl graceful

printf "\n----------------------\n\n"
echo "Login into DB"

mysql -u root -p <<EOF
create database vatic;
EOF

#update vatic/vatic/config.py file with mysql pass

#In the vatic/vatic directory:
cd vatic/
cp config.py-example config.py
sudo nano config.py
sudo apt-get install python-imaging

turkic setup --database
turkic setup --public-symlink

printf "\n----------------------\n\n"
turkic status --verify
printf "\n----------------------\n\n"

sudo usermod -a -G $USER www-data
sudo mkdir /var/www/.python-eggs/
sudo chown www-data:www-data /var/www/.python-eggs/
sudo apache2ctl graceful

printf "\n-------------------------------\n\n"
echo "          Vatic installed            "
printf "\n-------------------------------\n\n"





