# Barnyard2 for Mysql Output Docker Image

Docker image with Barnyard binary using as intermediary between unified2 file to mysql database.

This Container only embedded the barnyard2 binary (https://github.com/firnsy/barnyard2) 
to convert the input unified2 files from snort/suricate/IDS to mysql database data in output.
Barnyard get the input file to feed a mysql database in output (like for snorby web application) 

To deploy the container, you need to specify the database information to connect to.
If your database is not already yet, the container can install/delete it for you
You also have to specify Mandatory information for barnyard2 to run. (see the Basic Usage section)



# Environmental Variable
In this Image you can use environmental variables to connect into external MySQL/MariDB database. 
### Basic Usage if the database is already setup (see next section)

    docker run -d  -e FILE_BASE=merged.log -e SPOOL_DIR=/var/log/snort -e MYSQL_HOST=mydatabase.local \
    -e MYSQL_DBNAME=snorby -e MYSQL_PASSWORD=rootpassword -e MYSQL_USER=snorby -e MYSQL_OUTPUT_TYPE=log \
    -v /path/to/snort/output/:/var/log/snort --name=barnyard-mysql troptop/docker-barnyard-mysql

- `MYSQL_HOST` = Database hostname (Mandatory)
- `MYSQL_DBNAME` = Database Name that you want to create (Mandatory)
- `MYSQL_USER` = User name that will have access to the database (Mandatory)
- `MYSQL_PASSWORD` = The password of the user that will have access to the database (Mandatory)
- `FILE_BASE` = <filename> - Use <base> as the base filename pattern - name of the snort file output - e.g. : merged.log or snort.log (Mandatory)
- `SPOOL_DIR` = <dir> - Spool files from <dir> (Mandatory)
- `MYSQL_OUTPUT_TYPE` =  [log | alert] - specify log or alert to connect the database plugin to the log or alert facility (Mandatory)
- `WALDO_FILE` = <filepath> Enable bookmarking using <file> (Mandatory)
- `ENV ARCHIVE_DIR` = <dir> - Archive processed files to <dir> (Mandatory)
- `ENV ONLY_NEW_EVENT` = Only process new events (Mandatory)

### To install the snorby database schema 
You need to use the following Environmental Variable :

`ADD_DBUSER`= If different to "false" (minuscule) the container will create a user called `MYSQL_USER` 
with ALL privileges to the MYSQL_DBNAME database.
If the `ADD_DBUSER` is set the following ENV are required too :
- `MYSQL_ADMIM`= Admin user with the privileges to create the database
- `MYSQL_ADMINPASS` = Admin password to create the database
- `MYSQL_HOST` = Database hostname
- `MYSQL_DBNAME` = Database Name that you want to create
- `MYSQL_USER` = User name that will have access to the database
- `MYSQL_PASSWORD` = The password of the user that will have access to the database
- 
`DELETEDB`= If different to "false" (minuscule) the container will drop the database called `MYSQL_DBNAME`.
If the `DELETEDB` is set the following ENV are required too :
- `MYSQL_ADMIM`= Admin user with the privileges to create the database
- `MYSQL_ADMINPASS` = Admin password to create the database
- `MYSQL_HOST` = Database hostname
- `MYSQL_DBNAME` = Database Name that you want to create

`INSTALLDB`= If different to "false" (minuscule) the container will create a database called `MYSQL_DBNAME` 
and import the barnyard mysql database /opt/barnyard2/schemas/create_mysql (in barnyard2 github repo).
If the `INSTALLDB` is set the following ENV are required too :
- `MYSQL_HOST` = Database hostname
- `MYSQL_DBNAME` = Database Name that you want to create
- `MYSQL_USER` = User name that will have access to the database
- `MYSQL_PASSWORD` = The password of the user that will have access to the database

**Example :**
This example will create a container that :
    - firstly delete the barnyard database called snorby (if exist)

    docker run -d --name snorby -p 80:80 --env="MYSQL_HOST=database_ip" --env="MYSQL_USER=snorby" \
    --env="MYSQL_PASSWORD=snorby" --env="MYSQL_DBNAME=snorby" --env="DELETEDB" --env="MYSQL_ADMIN=root" \
    --env="MYSQL_ADMINPASS=rootpassword" troptop/docker-barnyard-mysql


    - secondly create a new database called snorby
    

    docker run -d --name snorby -p 80:80 --env="MYSQL_HOST=database_ip" --env="MYSQL_USER=snorby" \
    --env="MYSQL_PASSWORD=snorby" --env="MYSQL_DBNAME=snorby" --env="INSTALLDB" --env="MYSQL_ADMIN=root" \
    --env="MYSQL_ADMINPASS=rootpassword" troptop/docker-barnyard-mysql


### Database deployment 
To be able to connect to database we would need one to be running first. Easiest way to do that is to use another docker image. 
Example:  

    docker run \
    -d \
    --name snorby-db \
    --env="MYSQL_USER=snorby" \
    --env="MYSQL_PASSWORD=snorby" \
    --env="MYSQL_DATABASE=snorby" \
    --env=" MYSQL_ROOT_PASSWORD=my_password" \
        mariadb
        
## Author
  
Author: Cymatic (<info@cymatic.eu>) - www.cymatic.eu

---
