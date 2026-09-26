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