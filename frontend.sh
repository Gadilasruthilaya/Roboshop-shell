
echo -e "\e[31m Installing nginx\e[0m"
yum install nginx -y

echo -e "\e[31m Removing default app content of nginx\e[0m"
rm -rf /usr/share/ngix/html/*

echo -e "\e[31m Downloading frontend file\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[31m unzip the file of frontend\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

# we need to configure config file

echo -e "\e[31m Enabling and starting the nginx server\e[0m"
systemctl enable nginx
systemctl restart nginx