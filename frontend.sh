yum install nginx -y

rm -rf /usr/share/ngix/html/*

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

cd /usr/share/nginx/html
unzip /tmp/frontend.zip

# we need to configure config file

systemctl enable nginx
systemctl restart nginx