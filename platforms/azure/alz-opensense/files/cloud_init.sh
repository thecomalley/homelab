#!/usr/local/bin/bash
sudo -S pkg update
sudo pkg upgrade -y
sed 's/#PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config > /tmp/sshd_config
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config_tmp
sudo mv /tmp/sshd_config /etc/ssh/sshd_config
sudo /etc/rc.d/sshd restart
fetch https://raw.githubusercontent.com/opnsense/update/master/src/bootstrap/opnsense-bootstrap.sh.in
sed 's/reboot/#reboot/' opnsense-bootstrap.sh.in >opnsense-bootstrap.sh.in.tmp
mv opnsense-bootstrap.sh.in.tmp opnsense-bootstrap.sh.in
sed 's/set -e/#set -e/' opnsense-bootstrap.sh.in >opnsense-bootstrap.sh.in.tmp
mv opnsense-bootstrap.sh.in.tmp opnsense-bootstrap.sh.in
sudo chmod +x opnsense-bootstrap.sh.in
sudo sh ~/opnsense-bootstrap.sh.in -y -r 25.1
sudo cp ~/config.xml /usr/local/etc/config.xml
sudo pkg upgrade
sudo pkg install -y bash git py311-setuptools-63.1.0_3
sudo ln -s /usr/local/bin/python3.11 /usr/local/bin/python
git -c http.sslVerify=false clone https://github.com/Azure/WALinuxAgent.git
cd ~/WALinuxAgent/
git checkout v2.13.1.1
sudo python setup.py install --register-service --force
sudo reboot