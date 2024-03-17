USE sakila;

-- Step 1: Create a View
CREATE VIEW customer_rental_summary AS 
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM
    customer c
LEFT JOIN
    rental r ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id, c.first_name, c.last_name, c.email;

SELECT *
FROM customer_rental_summary;


-- Step 2: Create a Temporary Table
CREATE TEMPORARY TABLE temp_total_paid AS
SELECT
    crs.customer_id,
    SUM(p.amount) AS total_paid
FROM
    customer_rental_summary crs
LEFT JOIN
    payment p ON crs.customer_id = p.customer_id
GROUP BY
    crs.customer_id;

SELECT * FROM temp_total_paid;



-- Step 3: Create a CTE and the Customer Summary Report
WITH customer_summary AS (
    SELECT
        crs.customer_name,
        crs.email,
        crs.rental_count,
        ttp.total_paid
    FROM
        customer_rental_summary crs
    LEFT JOIN
        temp_total_paid ttp ON crs.customer_id = ttp.customer_id
)

SELECT
    customer_name,
    email,
    rental_count,
    total_paid
FROM
    customer_summary;



