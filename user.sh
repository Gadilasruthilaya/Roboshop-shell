echo -e "\e[31m configuring nodejs\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo -e "\e[31m Installing nodejs\e[0m"
yum install nodejs -y &>>/tmp/roboshop.log

echo -e "\e[31m Add application user\e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[31m Creat application directory\e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app

echo -e "\e[31m Download application content \e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>/tmp/roboshop.log
cd /app

echo -e "\e[31m  Extract application Content\e[0m"
unzip /tmp/user.zip &>>/tmp/roboshop.log
cd /app &>>/tmp/roboshop.log

echo -e "\e[31m Install nodejs dependencies\e[0m"
npm install &>>/tmp/roboshop.log

echo -e "\e[31m setup Systemd service \e[0m"
cp /home/centos/Roboshop-shell/user.service /etc/systemd/system/user.service &>>/tmp/roboshop.log

echo -e "\e[31m start user service\e[0m"
systemctl daemon-reload  &>>/tmp/roboshop.log
systemctl enable user &>>/tmp/roboshop.log
systemctl start user &>>/tmp/roboshop.log

echo -e "\e[31m copying MongoDB repo file\e[0m"
cp /home/centos/Roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log

echo -e "\e[31m Install MongoDb client \e[0m"
yum install mongodb-org-shell -y &>>/tmp/roboshop.log

echo -e "\e[31m Load schema\e[0m"
mongo --host mongodb-dev.devopspractice.store </app/schema/user.js &>>/tmp/roboshop.log