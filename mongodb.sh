
echo -e "\e[31m Copying mongo repo to files of repos\e[0m"
cp mongodb.repo etc/yum.repos.d/mongo.repo

echo -e "\e[31mInstalling mongodb\e[0m"
yum install mongodb-org -y


#Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf

echo -e "\e[31m Enabling and restarting nginx\e[0m"
systemctl enable mongod
systemctl restart mongod