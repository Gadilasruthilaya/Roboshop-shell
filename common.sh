color= "\e[31m"
no_color="\e[0m"
file_path="/tmp/roboshop.log"
app_path="/app"

nodejs(){

  echo -e " ${color} configuring nodejs ${no_color}"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${file_path}

  echo -e " ${color} Installing nodejs ${no_color}"
  yum install nodejs -y &>>${file_path}

  echo -e " ${color} Add application user ${no_color}"
  useradd roboshop &>>${file_path}

  echo -e " ${color} Creat application directory ${no_color}"
  rm -rf $app_path &>>${file_path}
  mkdir $app_path

  echo -e " ${color} Download application content  ${no_color}"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${file_path}
  cd $app_path

  echo -e "${color}  Extract application Conetent ${no_color}"
  unzip /tmp/${component}.zip &>>${file_path}
  cd $app_path &>>${file_path}

  echo -e " ${color} Install nodejs dependencies ${no_color}"
  npm install &>>${file_path}

  echo -e " ${color} setup Systemd service  ${no_color}"
  cp /home/centos/Roboshop-shell/${component}.service /etc/systemd/system/${component}.service &>>${file_path}

  echo -e " ${color} start ${component}service ${no_color}"
  systemctl daemon-reload  &>>${file_path}
  systemctl enable${component}&>>${file_path}
  systemctl start ${component} &>>${file_path}
}