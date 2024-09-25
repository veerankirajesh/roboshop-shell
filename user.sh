#!/bin/bash
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGODB_HOST=mongodb.rajesh76.online
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
echo "script stareted executing $TIMESTAMP" &>> LOGFILE
VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ...$R FAILED $N"
        exit 1
    else
        echo -e "$1 ...$Y SUCCESS $N"
    fi         
}
if [ $ID -ne 0 ]
then
    echo -e "$R ERROR::please run this script root user $N"
    exit 1
else
    echo "you are root user"
fi
dnf module disable nodejs -y &>> LOGFILE
VALIDATE $? "Disabling current NodeJS"
dnf module enable nodejs:18 -y &>> LOGFILE
VALIDATE $? "Enable current NodeJS"
dnf install nodejs -y &>> LOGFILE
VALIDATE $? "Installing NodeJS:18"
id roboshop #if roboshop user does not exist, then it is failure
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi
mkdir -p /app 
VALIDATE $? "Creating app directory"
curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> LOGFILE
VALIDATE $? "Download user directory"
cd /app 
unzip -o /tmp/user.zip  &>> $LOGFILE
VALIDATE $? "Unziping user"
npm install &>> LOGFILE
VALIDATE $? "Npm install"
cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service 
VALIDATE $? "Copping user.service"
systemctl daemon-reload &>> LOGFILE
VALIDATE $? "Daemon reload"
systemctl enable user &>> LOGFILE
VALIDATE $? "Enable user"
systemctl start user &>> LOGFILE
VALIDATE $? "Start user"
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> LOGFILE
VALIDATE $? "copping mongodb.repo"
dnf install mongodb-org-shell -y &>> LOGFILE
VALIDATE $? "install mongodb client"
mongo --host $MONGDB_HOST </app/schema/user.js &>> $LOGFILE &>> LOGFILE
VALIDATE $? "Loading useing into mongodb"

