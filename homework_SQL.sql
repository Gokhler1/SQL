#1a
select first_name , last_name from actor;

#1b  
SELECT CONCAT(first_name, " ", last_name) as Actor_Name from actor ;

#2A 
select actor_id , first_name , last_name from actor
where first_name = "JOE" ;

#2B
select first_name , last_name from actor
WHERE last_name LIKE '%GEN%';

#2C
Select first_name , last_name from actor
WHERE last_name LIKE '%LI%'
order by last_name , first_name;

#2d
select country_id , country from country
where country in ('Afghanistan', 'Bangladesh', 'China');

#3A
ALTER TABLE actor
ADD DESCRIPTION blob;

#3B
ALTER TABLE actor
DROP COLUMN DESCRIPTION;

#4A
select last_name , count(actor_id) from actor
group by last_name;

#4B
select last_name , count(actor_id) as number_of_actors from actor
group by last_name
HAVING COUNT(actor_id) >= 2;

#4c 
UPDATE actor
SET first_name = 'HARPO'
where first_name = 'GROUCHO' AND last_name = 'WILLIAMS' ;

#4D
UPDATE actor
SET first_name = 'GROUCHO'
where first_name = 'HARPO' AND last_name = 'WILLIAMS';

#5Aaddress
CREATE TABLE Address (
    address_id int,
    address varchar(255)
);

#6A
SELECT staff.first_name , staff.last_name , address.address FROM address
INNER JOIN staff ON staff.address_id=address.address_id;

#6B
select staff.staff_id , staff.first_name , staff.last_name  ,sum(payment.amount) from staff
INNER JOIN payment ON payment.staff_id=staff.staff_id
where date (payment_date) >= '2005-08-01' and date (payment_date) < '2005-09-01'
group by staff.staff_id;

#6C 
select film.title , count(film_actor.actor_id) from film
INNER JOIN film_actor ON film.film_id= film_actor.film_id
group by film.title;

#6D
SELECT count(INVENTORY.film_id) FROM INVENTORY
INNER JOIN FILM ON film.film_id= INVENTORY.film_id
WHERE FILM.TITLE = 'Hunchback Impossible';

#6E
select CUSTOMER.first_name , CUSTOMER.last_name , sum(payment.amount) from customer
join payment on customer.customer_id = payment.customer_id 
group by CUSTOMER.customer_id
order by CUSTOMER.last_name;

#7a
select film.title from language
join film on language.language_id = film.language_id
where language.name= 'english' and (film.title like 'q%' or film.title like 'k%');


#7B	
SELECT actor.first_name , actor.last_name
FROM ((film_actor
INNER JOIN film ON film_actor.film_id = film.film_id)
INNER JOIN actor ON film_actor.actor_id = actor.actor_id)
where film.title = 'Alone Trip';

#7C
select customer.first_name , customer.last_name , customer.email , aaa.country from customer
join 
(select country.country,address.city_id , address.address_id from ((city
			 join country on city.country_id = country.country_id) 
			 join address on city.city_id=address.city_id )) as aaa
on customer.address_id = aaa.address_id
where aaa.country = 'canada';

#7D
select film.title  , category.name from ((film_category 
join film on film_category.film_id = film.film_id)
join category on film_category.category_id = category.category_id)
where category.name = 'family'; 

#7E
select film.title , count(rental_id)  from ((inventory 
join film on inventory.film_id = film.film_id)
join rental on inventory.inventory_id = rental.inventory_id)
group by film.title 
order by 2 desc;

#7F
select store.store_id , sum(payment.amount) from ((customer
join store on customer.store_id = store.store_id)
join payment on customer.customer_id = payment.customer_id )
group by store.store_id;

#7G
select store.store_id , city_country_address.city ,city_country_address.country from store
join (
	select city_country.city_id , city_country.city , city_country.country , address.address_id 
	from address
	join (select country.country_id , city.city_id ,  country.country ,city.city from country 
		join city on city.country_id  = country.country_id ) as city_country 
on address.city_id = city_country.city_id) as city_country_address

on store.address_id = city_country_address.address_id;

#7H
select  customer_category.category_id ,
        customer_category.name ,
        sum(payment.amount)
from payment 
join 
(select  film_category_name_inventory.film_id ,
		film_category_name_inventory.category_id ,
        film_category_name_inventory.name ,
        film_category_name_inventory.inventory_id , 
        rental.customer_id
from rental 
join 
(select film_category_name.film_id , film_category_name.category_id , film_category_name.name , inventory.inventory_id 
from inventory 
join 
(select film_category.film_id , category.category_id , category.name from category 
join film_category on category.category_id = film_category.category_id) as film_category_name 
on inventory.film_id = film_category_name.film_id) as film_category_name_inventory
on rental.inventory_id = film_category_name_inventory.inventory_id ) as customer_category
on payment.customer_id = customer_category.customer_id

group by 1
order by 3 desc
limit 5 ;

#8A

create view `top_five_genres`  as 
select  customer_category.category_id ,
        customer_category.name ,
        sum(payment.amount) as Total
from payment 
join 
(select  film_category_name_inventory.film_id ,
		film_category_name_inventory.category_id ,
        film_category_name_inventory.name ,
        film_category_name_inventory.inventory_id , 
        rental.customer_id
from rental 
join 
(select film_category_name.film_id , film_category_name.category_id , film_category_name.name , inventory.inventory_id 
from inventory 
join 
(select film_category.film_id , category.category_id , category.name from category 
join film_category on category.category_id = film_category.category_id) as film_category_name 
on inventory.film_id = film_category_name.film_id) as film_category_name_inventory
on rental.inventory_id = film_category_name_inventory.inventory_id ) as customer_category
on payment.customer_id = customer_category.customer_id

group by 1
order by 3 desc
limit 5  ;

#8B
select * from `top_five_genres`;

#8C
DROP VIEW `top_five_genres`;