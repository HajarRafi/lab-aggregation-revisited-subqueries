use sakila;

-- 1. Select the first name, last name, and email address of all the customers who have rented a movie.

# customer - rental #

SELECT DISTINCT
    (CONCAT(c.first_name, ' ', c.last_name)) AS 'customer',
    c.email
FROM
    sakila.customer c
        JOIN
    sakila.rental r USING (customer_id);
    
-- 2. What is the average payment made by each customer (display the customer id, customer name (concatenated), 
-- and the average payment made).

# customer - payment #

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS 'name',
    ROUND(AVG(p.amount)) AS average_amount
FROM
    sakila.customer c
        JOIN
    sakila.payment p USING (customer_id)
GROUP BY c.customer_id;

-- 3. Select the name and email address of all the customers who have rented the "Action" movies.

/* Write the query using multiple join statements
Write the query using sub queries with multiple WHERE clause and IN condition
Verify if the above two queries produce the same results or not */

# customer - rental - inventory - film_category - category #

-- with multiple joins
SELECT DISTINCT
    (CONCAT(c.first_name, ' ', c.last_name)) AS 'name', c.email
FROM
    sakila.customer c
        JOIN
    sakila.rental r USING (customer_id)
        JOIN
    sakila.inventory i USING (inventory_id)
        JOIN
    sakila.film_category fc USING (film_id)
        JOIN
    sakila.category ca USING (category_id)
WHERE
    ca.name = 'Action'
ORDER BY name;

-- with sub queries
SELECT 
    CONCAT(first_name, ' ', last_name) AS 'name', email
FROM
    sakila.customer
WHERE
    customer_id IN (SELECT 
            customer_id
        FROM
            sakila.rental
        WHERE
            inventory_id IN (SELECT 
                    inventory_id
                FROM
                    sakila.inventory
                WHERE
                    film_id IN (SELECT 
                            film_id
                        FROM
                            sakila.film_category
                        WHERE
                            category_id IN (SELECT 
                                    category_id
                                FROM
                                    sakila.category
                                WHERE
                                    name = 'Action'))))
ORDER BY name;  -- the same result with join

-- 4. Use the case statement to create a new column classifying existing columns as either or high value transactions 
-- based on the amount of payment. If the amount is between 0 and 2, label should be low and 
-- if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.

SELECT 
    *,
    CASE
        WHEN amount BETWEEN 0 AND 2 THEN 'low'
        WHEN amount BETWEEN 2 AND 4 THEN 'medium'
        WHEN amount > 4 THEN 'high'
    END AS amount_classified
FROM
    sakila.payment;



