
echo -e "\e[31m Install python \e[0m"
yum install python36 gcc python3-devel -y &>>/tmp/roboshop.log

echo -e "\e[31m Adding application user\e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[31m create app directory\e[0m"
rm -rf /app
mkdir /app &>>/tmp/roboshop.log

echo -e "\e[31m Download application content \e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip &>>/tmp/roboshop.log

echo -e "\e[31m extract application content \e[0m"
cd /app
unzip /tmp/payment.zip &>>/tmp/roboshop.log

echo -e "\e[31m Install python dependencies\e[0m"
cd /app
pip3.6 install -r requirements.txt &>>/tmp/roboshop.log

echo -e "\e[31m copying payment service\e[0m"
cp /home/centos/Roboshop-shell/payment.service /etc/systemd/system/payment.service &>>/tmp/roboshop.log

echo -e "\e[31m enable and start payment \e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable payment &>>/tmp/roboshop.log
systemctl start payment &>>/tmp/roboshop.log