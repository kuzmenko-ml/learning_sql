SELECT *
FROM customer
LIMIT 2;

SELECT *
FROM invoiceline
LIMIT 20;

SELECT *
FROM employee
LIMIT 2;

SELECT *
FROM track
LIMIT 2;

SELECT *
FROM album
LIMIT 2;
--
SELECT firstname, lastname, customerid, country
FROM customer
WHERE NOT country ='USA'
LIMIT 5;

SELECT firstname, lastname, customerid, city
FROM customer
WHERE country ='Brazil'
LIMIT 5;

SELECT * 
FROM invoice
WHERE EXTRACT(YEAR FROM invoicedate) = '2011' OR EXTRACT(YEAR FROM invoicedate) = '2013'
ORDER BY invoicedate DESC;

SELECT DISTINCT billingcountry
FROM invoice;
--
SELECT c.firstname, c.lastname, i.invoiceid, i.invoicedate, i.billingcountry
FROM customer c
INNER JOIN invoice i ON i.customerid = c.customerid
WHERE i.billingcountry = 'Brazil';

SELECT e.firstname, c.firstname 
FROM employee e
INNER JOIN customer c ON c.supportrepid = e.employeeid
WHERE title = 'Sales Support Agent';

SELECT t.name, a.title, t.composer
FROM track t
INNER JOIN album a ON a.albumid = t.albumid;

SELECT invoiceid, COUNT(invoiceid)
FROM invoiceline
GROUP BY invoiceid;
--
SELECT g.name, COUNT(t.name)
FROM genre g
INNER JOIN track t ON t.genreid = g.genreid
GROUP BY g.name
HAVING COUNT(t.name) > 50
ORDER BY COUNT(t.name) DESC;
--
SELECT c.city, COUNT(i.invoiceid), SUM(i.total) AS total_invoice
FROM customer c
INNER JOIN invoice i ON i.customerid = c.customerid
WHERE c.country = 'USA'
GROUP BY c.city
HAVING SUM(i.total) > 40
ORDER BY SUM(i.total) DESC;
--
SELECT ar.name, COUNT(t.name) AS track_count
FROM artist ar
INNER JOIN album al ON ar.artistid = al.artistid
INNER JOIN track t ON al.albumid = t.albumid
GROUP BY ar.name
HAVING COUNT(t.name) > 15
ORDER BY track_count DESC, ar.name ASC;
--
SELECT genreid, COUNT(*) AS total_tracks_in_genre
FROM track
GROUP BY genreid
ORDER BY genreid;
--
SELECT 
    name,       
    genreid,    
    COUNT(*) OVER (PARTITION BY genreid) AS total_tracks_in_genre
FROM track
WHERE genreid IN (2, 3, 4, 7) 
ORDER BY genreid, name;
--
SELECT t.name, g.name, SUM(t.unitprice) OVER () AS abc
FROM track t
INNER JOIN genre g ON g.genreid = t.genreid;

SELECT SUM(unitprice) AS total
FROM track;
--
SELECT t.name, g.name, SUM(t.unitprice) OVER (PARTITION BY g.name) AS abc
FROM track t
INNER JOIN genre g ON g.genreid = t.genreid
WHERE NOT g.name = 'Rock';
--
SELECT t.name, g.name, COUNT(t.genreid) OVER (PARTITION BY g.name) AS abc
FROM track t
INNER JOIN genre g ON g.genreid = t.genreid;

SELECT g.name, COUNT(t.genreid)
FROM genre g
INNER JOIN track t ON t.genreid = g.genreid
GROUP BY g.name;
--
SELECT t.name, g.name, SUM(t.unitprice) OVER (PARTITION BY g.name ORDER BY t.name) AS abc
FROM track t
INNER JOIN genre g ON g.genreid = t.genreid
WHERE NOT g.name = 'Rock';
--
SELECT ROW_NUMBER() OVER (PARTITION BY g.name), t.name, g.name, t.milliseconds
FROM track t
INNER JOIN genre g ON g.genreid = t.genreid;
--
SELECT ROW_NUMBER() OVER (PARTITION BY g.name ORDER BY t.milliseconds), t.name, g.name, t.milliseconds
FROM track t
INNER JOIN genre g ON g.genreid = t.genreid;
--
SELECT RANK() OVER (PARTITION BY g.name ORDER BY t.milliseconds), t.name, g.name, t.milliseconds
FROM track t
INNER JOIN genre g ON g.genreid = t.genreid;
--
SELECT 
    RANK() OVER (PARTITION BY g.name ORDER BY t.unitprice) AS rank_a,
    ROW_NUMBER() OVER (PARTITION BY g.name ORDER BY t.unitprice) as row_number_a,
    t.name, 
    g.name, 
    t.unitprice
FROM track t
INNER JOIN genre g ON g.genreid = t.genreid;