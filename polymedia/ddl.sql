-- setting up 
create schema komarpp;
set search_path to komarpp, public;


/*****************************************
********************DDL*******************
*****************************************/



-- department
drop table  if exists komarpp.department;

CREATE TABLE if not exists komarpp.department
(
 department_id serial NOT NULL,
 filial_id     integer NOT NULL,
 dep_chif_id   integer NOT NULL
);



-- seller
drop table if exists komarpp.seller;

CREATE TABLE if not exists komarpp.seller
(
 "id"          serial NOT NULL,
 fio           text NOT NULL,
 department_id serial NOT NULL
);



-- item
--drop table if exists komarpp.item cascade;
--
--CREATE TABLE if not exists komarpp.item
--(
-- item_id varchar(50) NOT NULL
--);



-- sale
drop table if exists komarpp.sale;

CREATE TABLE if not exists komarpp.sale
(
 sale_date   timestamp NOT NULL,
 item_id     varchar(50) NOT NULL,
 salesman_id serial NOT NULL,
 quantity    integer NOT NULL,
 final_price integer NOT NULL
);



-- product table
drop table if exists komarpp.product;

CREATE TABLE if not exists komarpp.product
(
 id		   varchar(50) not null,	
 name      text NOT NULL,
 price     integer NOT NULL,
 sdate     timestamp NOT NULL,
 edate     timestamp NOT NULL,
 is_actual smallint NOT NULL
);

-- services table
drop table if exists komarpp.service;

CREATE TABLE if not exists komarpp.service
(
 id		   varchar(50) not null,	
 name      text NOT NULL,
 price     integer NOT NULL,
 sdate     timestamp NOT NULL,
 edate     timestamp NOT NULL,
 is_actual smallint NOT NULL
);


















