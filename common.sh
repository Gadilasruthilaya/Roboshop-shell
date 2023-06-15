color="\e[31m"
no_color="\e[0m"
file_path="/tmp/roboshop.log"
app_path="/app"
user_id=$(id -u)

if [ $user_id -ne 0 ]; then
  echo script should run as root user
  exit 1

fi
start_check(){
  if [ $1 -eq 0 ]; then
         echo success
       else
         echo failure
       fi
}
app_presetup(){
    echo -e " ${color} Add application user ${no_color}"
    id roboshop &>>${file_path}
    if [ $? -eq 1 ]; then
       useradd roboshop &>>${file_path}
    fi

  start_check $?

    echo -e " ${color} Creat application directory ${no_color}"
    rm -rf $app_path &>>${file_path}
    mkdir $app_path
    start_check $?

    echo -e " ${color} Download application content  ${no_color}"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${file_path}
    cd $app_path
    start_check $?

    echo -e "${color}  Extract application Conetent ${no_color}"
    cd $app_path &>>${file_path}
    unzip /tmp/${component}.zip &>>${file_path}
    start_check $?
}

systemd_setup(){
   echo -e " ${color} setup Systemd service  ${no_color}"
   cp /home/centos/Roboshop-shell/${component}.service /etc/systemd/system/${component}.service &>>${file_path}
   start_check $?

    echo -e " ${color} password  ${no_color}"
    sed -i -e "s/roboshop_app_password/$roboshop_app_password/" /etc/systemd/system/${component}.service &>>${file_path}
    echo $roboshop_app_password
    echo ${component}.service
     start_check $?

    echo -e " ${color} start ${component}service ${no_color}"
    systemctl daemon-reload  &>>${file_path}
    systemctl enable${component}&>>${file_path}
    systemctl start ${component} &>>${file_path}
    start_check $?
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
  start_check $?

  echo -e "${color} Install MongoDb client ${no_colo}"
  yum install mongodb-org-shell -y &>>${file_path}
  start_check $?

  echo -e "${color} Load schema ${no_color}"
  mongo --host mongodb-dev.devopspractice.store </$app_path/schema/${component}.js &>>${file_path}
  start_check $?

}
maven(){
  echo -e "${color} Install Maven ${no_color}"
  yum install maven -y &>>${file_path}
  start_check $?


  echo -e "${color} Download maven depedencies${no_color}"
  mvn clean package &>>${file_path}
  mv target/${component}-1.0.jar ${component}.jar &>>${file_path}
  start_check $?
  app_presetup
  systemd_setup

  mysql_schema_setup

 }

 mysql_schema_setup(){
    echo -e "${color} Install my sql${no_color}"
    yum install mysql -y &>>${file_path}

    start_check $?
    echo -e "${color} load schema ${no_color}"
    mysql -h mysql-dev.devopspractice.store -uroot -pRoboShop@1 < $app_pathcd /schema/${component}.sql &>>${file_path}
    start_check $?
 }

 python(){
 echo -e "${color} Install python ${no_color}"
 yum install python36 gcc python3-devel -y &>>${file_path}
 start_check $?

 app_presetup

 echo -e "${color} Install python dependencies ${no_color}"
 cd $app_path
 pip3.6 install -r requirements.txt &>>${file_path}
 start_check $?
 systemd_setup

 }

 golang(){
 echo -e "${color}  Install golang ${no_color}"
 yum install golang -y &>>${file_path}
 start_check $?

 app_presetup

 echo -e "${color} download dependencies and build software ${no_color}"
 cd $app_path
 go mod init dispatch &>>${file_path}
 go get &>>/tmp/roboshop.log
 go build &>>/tmp/roboshop.log
 start_check $?
 systemd_setup

 }