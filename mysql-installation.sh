#!/bin/bash

source ./common.sh
check_root


echo "Please enter DB Password:"
read -s mysql_root_password

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing MySQL server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling MySQL server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting MySQL server"



#mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
#VALIDATE $? "Setting up password"

#Below code is used for idempotent nature

mysql -h db.goliexpense.online -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then 
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
    VALIDATE $? "MySQL Root password Setup"
else
    echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
fi 