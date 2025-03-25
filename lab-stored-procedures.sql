/*
### Instructions
Write queries, stored procedures to answer the following questions:
*/
use sakila;

-- In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented `Action` movies. Convert the query into a simple stored procedure. Use the following query:
    select first_name, last_name, email
    from customer
    join rental on customer.customer_id = rental.customer_id
    join inventory on rental.inventory_id = inventory.inventory_id
    join film on film.film_id = inventory.film_id
    join film_category on film_category.film_id = film.film_id
    join category on category.category_id = film_category.category_id
    where category.name = "Action"
    group by first_name, last_name, email;

-- step1:

DELIMITER //
create procedure GetActionMovieRenters()
begin
	select first_name, last_name, email
    from customer
    join rental on customer.customer_id = rental.customer_id
    join inventory on rental.inventory_id = inventory.inventory_id
    join film on film.film_id = inventory.film_id
    join film_category on film_category.film_id = film.film_id
    join category on category.category_id = film_category.category_id
    where category.name = "Action"
    group by first_name, last_name, email;          
end;
//
delimiter ;        
        
CALL GetActionMovieRenters();
        
-- Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. For eg., it could be `action`, `animation`, `children`, `classics`, etc.

drop procedure if exists GetActionMovieRenters ;

DELIMITER //
create procedure GetMovieRentersByCategory(IN categoryName VARCHAR(50)) 
begin
	select first_name, last_name, email
    from customer
    join rental on customer.customer_id = rental.customer_id
    join inventory on rental.inventory_id = inventory.inventory_id
    join film on film.film_id = inventory.film_id
    join film_category on film_category.film_id = film.film_id
    join category on category.category_id = film_category.category_id
    where category.name = categoryName
    group by first_name, last_name, email;          
end//
delimiter ;    

CALL GetMovieRentersByCategory('Animation');


-- Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. Pass that number as an argument in the stored procedure.

		-- step 1
SELECT 
    category_id, category.name, COUNT(film_id) AS films_x_cat
FROM
    category
        JOIN
    film_category USING (category_id)
        JOIN
    film USING (film_id)
GROUP BY category_id
HAVING films_x_cat > 60
;
		-- step 2

drop procedure if exists MoviesByCategory;
		
DELIMITER //
CREATE PROCEDURE MoviesByCategory(in nrFilms varchar(10))
SELECT 
    category_id, category.name, COUNT(film_id) AS films_x_cat
FROM
    category
        JOIN
    film_category USING (category_id)
        JOIN
    film USING (film_id)
GROUP BY category_id
HAVING films_x_cat > nrFilms
;
END;
//
DELIMITER ;

CALL MoviesByCategory(68);