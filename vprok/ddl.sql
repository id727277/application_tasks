show search_path;
set search_path to vprok;
--create schema vprok;

drop table if exists "Client";

create table "Client" (

	ID Serial primary key not null,
	first_name varchar(255) default null,
	second_name varchar(255) default null
)
;

insert into "Client" (first_name, second_name)
values
('Ahmed', 'Hull'),
('Rafael', 'Case'),
('Vincent', 'Gonzales'),
('Isabelle', 'Sampson'),
('Clementine', 'Manning')
;



drop table if exists "Account";

create table "Account" 
(
	ID Serial primary key not null,
	client_id Int REFERENCES "Client" (ID),
	account_type varchar(50) not null,
	operations_limit int default null
);

insert into "Account" (client_id, account_type, operations_limit)
values

(1, 'credit', 30000),
(2, 'credit', 185000),
(3, 'credit', 345000),
(4, 'credit', 100000),
(5, 'credit', 12000)
;


drop table if exists "Payments";

create table "Payments" 
(
	ID Serial primary key not null,
	account_id Int REFERENCES "Account" (ID),
	payment_date date not null,
	payment_amount int not null,
	description text default null,
	payment_type varchar(50) not null
);


insert into "Payments" (account_id, payment_date, payment_amount, description, payment_type)
values
(1, '2021-05-07', 1100, null,'payment'),
(2, '2020-07-01', 15600, null,'payment'),
(3, '2021-05-07', 4500, null,'cancel'),
(4, '2020-07-01', 1200, null,'payment'),
(5, '2020-05-07', 15100, null,'payment'),
(1, '2021-07-01', 3400, null,'cancel'),
(2, '2020-05-07', 5400, null,'payment'),
(3, '2020-07-01', 4800, null,'cancel'),
(4, '2021-05-07', 9800, null,'payment'),
(5, '2020-07-07', 1200, null,'cancel'),
(1, '2021-05-07', 1100, null,'payment'),
(1, '2020-07-01', 15600, null,'payment'),
(1, '2021-05-07', 4500, null,'cancel'),
(1, '2020-07-01', 1200, null,'payment'),
(1, '2020-05-07', 15100, null,'payment'),
(2, '2021-07-01', 3400, null,'cancel'),
(2, '2020-05-07', 5400, null,'payment'),
(2, '2020-07-01', 4800, null,'cancel'),
(2, '2021-05-07', 9800, null,'payment'),
(2, '2020-07-07', 1200, null,'cancel'),
(1, '2021-05-07', 1100, null,'payment'),
(2, '2020-07-01', 15600, null,'payment'),
(3, '2021-05-07', 4500, null,'cancel'),
(4, '2020-07-01', 1200, null,'payment'),
(5, '2020-05-07', 15100, null,'payment'),
(1, '2022-03-01', 3400, null,'cancel'),
(2, '2022-03-07', 5400, null,'payment'),
(3, '2022-01-01', 4800, null,'cancel'),
(4, '2022-03-07', 9800, null,'payment'),
(5, '2022-02-15', 1200, null,'cancel'),
(1, '2022-03-01', 3400, null,'cancel'),
(2, '2022-03-07', 5400, null,'payment'),
(3, '2022-03-01', 4800, null,'cancel'),
(4, '2022-03-07', 9800, null,'payment'),
(5, '2022-02-15', 1200, null,'cancel'),
(1, '2022-03-01', 3400, null,'cancel'),
(2, '2022-03-07', 5400, null,'payment'),
(3, '2022-03-01', 4800, null,'cancel'),
(4, '2022-03-07', 9800, null,'payment'),
(5, '2022-02-15', 1200, null,'cancel'),
(1, '2022-03-01', 3400, null,'cancel'),
(2, '2022-03-07', 5400, null,'payment'),
(3, '2022-03-01', 4800, null,'cancel'),
(4, '2022-03-07', 9800, null,'payment'),
(5, '2022-02-15', 1200, null,'cancel'),
(1, '2022-03-01', 3400, null,'cancel'),
(2, '2022-03-07', 5400, null,'payment'),
(3, '2022-03-01', 4800, null,'cancel'),
(4, '2022-03-07', 9800, null,'payment'),
(5, '2022-02-15', 1200, null,'cancel'),
(1, '2022-03-01', 3400, null,'payment'),
(2, '2022-03-07', 5400, null,'payment'),
(3, '2022-03-01', 4800, null,'payment'),
(4, '2022-03-07', 9800, null,'payment'),
(5, '2022-02-15', 1200, null,'payment'),
(1, '2022-03-01', 3400, null,'payment'),
(2, '2022-03-07', 5400, null,'payment'),
(3, '2022-03-01', 4800, null,'payment'),
(4, '2022-03-07', 9800, null,'payment'),
(5, '2022-02-15', 1200, null,'payment'),
(1, '2022-03-01', 3400, null,'payment'),
(2, '2022-03-07', 5400, null,'payment'),
(3, '2022-03-01', 4800, null,'payment'),
(4, '2022-03-07', 9800, null,'payment'),
(5, '2022-02-15', 1200, null,'payment')
;