#!/bin/bash

/usr/bin/python /opt/jinja-barnyard-conf.py > /usr/local/etc/barnyard2.conf

if [ "$DELETEDB" != "false" ]; then
   if [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_PASSWORD" ] && [ -n "$MYSQL_HOST" ] && [ -n "$MYSQL_DBNAME" ]; then
	$(/usr/bin/mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -h $MYSQL_HOST -e "drop database $MYSQL_DBNAME;")
	echo "drop database $MYSQL_DBNAME DONE"
   else
	echo "Deleting DB FAILED : ENV VARIABLE MISSING :
	Please check if you have the following ENV setup : 
	- --env DELETEDB 
	- --env MYSQL_USER
	- --env MYSQL_PASSWORD 
	- --env MYSQL_HOST 
	- --env MYSQL_DBNAME"
   fi
	
fi
if [ "$ADD_DBUSER" != "false" ]; then
   if [ -n "$MYSQL_ADMIN" ] && [ -n "$MYSQL_ADMINPASS" ] && [ -n "$MYSQL_HOST" ] && [ -n "$MYSQL_DBNAME" ] && [ -n "$MYSQL_PASSWORD" ] && [ -n "$MYSQL_USER" ]; then
	$(/usr/bin/mysql -u$MYSQL_ADMIN -p$MYSQL_ADMINPASS -h $MYSQL_HOST -e "create database $MYSQL_DBNAME;")
	$(/usr/bin/mysql -u$MYSQL_ADMIN -p$MYSQL_ADMINPASS -h $MYSQL_HOST -e "GRANT ALL PRIVILEGES ON $MYSQL_DBNAME.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';")
	$(/usr/bin/mysql -u$MYSQL_ADMIN -p$MYSQL_ADMINPASS -h $MYSQL_HOST -e "FLUSH PRIVILEGES;")
	echo "create database $MYSQL_DBNAME and GRANT ALL PRIVILEGES TO '$MYSQL_USER' DONE"
   else
	echo "Add privilege user FAILED : ENV VARIABLE MISSING :
	Please check if you have the following ENV setup : 
	- --env ADD_DBUSER
	- --env MYSQL_ADMIM 
	- --env MYSQL_ADMINPASS 
	- --env MYSQL_HOST 
	- --env MYSQL_DBNAME 
	- --env MYSQL_PASSWORD 
	- --env MYSQL_USER"
   fi

fi

if [ "$INSTALLDB" != "false" ]; then
   if [ -n "$MYSQL_HOST" ] && [ -n "$MYSQL_DBNAME" ] && [ -n "$MYSQL_PASSWORD" ] && [ -n "$MYSQL_USER" ]; then
	$(/usr/bin/mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -h $MYSQL_HOST < '/opt/barnyard2/schemas/create_mysql')
   else
	echo "Creating DB FAILED : ENV VARIABLE MISSING :
	Please check if you have the following ENV setup : 
	- --env INSTALLDB
	- --env MYSQL_HOST 
	- --env MYSQL_DBNAME 
	- --env MYSQL_PASSWORD 
	- --env MYSQL_USER"
   fi

fi

args_waldo=''
args_archive=''
args_file=''
args_spool=''
args_event=''
if [ -n "$WALDO_FILE" ]; then
	args_waldo="-w $WALDO_FILE"
fi
if [ -n "$ARCHIVE_DIR" ]; then
	args_archive="-a $ARCHIVE_DIR"
fi
if [ -n "$FILE_BASE" ]; then
	args_file="-f $FILE_BASE"
else
	echo ' ENV FILE_BASE is mandatory' 
fi
if [ -n "$SPOOL_DIR" ]; then
	args_spool="-d $SPOOL_DIR"
else
	echo ' ENV SPOOL_DIR is mandatory' 
fi
if [ -n "$ONLY_NEW_EVENT" ]; then
	args_event="-n"
fi

if [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ] || [ -z "$MYSQL_HOST" ] || [ -z "$MYSQL_DBNAME" ] || [ -z "$MYSQL_OUTPUT_TYPE" ]; then
	echo "Barnyard will fail : ENV VARIABLE MISSING :
	Please check if you have the following ENV setup : 
	- --env MYSQL_HOST 
	- --env MYSQL_DBNAME 
	- --env MYSQL_PASSWORD 
	- --env MYSQL_USER
	- --env MYSQL_OUTPUT_TYPE"
fi


barnyard2 -c /usr/local/etc/barnyard2.conf $args_waldo $args_archive $args_file $args_spool $args_event $@
