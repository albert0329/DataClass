use sakila;

/* 1a */
SELECT first_name, last_name
FROM actor;

/* 1b */
SELECT concat(upper(first_name), ' ', upper(last_name))
AS 'Actor Name'
FROM actor;

/*2a*/
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

/*2b*/
SELECT *
FROM actor
WHERE last_name
LIKE '%GEN%';

/*2c*/
SELECT last_name, first_name
FROM actor
WHERE last_name
LIKE '%LI%';

/*2d*/
SELECT country_id, country
FROM country
WHERE country
IN ('Afghanistan', 'Bangladesh', 'China');

/*3a*/
ALTER TABLE actor
ADD COLUMN description BLOB
AFTER last_name;

SELECT * FROM actor;

/*3b*/
ALTER TABLE actor
DROP COLUMN description;

SELECT * FROM actor;

/*4a*/
SELECT last_name, COUNT(*) AS 'Count'
FROM actor
GROUP BY last_name;

/*4b*/
SELECT last_name, COUNT(*) AS 'Count'
FROM actor
GROUP BY last_name
HAVING Count > 2;

/*4c*/
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

SELECT *
FROM actor
Where first_name = 'HARPO';

/*4d*/

UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

SELECT *
FROM actor
Where first_name = 'GROUCHO';

/*5a*/
DESCRIBE address;

/*6a*/
SELECT first_name, last_name, address
FROM staff
JOIN address
USING (address_id); 

/*6b - I tried 2 different methods, both results came back the same*/
SELECT first_name, last_name, sum(amount) as 'total_rental_amount'
FROM staff
JOIN payment
USING (staff_id)
GROUP BY first_name, last_name;

SELECT s.first_name, s.last_name, sum(p.amount) as 'total_rental_amount'
FROM staff s
JOIN payment p
ON s.staff_id = p.staff_id
GROUP BY first_name, last_name;

/*6c*/
SELECT f.title, count(act.actor_id) as 'number_of_actors'
FROM film f
JOIN film_actor act
ON f.film_id = act.film_id
GROUP BY f.title;

/*6d*/
SELECT count(*)
FROM inventory
WHERE film_id
IN (SELECT film_id FROM film WHERE title = 'Hunchback Impossible');

SELECT film_id
FROM film
WHERE title = 'Hunchback Impossible';

SELECT count(film_id)
FROM inventory
WHERE film_id = 439;

/* There are 6 copies of the film 'Hunchback Impossible' in inventory */

/*6e*/
SELECT c.first_name, c.last_name, sum(p.amount) as 'total_paid'
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY first_name, last_name
ORDER BY last_name;

/*7a*/
SELECT title FROM film
WHERE (title like 'K%' OR title like 'Q%') AND language_id = (SELECT language_id FROM language WHERE name = 'English');

/*7b*/
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
	SELECT actor_id FROM film_actor
    WHERE film_id IN
    (
		SELECT film_id FROM film
        WHERE title = 'Alone Trip'
	)
);

/*7c*/
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN
(
	SELECT address_id FROM address
    WHERE city_id IN
    (
		SELECT city_id FROM city
        WHERE country_id IN
        (
			SELECT country_id FROM country
            WHERE country = 'Canada'
		)
	)
);

/*7d*/

SELECT title
FROM film
WHERE film_id IN
(
	SELECT film_id FROM film_category
    WHERE category_id IN
    (
		SELECT category_id FROM category
        WHERE name = 'Family'
	)
);

/*7e*/
SELECT title, count(f.film_id) as 'rental_count'
FROM film f
JOIN inventory i 
ON f.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
GROUP BY title
ORDER BY rental_count DESC;

/*7f*/
SELECT s.store_id, sum(p.amount)
FROM payment p
JOIN staff s
ON p.staff_id = s.staff_id
GROUP BY store_id;

/*7g*/
SELECT store_id, city, country
FROM store s
JOIN address a
ON s.address_id = a.address_id
JOIN city ct
ON a.city_id = ct.city_id
JOIN country cy
ON ct.country_id = cy.country_id;

/*7h*/
SELECT c.name, sum(p.amount) AS 'category_total_rev'
FROM payment p
JOIN rental r
ON p.customer_id = r.customer_id
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film_category film_c
ON i.film_id = film_c.film_id
JOIN category c
ON film_c.category_id = c.category_id
GROUP BY c.name
ORDER BY category_total_rev DESC
LIMIT 5;

/*8a*/
CREATE VIEW gross_rev_view_table AS
SELECT c.name AS 'Genre', sum(p.amount) AS 'category_total_rev'
FROM payment p
JOIN rental r
ON p.customer_id = r.customer_id
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film_category film_c
ON i.film_id = film_c.film_id
JOIN category c
ON film_c.category_id = c.category_id
GROUP BY c.name
ORDER BY category_total_rev DESC
LIMIT 5;

/*8b*/
SELECT * FROM gross_rev_view_table;

/*8c*/
DROP VIEW IF EXISTS gross_rev_view_table;







