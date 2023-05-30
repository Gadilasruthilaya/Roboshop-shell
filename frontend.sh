
echo -e "\e[31mInstalling nginx\e[0m"
yum install nginx -y &>>/tmp/roboshop.log

echo -e "\e[31mRemoving default app content of nginx\e[0m"
rm -rf /usr/share/nginx/html/* &>>/tmp/roboshop.log

echo -e "\e[31mDownloading frontend file\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>/tmp/roboshop.log

echo -e "\e[31mUnzip the file of frontend\e[0m"

cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>/tmp/roboshop.log


echo -e "\e[31m configure config file\e[0m"
cp /home/centos/Roboshop-shell/roboshop.conf /etc/default.d/nginx/roboshop.conf

echo -e "\e[31mEnabling and starting the nginx server\e[0m"
systemctl enable nginx &>>/tmp/roboshop.log
systemctl restart nginx &>>/tmp/roboshop.log