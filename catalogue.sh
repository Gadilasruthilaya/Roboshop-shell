
echo -e "\e[31mConfiguring node repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[31m installing nodejs\e[0m"
yum install nodejs -y

echo -e "\e[31m adding the application user\e[0m"
useradd roboshop
mkdir /app

echo -e "\e[31m downloading the catalogue content \e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip

echo -e "\e[31m installing node dependencies \e[0m"
cd /app
npm install

echo -e "\e[31m configuring catalogue service file\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[31m Reloading and starting catalogue application\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue

echo -e "\e[31m adding mongodb repo file\e[0m"
cp mongodb.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[31m Downloading schema\e[0m"
yum install mongodb-org-shell -y

mongo --host mongodb-dev.devopspractice.store </app/schema/catalogue.js