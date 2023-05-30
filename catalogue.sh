
echo -e "\e[31mConfiguring node repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo -e "\e[31m installing nodejs\e[0m"
yum install nodejs -y &>>/tmp/roboshop.log

echo -e "\e[31m adding the application user\e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[31m creating app directory\e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app

echo -e "\e[31m downloading the catalogue content \e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>/tmp/roboshop.log
cd /app
unzip /tmp/catalogue.zip &>>/tmp/roboshop.log

echo -e "\e[31m installing node dependencies \e[0m"
cd /app &>>/tmp/roboshop.log
npm install  &>>/tmp/roboshop.log

echo -e "\e[31m configuring catalogue service file\e[0m"
cp /home/centos/Roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>>/tmp/roboshop.log

echo -e "\e[31m Reloading and starting catalogue application\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable catalogue &>>/tmp/roboshop.log
systemctl start catalogue &>>/tmp/roboshop.log

echo -e "\e[31m adding mongodb repo file\e[0m"
cp /home/centos/Roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log

echo -e "\e[31m Downloading schema\e[0m"
yum install mongodb-org-shell -y &>>/tmp/roboshop.log

mongo --host mongodb-dev.devopspractice.store </app/schema/catalogue.js &>>/tmp/roboshop.log