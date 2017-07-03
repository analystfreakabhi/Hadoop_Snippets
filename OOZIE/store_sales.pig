A = LOAD '/user/root/datasets/store_sales/' using PigStorage(',') as (store_cd,year,quarter,sales_amt);
B = FOREACH A GENERATE $0 , $3 ;
C = GROUP B BY $0;
D = FOREACH C GENERATE group, SUM(B.sales_amt) as TotalSales;
STORE D INTO '/user/root/datasets/pig_output' using PigStorage('|');
