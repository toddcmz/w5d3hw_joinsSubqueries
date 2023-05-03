-- 1 using joins, list all customers who live in Texas
SELECT concat(first_name, ' ', last_name)
FROM customer
JOIN address
ON customer.address_id = address.address_id 
WHERE address.district = 'Texas';

-- 2 list customer full names for customers with payments above $6.99
SELECT concat(first_name,' ',last_name), amount
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id 
WHERE amount > 6.99;

-- 3 using subqueries, show all customer names 
-- for customers who have over $175 in payments
SELECT first_name, last_name
FROM customer
WHERE customer_id in(
	SELECT customer_id
	FROM payment 
	GROUP BY customer_id 
		HAVING sum(amount) > 175
);

-- 4 list all customers that live in Nepal
SELECT first_name, last_name
FROM customer cus
JOIN address a
ON cus.address_id = a.address_id 
JOIN city cit
ON a.city_id = cit.city_id 
JOIN country co
ON cit.country_id = co.country_id 
WHERE country = 'Nepal';

-- 5 which staff member had the most transactions
-- this was awful, this can't possibly be the best way to get this info...
SELECT first_name, last_name, payment.staff_id, count(payment.staff_id)
FROM payment
JOIN staff
ON payment.staff_id = staff.staff_id
GROUP BY payment.staff_id, first_name, last_name
HAVING count(payment.staff_id)=(
	SELECT max(my_count)
	from(
		SELECT payment.staff_id, count(payment.staff_id) my_count 
		FROM payment
		GROUP BY payment.staff_id
	) innermostQueryCall
);

-- 6 how many movies of each rating are there?
-- this doesn't seem like it needs a join...does it?
-- film has unique movies, so just grouping the rating
-- counts from this table seems sufficient...
SELECT rating, count(rating)
FROM film
GROUP BY rating;

-- 7 show all customers who have made
-- one payment above $6.99
SELECT first_name, last_name
FROM customer
WHERE customer_id in(
	SELECT customer_id 
	from(
		SELECT customer_id, sum(raw_count) AS count_over_threshold
		from(
			SELECT customer_id, amount, count(amount) AS raw_count
			FROM payment 
			GROUP BY amount, customer_id
			HAVING amount > 6.99
		) innerMostQueryCall
		GROUP BY customer_id
	) middleQueryCall
	WHERE count_over_threshold = 1
);

-- 8 how many free rentals are there?
-- doesn't seem to require a join, either...
SELECT count(amount)
FROM payment 
WHERE amount = 0.00;

