
echo -e "\e[31m Copying mongo repo to files of repos\e[0m"
cp mongodb.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log

echo -e "\e[31mInstalling mongodb\e[0m"
yum install mongodb-org -y &>>/tmp/roboshop.log


echo -e "\e[31mUpdate listen address\e[0m"

sed -e 's/127.0.0.1/0.0.0.0' /etc/mongo.conf

echo -e "\e[31m Enabling and restarting nginx\e[0m"
systemctl enable mongod &>>/tmp/roboshop.log
systemctl restart mongod &>>/tmp/roboshop.log