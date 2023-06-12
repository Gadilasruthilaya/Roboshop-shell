color="\e[31m"
no_color="\e[0m"
file_path="/tmp/roboshop.log"
app_path="/app"


app_presetup(){
  echo -e " ${color} Add application user ${no_color}"
    useradd roboshop &>>${file_path}

    echo -e " ${color} Creat application directory ${no_color}"
    rm -rf $app_path &>>${file_path}
    mkdir $app_path

    echo -e " ${color} Download application content  ${no_color}"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${file_path}
    cd $app_path

    echo -e "${color}  Extract application Conetent ${no_color}"
    cd $app_path &>>${file_path}
    unzip /tmp/${component}.zip &>>${file_path}

}

systemd_setup(){
   echo -e " ${color} setup Systemd service  ${no_color}"
    cp /home/centos/Roboshop-shell/${component}.service /etc/systemd/system/${component}.service &>>${file_path}

    echo -e " ${color} start ${component}service ${no_color}"
    systemctl daemon-reload  &>>${file_path}
    systemctl enable${component}&>>${file_path}
    systemctl start ${component} &>>${file_path}
}

nodejs(){

  echo -e " ${color} configuring nodejs ${no_color}"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${file_path}

  echo -e " ${color} Installing nodejs ${no_color}"
  yum install nodejs -y &>>${file_path}

  app_presetup

  echo -e " ${color} Install nodejs dependencies ${no_color}"
  npm install &>>${file_path}

  systemd_setup

}

mongo_schema_setup(){

  echo -e "${color} copying MongoDB repo file${no_color}"
  cp /home/centos/Roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${file_path}

  echo -e "${color} Install MongoDb client ${no_colo}"
  yum install mongodb-org-shell -y &>>${file_path}

  echo -e "${color} Load schema ${no_color}"
  mongo --host mongodb-dev.devopspractice.store </$app_path/schema/${component}.js &>>${file_path}

}
maven(){
  echo -e "${color} Install Maven ${no_color}"
  yum install maven -y &>>${file_path}

  echo -e "${color} Download maven depedencies${no_color}"
  mvn clean package &>>${file_path}
  mv target/${component}-1.0.jar ${component}.jar &>>${file_path}

  systemd_setup

  mysql_schema_setup

 }

 mysql_schema_setup(){
    echo -e "${color} Install my sql${no_color}"
      yum install mysql -y &>>${file_path}

      echo -e "${color} load schema ${no_color}"
      mysql -h mysql-dev.devopspractice.store -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${file_path}
 }