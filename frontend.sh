source common.sh

echo -e ""${color}" Installing nginx"${no_color}""
yum install nginx -y  &>>$file_path
start_check $?

echo -e ""${color}" Removing default app content of nginx"${no_color}""
rm -rf /usr/share/nginx/html/*  &>>$file_path
start_check $?

echo -e ""${color}" Downloading frontend file"${no_color}""
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$file_path
start_check $?

echo -e ""${color}" Unzip the file of frontend"${no_color}
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>$file_path
start_check $?

echo -e ""${color}"  configure config file"${no_color}""
cp /home/centos/Roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf
start_check $?

echo -e ""${color}" Enabling and starting the nginx server"${no_color}""
systemctl enable nginx &>>$file_path
systemctl restart nginx &>>$file_path
start_check $?