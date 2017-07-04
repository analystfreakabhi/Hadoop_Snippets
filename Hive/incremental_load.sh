## https://hortonworks.com/blog/four-step-strategy-incremental-updates-hive/

sqoop import \
  --connect "jdbc:mysql://sandbox.hortonworks.com:3306/sakila" \
  --username=sakila_dba \
  --password=hadoop \
  --table actor \
  --target-dir=/user/root/actor_base \
  --driver com.mysql.jdbc.Driver \
  
mysql> INSERT INTO sakila.actor VALUES (201, 'Abhijeet', 'Rajput', CURDATE());
mysql> INSERT INTO sakila.actor VALUES (202, 'Smita', 'Singh', CURDATE());


sqoop import \
  --connect "jdbc:mysql://sandbox.hortonworks.com:3306/sakila" \
  --username=sakila_dba \
  --password=hadoop \
  --table actor \
  --target-dir=/user/root/actor_incremental \
  --driver com.mysql.jdbc.Driver \
  -m 1 \
  --check-column last_update \
  --incremental lastmodified \
  --last-value '2017-07-01'
  
  OR 
  
sqoop import \
  --connect "jdbc:mysql://sandbox.hortonworks.com:3306/sakila" \
  --username=sakila_dba \
  --password=hadoop \
  --target-dir=/user/root/actor_incremental \
  --driver com.mysql.jdbc.Driver \
  -m 1 \
  --query 'select * from actor where last_update > '2017-07-01' AND $CONDITIONS’
  
CREATE TABLE actor_base(
  actor_id smallint,
  first_name varchar(45) ,
  last_name varchar(45) ,
  last_update TIMESTAMP
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LOCATION '/user/root/actor_base';  

CREATE TABLE actor_incremental (
  actor_id smallint,
  first_name varchar(45) ,
  last_name varchar(45) ,
  last_update TIMESTAMP
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LOCATION '/user/root/actor_incremental';  


CREATE VIEW reconcile_view AS
SELECT t1.* FROM
(SELECT * FROM actor_base
    UNION ALL
    SELECT * FROM actor_incremental) t1
JOIN
    (SELECT actor_id, max(last_update) max_modified FROM
        (SELECT * FROM actor_base
        UNION ALL
        SELECT * FROM actor_incremental) t2
    GROUP BY actor_id) s
ON t1.actor_id = s.actor_id AND t1.last_update = s.max_modified;

DROP TABLE reporting_actor;
CREATE TABLE reporting_actor AS
SELECT * FROM reconcile_view;

DROP TABLE actor_base;
CREATE TABLE actor_base AS
SELECT * FROM reporting_actor;