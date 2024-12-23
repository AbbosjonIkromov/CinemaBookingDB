-- Cinema Booking App Database Design

create database cinema_booking;

create schema cinema_app;

create type user_role as enum('customer', 'admin');

-- table 1
create table cinema_app.users(
	user_id int primary key generated always as identity,
	name varchar(100) not null,
	email varchar(100) unique not null,
	password varchar(50) not null,
	role user_role default 'customer',
	phone varchar(50),
	created_at timestamp default current_timestamp
	
);

create type movie_genre as enum('Action', 'Drama');

-- table 2
create table cinema_app.movies(
	movie_id int primary key generated always as identity,
	title text not null,
	description text not null,
	genre movie_genre not null,
	duration_minutes int not null,
	release_date date default (current_date + interval '5 day'),
	rating int check(0 <= rating and rating <= 10),
	poster_url varchar(500),
	created_at timestamp default current_timestamp
);

-- table 3
create table cinema_app.cinemas(
	cinema_id int primary key generated always as identity,
	name varchar(100) not null,
	location varchar(500) not null,
	created_at timestamp default current_timestamp
);

-- table 4
create table cinema_app.screens(
	screen_id int primary key generated always as identity,
	cinema_id int not null references cinema_app.cinemas(cinema_id),
	name varchar(100) not null,
	capacity decimal not null
);

-- table 5
create table cinema_app.seats(
	seat_id int primary key generated always as identity,
	screen_id int not null references cinema_app.screens(screen_id),
	seat_number varchar(10) not null,
	seat_type varchar(100) not null
);

-- table 6
create table cinema_app.showtimes(
	showtime_id int primary key generated always as identity,
	screen_id int not null references cinema_app.screens(screen_id),
	movvie_id int not null references cinema_app.movies(movie_id),
	start_time timestamp default now(),
	end_time timestamp default now(),
	price decimal not null
);

-- table 7
create type booking_status as enum('pending','confirmed', 'canceled');

create table cinema_app.bookings(
	booking_id int primary key generated always as identity,
	user_id int not null references cinema_app.users(user_id),
	showtime_id int not null references cinema_app.showtimes(showtime_id),
	booking_date timestamp default current_timestamp,
	total_price decimal  not null,
	status booking_status default 'pending'
	
);

-- table 8

create table cinema_app.booking_details(
	booking_detail_id int primary key generated always as identity,
	booking_id int not null references cinema_app.bookings(booking_id),
	seat_id int not null references cinema_app.seats(seat_id),
	price decimal not null
);

-- table 9

create type payment_status as enum('pending', 'completed', 'failed');
create table cinema_app.payments(
	payment_id int primary key generated always as identity,
	booking_id int not null references cinema_app.bookings(booking_id),
	payment_date timestamp default current_timestamp,
	amount int not null,
	payment_method varchar(100) not null,
	status payment_status default 'pending'
	
);

-- SQL Mock Data Script for All Tables

INSERT INTO cinema_app.users (user_id, name, email, password, role, phone, created_at)
VALUES
	(default, 'Alice Smith', 'alice@gmail.com', 'hashed_password1', 'customer', '1234567890', '2024-01-01 10:00:00'),
	(default, 'Bob Johnson', 'bob@gmail.com', 'hashed_password2', 'admin', '0987654321', '2024-01-02 11:00:00'),
	(default, 'Charlie Brown', 'charlie@hotmail.com', 'hashed_password3', 'customer', '1122334455', '2024-01-03 12:00:00');

INSERT INTO cinema_app.movies (movie_id, title, description, genre, duration_minutes, release_date, rating, poster_url, created_at)
VALUES
	(default, 'Inception', 'A mind-bending thriller.', 'Action', 148, '2010-07-16', 8.8, 'inception_poster.jpg', '2024-01-01 10:00:00'),
	(default, 'The Matrix', 'A computer hacker learns about the true nature of reality.', 'Action', 136, '1999-03-31', 8.7, 'matrix_poster.jpg', '2024-01-02 11:00:00'),
	(default, 'Titanic', 'A romantic drama on the ill-fated ship.', 'Drama', 195, '1997-12-19', 7.9, 'titanic_poster.jpg', '2024-01-03 12:00:00');



INSERT INTO cinema_app.cinemas (cinema_id, name, location, created_at)
VALUES
	(default, 'Downtown Cinema', '123 Main Street, City Center', '2024-01-01 10:00:00'),
	(default, 'Uptown Theater', '456 Uptown Avenue, Suburbs', '2024-01-02 11:00:00'),
	(default, 'Parkside Cineplex', '789 Park Lane, Riverside', '2024-01-03 12:00:00');


INSERT INTO cinema_app.screens (screen_id, cinema_id, name, capacity)
VALUES
	(default, 1, 'Screen 1', 100),
	(default, 1, 'Screen 2', 120),
	(default, 2, 'Screen A', 150);

INSERT INTO cinema_app.seats (seat_id, screen_id, seat_number, seat_type) 
VALUES
	(default, 1, 'A1', 'VIP'),
	(default, 1, 'A2', 'Regular'),
	(default, 2, 'B1', 'Regular');

INSERT INTO cinema_app.showtimes (showtime_id, screen_id, movvie_id, start_time, end_time, price)
VALUES
	(default, 1, 1, '2024-01-10 14:00:00', '2024-01-10 16:30:00', 10.00),
	(default, 2, 2, '2024-01-11 18:00:00', '2024-01-11 20:30:00', 12.50),
	(default, 3, 3, '2024-01-12 20:00:00', '2024-01-12 23:15:00', 15.00);

INSERT INTO cinema_app.bookings (booking_id, user_id, showtime_id, booking_date, total_price, status)
VALUES
	(default, 1, 1, '2024-01-05 10:00:00', 10.00, 'confirmed'),
	(default, 2, 2, '2024-01-06 11:30:00', 25.00, 'pending'),
	(default, 3, 3, '2024-01-07 15:45:00', 15.00, 'canceled');

INSERT INTO cinema_app.booking_details (booking_detail_id, booking_id, seat_id, price)
VALUES
	(default, 1, 1, 10.00),
	(default, 2, 2, 12.50),
	(default, 3, 3, 15.00);

INSERT INTO cinema_app.payments (payment_id, booking_id, payment_date, amount, payment_method, status)
VALUES
	(default, 1, '2024-01-05 10:15:00', 10.00, 'Credit Card', 'completed'),
	(default, 2, '2024-01-06 11:45:00', 25.00, 'PayPal', 'completed'),
	(default, 3, '2024-01-07 16:00:00', 15.00, 'Cash', 'failed');

select * from cinema_app.users; 

select * from cinema_app.movies;

select * from cinema_app.cinemas;

select * from cinema_app.screens;

select * from cinema_app.seats;

select * from cinema_app.showtimes;

select * from cinema_app.bookings;

select * from cinema_app.booking_details;

select * from cinema_app.payments;

-- SQL Tasks for Database - Operators, WHERE, DISTINCT, ORDER BY, LIKE, and Aliases

-- Task 1: Operators

select * from cinema_app.users
where user_id > 1
	And role in ('customer', 'admin');

select * from cinema_app.movies
where rating between 7 and 9  
	and duration_minutes > 90;

select * from cinema_app.bookings
where total_price >= 10
	and status <> 'canceled'; 

select * from cinema_app.payments
where amount > 100
	or payment_method = 'PayPal';

-- Task 2: Where

select * from cinema_app.users
where email like '%gmail.com';

select * from cinema_app.movies
where rating < 9  
	or rating = 8;

select * from cinema_app.bookings
where user_id = 3;

select * from cinema_app.showtimes
where movvie_id = 2 
	and extract(hour from start_time) >= 18;

-- Task 3: Distinct

select distinct genre as movie_gene from cinema_app.movies;

select distinct location as cinema_location from cinema_app.cinemas;

select distinct status as booking_status from cinema_app.bookings;

select distinct start_time as movie_start_time from cinema_app.showtimes;

-- Task 4: Order by

select * from cinema_app.users
order by created_at desc, name asc;

select * from cinema_app.movies
order by release_date asc;

select * from cinema_app.bookings
order by total_price desc;

select * from cinema_app.payments
order by payment_date desc;

-- Task 5: Like

select * from cinema_app.users
where name like 'A%'
	or name like 'B%';

select * from cinema_app.movies
where description like '%the%';

select * from cinema_app.bookings
where to_char(booking_date, 'YYYY-MM-DD') like '2024%';

select * from cinema_app.cinemas
where name like '%Theater';

-- Task 6: Aliases

select user_id User_Id, name Full_Name, email Email_Address from cinema_app.users;
-- biz katta harf bilan yozsakda postgresql uni kichik harf qilib yozadi comumn nomlarida 
	-- ham bu holatni korish mumkin
	-- elon qilmoqchi bulgan column orasida space bulmasligi kerak
select title  as movie_title, release_date release__date, rating viewer_rating from cinema_app.movies;

select booking_date as bookind_date_in_booking, status as booking_status,
	total_price as amount_paid from cinema_app.bookings;

select start_time as show_start_time, price as ticket_price, screen_id as screen_id_screen 
	from cinema_app.showtimes;

