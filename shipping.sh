
echo -e "\e[31m Install Maven \e[0m"
yum install maven -y

echo -e "\e[31m Add application user\e[0m"
useradd roboshop

echo -e "\e[31m create app directory\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m  Download application content\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app

echo -e "\e[31m Extract application content \e[0m"
unzip /tmp/shipping.zip


echo -e "\e[31m Download maven depedencies\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[31m copying shipping service\e[0m"
cp /home/centos/Roboshop-shell/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[31m Install my sql\e[0m"
yum install mysql -y

echo -e "\e[31m load schema \e[0m"
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/schema/shipping.sql

echo -e "\e[31m start shipping service\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping