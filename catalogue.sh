
source common.sh
component= catalogue


nodejs

echo -e " ${color} copying MongoDB repo file ${no_color}"
cp /home/centos/Roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${file_path}

echo -e " ${color} Install MongoDb client  ${no_color}"
yum install mongodb-org-shell -y &>>${file_path}

echo -e " ${color}' Load schema ${no_color}"
mongo --host mongodb-dev.devopspractice.store <$app_path/schema/${component}.js &>>${file_path}'