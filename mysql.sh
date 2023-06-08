
echo -e "\e[31m Disable my sql module\e[0m"
yum module disable mysql -y &>>/tmp/roboshop.log

echo -e "\e[31m copy mysql repo file\e[0m"
cp /home/centos/Roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[31m  Install mysql community server\e[0m"
yum install mysql-community-server -y &>>/tmp/roboshop.log

echo -e "\e[31m start mysql server\e[0m"
systemctl enable mysqld &>>/tmp/roboshop.log
systemctl start mysqld &>>/tmp/roboshop.log

echo -e "\e[31m setup Mysql password\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1 &>>/tmp/roboshop.log