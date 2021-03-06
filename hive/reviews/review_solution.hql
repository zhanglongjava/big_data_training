//create database review_db
CREATE DATABASE review_db
COMMENT  "This is a product review db"
LOCATION "/tmp/data/prod_review/"
WITH DBPROPERTIES ("creator" = "hadoop", "date" = "2017-11-01");

//show database information
SHOW DATABASES;
DESCRIBE DATABASE review_db;
DESCRIBE DATABASE EXTENDED review_db;

//revise database information
ALTER DATABASE test_db SET DBPROPERTIES ('edited-by' = 'hadoop');
DROP DATABASE test_db;

//create internal table 
create table ratings(userid INT,itemid INT, rating INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' ;
LOAD DATA LOCAL INPATH 'ratings.tsv' OVERWRITE INTO TABLE ratings;

//create external table 
create external table items(itemid INT, category STRING)ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'  LOCATION '/tmp/data/yelp'

//upload data
hadoop fs -mkdir /tmp/data/yelp
hadoop fs -put items.tsv /tmp/data/yelp

//view items
DESC items;
DESC EXTENDED items;
select * from items;

//Query SQL
select * from ratings s  join items t on s.itemid=t.itemid limit 30;

//Set local mode
SET hive.exec.mode.local.auto=true;

hadoop fs -mkdir /usr
hadoop fs -mkdir /usr/lib
hadoop fs -mkdir /usr/lib/hive/
hadoop fs -mkdir /usr/lib/hive/lib/
hadoop fs -put /usr/lib/hive/lib/hive-contrib.jar /usr/lib/hive/lib/

//Compare internal and external tables
drop table items;
hadoop fs -ls /yelp

drop table ratings;
hadoop fs -ls /user/hive/warehouse/

//create partition table
create table top_ratings (userid INT, itemid INT)  partitioned by(rating INT) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' ;
LOAD DATA LOCAL INPATH 'top_ratings.tsv' overwrite INTO TABLE top_ratings partition (rating = 5 )  ;
LOAD DATA LOCAL INPATH 'second_ratings.tsv' overwrite INTO TABLE top_ratings partition (rating = 4 )  ;

select * from top_ratings where rating = 5;


//Create bucket table
CREATE TABLE bucket_ratings (userid int, itemid int,rating int) CLUSTERED BY (rating) sorted by (rating asc) into 5 buckets
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

LOAD DATA LOCAL INPATH 'ratings.tsv' INTO TABLE bucket_ratings;
select * from bucket_ratings tablesample(bucket 2 out of 5);

