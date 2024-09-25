#!/bin/bash
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
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
fi [ ID -ne 0 ]
then
    echo -e "$R ERROR::please run this script root user $N"
    exit 1
else
    echo "you are root user"
fi       