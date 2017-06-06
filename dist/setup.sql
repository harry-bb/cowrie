CREATE DATABASE cowrie;
GRANT ALL ON cowrie.* TO 'cowrie'@'172.16.0.0/255.240.0.0' IDENTIFIED BY 's0m3Secr3T!';
GRANT ALL ON cowrie.* TO 'cowrie'@'localhost' IDENTIFIED BY 's0m3Secr3T!';
FLUSH PRIVILEGES;
USE cowrie;
SOURCE /home/cowrie/cowrie/doc/sql/mysql.sql;
