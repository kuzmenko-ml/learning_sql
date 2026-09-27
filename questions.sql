SELECT g.name AS genre_name, al.title AS album_title, t.name AS track_name, ar.name AS artist_name
FROM track t
INNER JOIN album al ON al.albumid = t.albumid
INNER JOIN artist ar ON ar.artistid = al.artistid 
INNER JOIN genre g ON g.genreid = t.genreid
WHERE g.name = 'Pop';

SELECT t.name AS song_name, al.title AS album_title, g.name AS genre, a.name AS artist
FROM track t
INNER JOIN album al ON al.albumid = t.albumid
INNER JOIN genre g ON g.genreid = t.genreid
INNER JOIN artist a ON a.artistid = al.artistid
WHERE a.name = 'AC/DC';

-- Тут CTE тобто віконна функція яка допомагає розвантажити складну задачу.
-- Результат запиту це таблиця, вона не існує в БД. Але до цієї таблиці-результату можна писати інший запит.
WITH country_track_counts AS (
	SELECT 
			i.billingcountry AS country,
			t.name AS track_name, COUNT(il.trackid) AS purchase_count
	FROM invoice i
	INNER JOIN invoiceline il ON il.invoiceid = i.invoiceid
	INNER JOIN track t ON t.trackid = il.trackid
	WHERE i.invoicedate BETWEEN '2012-01-01' AND '2012-12-31'
	GROUP BY i.billingcountry, t.name
)
-- Ось це якраз і є запит із підзапитом до тимчасової таблиці.
SELECT country, track_name, purchase_count
FROM country_track_counts
WHERE purchase_count = (
    SELECT MAX(sub.purchase_count)
    FROM country_track_counts sub
    WHERE sub.country = country_track_counts.country
)
ORDER BY purchase_count DESC;
-- Перший запит допоміжний, щоб я зорієнтувалась як писати другий(основне завдання)
SELECT SUM(total)
FROM invoice
WHERE EXTRACT(YEAR FROM invoicedate) = '2009'
LIMIT 10;

SELECT EXTRACT(YEAR FROM invoicedate) AS year, SUM(total)
FROM invoice
GROUP BY EXTRACT(YEAR FROM invoicedate)
ORDER BY EXTRACT(YEAR FROM invoicedate);
-- Наступний запит. Два варіанта виконаня. Спочатку перша частина завдання Q5. (Яка країна заробила більше?)
WITH country_total AS (
	SELECT billingcountry AS country, SUM(total) AS income
	FROM invoice 
	WHERE EXTRACT(YEAR FROM invoicedate) = '2011'
	GROUP BY country
)

SELECT country, income 
FROM country_total
ORDER BY income DESC
LIMIT 1;
-- Ось тут виконання завдання повністтю (CTE залишається без змін), але в результаті немає відображення назви країни.
-- Тут відображається найбільша сума яку заробила країна. Потім загалом скільки дохід за рік. А також розрахунок 
-- (від загального доходу скільки відсотків дохід цієї країни)
SELECT MAX(income) AS top_income,
	   SUM(income) AS total_income, 
       (MAX(income) / SUM(income)) * 100.0 AS percentage
FROM country_total;
-- Тут нарешті розібралась як вивести все разом (без колонки із загальним доходом, який і не треба виводити, 
-- бо значення потрібне тільки у розрахунку). Країна, її дохід (який є найбільшим), відсоток від загального доходу.
SELECT 
    country,
    income,
    (income / (SELECT SUM(income) FROM country_total)) * 100.0 AS percentage
FROM country_total
ORDER BY income DESC
LIMIT 1;