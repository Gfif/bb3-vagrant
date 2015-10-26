#!/bin/bash

echo "Provisioning virtual machine..."

DBNAME=blackbox3
DBUSER=blackbox3
DBPSWD=blackbox3

apt-get update
apt-get install -y python2.7 python-pip git redis-server postgresql libpq-dev python2.7-dev
pip install virtualenv

# git clone https://github.com/stefantsov/blackbox3.github

cd /vagrant/blackbox3

virtualenv /vagrant/bb3-env
source /vagrant/bb3-env/bin/activate
pip install -r requirements.txt

wget -P /tmp/ https://nodejs.org/dist/v4.1.2/node-v4.1.2-linux-x64.tar.gz
tar xvzf /tmp/node-v4.1.2-linux-x64.tar.gz -C /tmp
rsync -a /tmp/node-v4.1.2-linux-x64/* /vagrant/bb3-env

/vagrant/bb3-env/bin/npm install -g less yuglify
cp settings/local_example.py settings/local.py
sed -i.bak "s/'NAME': 'slr1'/'NAME': '$DBNAME'/g" settings/local.py
sed -i.bak "s/'USER': 'slr1'/'USER': '$DBUSER'/g" settings/local.py
sed -i.bak "s/'PASSWORD': 'XXX'/'PASSWORD': '$DBPSWD'/g" settings/local.py
rm settings/local.py.bak

sudo -u postgres createuser -D -E -R -S -w $DBUSER
sudo -u postgres createdb -E utf8 -T template0 --locale=en_US.utf8 -O $DBUSER $DBNAME
sudo -u postgres psql -c "ALTER USER $DBUSER WITH PASSWORD '$DBPSWD';"

python manage.py migrate
echo "Game.objects.create()" | python manage.py shell_plus

chown -R vagrant:vagrant /vagrant
