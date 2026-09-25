SELECT g.name AS genre_name, al.title AS album_title, t.name AS track_name, ar.name AS artist_name
FROM track t
INNER JOIN album al ON al.albumid = t.albumid
INNER JOIN artist ar ON ar.artistid = al.artistid 
INNER JOIN genre g ON g.genreid = t.genreid
WHERE g.name = 'Pop';