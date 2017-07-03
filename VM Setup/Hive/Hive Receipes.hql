$ hive -S

--using hive print header
hive> set hive.cli.print.header=true;
hive> select * from dual;

-- surrogate keys
1) select *,(row_number() over())+12345 as surro_key from t1; 

--using hive variables
SET hivevar:seed=31;

--https://www.mapr.com/blog/quick-tips-using-hive-shell-inside-scripts