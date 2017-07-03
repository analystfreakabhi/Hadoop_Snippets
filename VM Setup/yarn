Processing Movie Lens dataset:
https://github.com/myui/hivemall/wiki/MovieLens-Dataset

[abhidocs@iop-bi-master movie_lens]$ hadoop fs -mkdir -p  datasets/movie_lens/movies
[abhidocs@iop-bi-master movie_lens]$ hadoop fs -mkdir -p  datasets/movie_lens/ratings
[abhidocs@iop-bi-master movie_lens]$ hadoop fs -mkdir -p  datasets/movie_lens/users
[abhidocs@iop-bi-master movie_lens]$ hadoop fs -mkdir -p  datasets/movie_lens/occupations

[abhidocs@iop-bi-master movie_lens]$ hadoop fs -put movies.dat datasets/movie_lens/movies
[abhidocs@iop-bi-master movie_lens]$ hadoop fs -put occupations.dat datasets/movie_lens/occupations
[abhidocs@iop-bi-master movie_lens]$ hadoop fs -put ratings.dat datasets/movie_lens/ratings
[abhidocs@iop-bi-master movie_lens]$ hadoop fs -put users.dat datasets/movie_lens/users

use hive_tasks;

CREATE EXTERNAL TABLE ratings (
  userid INT, 
  movieid INT,
  rating INT, 
  tstamp STRING
) ROW FORMAT DELIMITED
FIELDS TERMINATED BY '#'
STORED AS TEXTFILE
LOCATION '/user/abhidocs/datasets/movie_lens/ratings';

CREATE EXTERNAL TABLE movies (
  movieid INT, 
  title STRING,
  genres ARRAY<STRING>
) ROW FORMAT DELIMITED
FIELDS TERMINATED BY '#'
COLLECTION ITEMS TERMINATED BY "|"
STORED AS TEXTFILE
LOCATION '/user/abhidocs/datasets/movie_lens/movies';


CREATE EXTERNAL TABLE users (
  userid INT, 
  gender STRING, 
  age INT,
  occupation INT,
  zipcode STRING
) ROW FORMAT DELIMITED
FIELDS TERMINATED BY '#'
STORED AS TEXTFILE
LOCATION '/user/abhidocs/datasets/movie_lens/users';

CREATE EXTERNAL TABLE occupations (
  id INT,
  occupation STRING
) ROW FORMAT DELIMITED
FIELDS TERMINATED BY '#'
STORED AS TEXTFILE
LOCATION '/user/abhidocs/datasets/movie_lens/occupations';

- Adding rowids to the rating table
SET hivevar:seed=31;
CREATE TABLE ratings2
as
select
  rand(${seed}) as rnd, 
  userid, 
  movieid, 
  rating
from 
  ratings;

CREATE TABLE training
as
select * from ratings2
order by rnd DESC
limit 800000;

CREATE TABLE testing
as
select * from ratings2
order by rnd ASC
limit 200209;