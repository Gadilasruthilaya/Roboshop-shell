echo -e "\e[31m configuring nodejs\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[31m Installing nodejs\e[0m"
yum install nodejs -y

echo -e "\e[31m Add application user\e[0m"
useradd roboshop

echo -e "\e[31m Creat application directory\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m Download application content \e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "\e[31m  Extract application Conetent\e[0m"
unzip /tmp/catalogue.zip
cd /app

echo -e "\e[31m Install nodejs dependencies\e[0m"
npm install &>>/tmp/roboshop.log

echo -e "\e[31m setup Systemd service \e[0m"
cp /home/centos/Roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[31m start catalogue service\e[0m"
systemctl daemon-reload  &>>/tmp/roboshop.log
systemctl enable catalogue &>>/tmp/roboshop.log
systemctl start catalogue &>>/tmp/roboshop.log

echo -e "\e[31m copying MongoDB repo file\e[0m"
cp /home/centos/Roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[31m Install MongoDb client \e[0m"
yum install mongodb-org-shell -y

echo -e "\e[31m Load schema\e[0m"
mongo --host mongodb-dev.devopspractice.store:27017 </app/schema/catalogue.js