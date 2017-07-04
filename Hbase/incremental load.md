mysql> describe actor;
+-------------+----------------------+------+-----+-------------------+-----------------------------+
| Field       | Type                 | Null | Key | Default           | Extra                       |
+-------------+----------------------+------+-----+-------------------+-----------------------------+
| actor_id    | smallint(5) unsigned | NO   | PRI | NULL              | auto_increment              |
| first_name  | varchar(45)          | NO   |     | NULL              |                             |
| last_name   | varchar(45)          | NO   | MUL | NULL              |                             |
| last_update | timestamp            | NO   |     | CURRENT_TIMESTAMP | on update CURRENT_TIMESTAMP |
+-------------+----------------------+------+-----+-------------------+-----------------------------+

1. **Initial Import to hbase using SQOOP**

```shell

sqoop import \ 
--connect "jdbc:mysql://sandbox.hortonworks.com:3306/sakila" \ 
--username=sakila_dba \ 
--password=hadoop \
--table actor  \
--hbase-table actor_hbase \
--column-family actor_id \
--hbase-row-key actor_id \
-m 1 \ 
--driver com.mysql.jdbc.Driver \
--hbase-create-table \
--columns actor_id,first_name,last_name,last_update
```

view data from "**hbase shell**"

hbase(main):033:0> get 'actor', '1'
COLUMN                                           CELL
 actor:first_name                                timestamp=1499125992457, value=PENELOPE
 actor:last_name                                 timestamp=1499125992457, value=GUINESS
 actor:last_update                               timestamp=1499125992457, value=2006-02-15 04:34:33.0

2. **Create external hive table**

   ```sql
   CREATE EXTERNAL TABLE actor_ext_hive(actor_id STRING, first_name STRING, last_name STRING, last_update STRING)
   STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
   WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key,actor:first_name,actor:last_name,actor:last_update')
   TBLPROPERTIES ('hbase.table.name' = 'actor');
   ```

Time taken: 5.533 seconds, Fetched: 1 row(s)
hive> select * from actor_ext_hive limit 4;
OK
1       PENELOPE        GUINESS 2006-02-15 04:34:33.0
10      CHRISTIAN       GABLE   2006-02-15 04:34:33.0
100     SPENCER DEPP    2006-02-15 04:34:33.0
101     SUSAN   DAVIS   2006-02-15 04:34:33.0

3. **Incremental Load** 

   Import the data from the source table using SQOOP ( or any other ETL process) , including inserts and updates from last import.

4. **incremental import**

   find the date of last import, one of the way to find out is :

   ```shell
   max_updt_dt=$(hive -e "select max(last_update) from actor_base")
   ```

   perform incremental import as below

   ```shell
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
     --last-value '${max_updt_dt}'
   ```

5. **Create External table pointing to above location :** 

   ```sql
   CREATE TABLE actor_incremental (
     actor_id smallint,
     first_name varchar(45) ,
     last_name varchar(45) ,
     last_update TIMESTAMP
   )
   ROW FORMAT DELIMITED
   FIELDS TERMINATED BY ','
   LOCATION '/user/root/actor_incremental';  
   ```

   ​

6. update the hbase/hive table with new data:

   ```sql
   insert into actor_ext_hive select * from actor_incremental;
   ```