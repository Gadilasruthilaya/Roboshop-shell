component=component



echo -e "${color} Install Maven ${no_color}"
yum install maven -y &>>${file_path}

echo -e "${color} Add application user${no_color}"
useradd roboshop &>>${file_path}

echo -e "${color} create app directory${no_color}"
rm -rf /app
mkdir /app &>>${file_path}

echo -e "${color}  Download application content${no_color}"
curl -L -o /tmp/component.zip https://roboshop-artifacts.s3.amazonaws.com/component.zip &>>${file_path}
cd /app

echo -e "${color} Extract application content ${no_color}"
unzip /tmp/component.zip &>>${file_path}


echo -e "${color} Download maven depedencies${no_color}"
mvn clean package &>>${file_path}
mv target/component-1.0.jar component.jar &>>${file_path}

echo -e "${color} copying component service${no_color}"
cp /home/centos/Roboshop-shell/component.service /etc/systemd/system/component.service &>>${file_path}

echo -e "${color} Install my sql${no_color}"
yum install mysql -y &>>${file_path}

echo -e "${color} load schema ${no_color}"
mysql -h mysql-dev.devopspractice.store -uroot -pRoboShop@1 < /app/schema/component.sql &>>${file_path}

echo -e "${color} start component service${no_color}"
systemctl daemon-reload &>>${file_path}
systemctl enable component &>>${file_path}
systemctl restart component &>>${file_path}