#!/bin/bash
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP=$(date +%F-%H-%M-S%)
LOGFILE="/tmp/$0-TIMESTAMP.logfile"
exec &>LOGFILE
echo "script stated executing at $TIMESTAMP" &>> $LOGFILE
VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ...$R FAILED $N"
        exit 1
    else
        echo -e "$1 ...$G SUCCESS $N"
    fi        
}
fi [ $ID -ne 0 ]
then
    echo -e "$R ERROR::please run this script with root access $N"
    exit 1
else
    echo "you are root user"
fi
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
VALIDATE $? "Installing Remi release"
dnf module enable redis:remi-6.2 -y
VALIDATE $? "Enable redis"
dnf install redis -y
VALIDATE $? "Installing redis"
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf
VALIDATE $? "allowing for remote connection"
systemctl enable redis
VALIDATE $? "Enable redis"
systemctl start redis
VALIDATE $? "Start redis"         