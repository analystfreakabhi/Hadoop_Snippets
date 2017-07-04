### Shell Scripts : 
Hbase command base : 
1) sqoop import :
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

Ref : https://community.hortonworks.com/questions/41307/sqoop-import-hbase.html
## Try with columns to select specific columns
1) sqoop import \ 
sqoop import \  
--connect "jdbc:mysql://sandbox.hortonworks.com:3306/sakila" \ 
--username=sakila_dba \
--password=hadoop \
--table actor  \
--hbase-table actor \
--column-family actor \
--hbase-row-key actor_id \
-m 1 \
--driver com.mysql.jdbc.Driver \
--hbase-create-table \
--columns actor_id,first_name,last_name,last_update

## Basic commands 

1) start hbase shell : $ ./bin/hbase shell
2) help 
3) list ## display all of the tables in db
   list help # List all tables in hbase. Optional regular expression parameter could be used to filter the output. Examples
   list 'actor*'   
4) describe 'actor'
	#The describe command returns details about the table, including a list of all column families, which in our case is one: info. Now let's add some data to our table. The following command inserts a new row into the info column family:

hbase(main):014:0> describe 'actor'
Table actor is ENABLED
actor
COLUMN FAMILIES DESCRIPTION
{NAME => 'actor', DATA_BLOCK_ENCODING => 'NONE', BLOOMFILTER => 'ROW', REPLICATION_SCOPE => '0', VERSIONS => '1', COMPRESSION => 'NONE', MIN_VERSIONS => '0', TTL => 'FOREVER', KEEP_DELETED_C
ELLS => 'FALSE', BLOCKSIZE => '65536', IN_MEMORY => 'false', BLOCKCACHE => 'true'}
1 row(s) in 0.0370 seconds

5) ##get 'mytable', 'row_key'	Get a record
	get 'actor', '90'
	
hbase(main):002:0> get 'actor', '90'
COLUMN                                           CELL
 actor:first_name                                timestamp=1499125992457, value=SEAN
 actor:last_name                                 timestamp=1499125992457, value=GUINESS
 actor:last_update                               timestamp=1499125992457, value=2006-02-15 04:34:33.0
3 row(s) in 0.2730 seconds

6) hbase(main):007:0> status 'detailed'
version 1.1.2.2.4.0.0-169
## detail status of the servers/ node

7) scan 'test-table', {'LIMIT' => 5}
## display 10 rows like LIMIT
	

