create table [role](id int primary key,
				role_name varchar(100))
create table [Status](id int primary key,
						Status_name varchar(100),
						is_user_working bit)						
create table user_account(id int primary key,
						 username varchar(100),
						 email varchar(254),
						 [password] varchar(200),
						 password_salt varchar(50) not null,
						 Password_hash_algorithm varchar(50)
						 )
create table user_has_role(id int primary key,
						role_start_time datetime,
						role_end_time datetime,
						User_account_id int foreign key references user_account(id),
						role_id int foreign key references [role](id))
create table user_has_status(id int primary key,
						status_start_time datetime,
						status_end_time datetime,
						user_account_id int foreign key references user_account(id),
						user_status_id int foreign key references [status](id))

insert into [role] values
						(1,'Process associate'),
						(2,'Developer')
insert into [Status] values
					(1,'is_working',0),
					(2,'not_working',1)
insert into user_account values 
(100,'John','john@gmail.com','john123','John123','john123'),
(101,'Ross','ross@gmail,com','ross123','ross123','ross123')
insert into user_has_role values 
(1001,'2023-01-01 10:00:00','2023-01-01 16:00:00',100,1),
(1002,'2023-01-01 10:00:00','2023-01-01 16:00:00',101,2)
insert into user_has_status values
(1,'2023-01-01 10:00:00','2023-01-01 16:00:00',100,1),
(2,'2023-01-01 10:00:00','2023-01-01 16:00:00',101,1)
--delete from [role]
--delete from [status]
--delete from [user_account]
--delete from [user_has_role]
--delete from [user_has_status]
--Above tabledata can't be deleted as the Primary keys and foreign key connection 
--has been created, as the primary keys should be deleted first
--Note
--since the timestamp datatype can be assigned to only one column of the
--table i have apted for the datetime datatype in the user_has_role and user_has_status
--tables