
-- **************************************** --

------ ********* PRINCIPIANTE ------ *********

-- Mostrar los nombres y apellidos de los clientes que viven en 'USA'.
SELECT FirstName, LastName FROM customers
WHERE Country = 'USA';

-- Contar cuántos clientes hay en cada país.
SELECT COUNT(*) as Cantidad, Country FROM customers
GROUP BY Country
ORDER BY Cantidad DESC;

-- Obtener una lista de todas las canciones (tracks) y sus precios.
SELECT Name AS Nombre,
        UnitPrice AS 'Precio (USD)'  
        FROM tracks;

-- Mostrar los nombres de todas las playlists disponibles.
SELECT Name FROM playlists;

-- Listar todas las canciones que pertenecen al género 'Rock'.
SELECT tracks.TrackId, tracks.Name, genres.Name
FROM tracks
INNER JOIN genres 
ON genres.GenreId = tracks.GenreId
WHERE genres.Name = 'Rock';


-- Obtener el nombre de los artistas en orden alfabético.
SELECT Composer FROM tracks
WHERE Composer IS NOT NULL
ORDER BY Composer;

--Encontrar todas las canciones que duran más de 5 minutos (300,000 milisegundos).
SELECT * FROM tracks
WHERE Milliseconds > 300000;

-- Listar los nombres de las canciones que están en la playlist llamada 'Rock 101'.

-- Contar cuántas playlists existen en la base de datos.
SELECT COUNT(*) AS 'Cantidad Playlists'
    FROM playlists;

-- Obtener la dirección y el email de todos los clientes en Canadá.
SELECT Address, Email
    FROM customers
    WHERE Country = 'Canada';

-- Mostrar las canciones con precios mayores a 0.99.
SELECT Name, UnitPrice AS Price 
    FROM tracks
    WHERE Price > 0.99;

-- Listar las 10 canciones más largas en términos de duración.
SELECT *
    FROM tracks
    ORDER BY Milliseconds DESC
    LIMIT 10;


-- Encontrar todas las canciones que no tienen compositor registrado.
SELECT *
    FROM tracks
    WHERE Composer IS NULL;

-- Obtener el nombre y apellido del empleado que tiene el título de 'Sales Support Agent'.
SELECT  FirstName AS Nombre,
        LastName AS Apellido,
        Title AS Puesto
    FROM employees
    WHERE Title = 'Sales Support Agent';



--Listar todas las canciones junto con su género y tipo de medio (media type).
SELECT tracks.Name AS Song, 
       genres.Name AS Gener,
       media_types.Name AS Type
    FROM tracks
    INNER JOIN genres 
    ON genres.GenreId = tracks.GenreId
    INNER JOIN media_types
    ON media_types.MediaTypeId = tracks.MediaTypeId;


--Identificar todos los clientes que tienen el mismo nombre.
SELECT FirstName, LastName, 
        COUNT(*) AS Count
    FROM customers
    GROUP BY FirstName
    HAVING Count > 1;

--Mostrar todos los álbumes y los artistas que los produjeron.
SELECT albums.AlbumId ,albums.Title, artists.Name
    FROM albums
    INNER JOIN artists
    ON artists.ArtistId = albums.ArtistId;

--Obtener los nombres de los géneros disponibles en orden alfabético.
SELECT *
    FROM genres
    ORDER BY Name ASC;

-- Listar las 5 canciones más baratas.
SELECT Name, UnitPrice
    FROM tracks
    ORDER BY UnitPrice ASC
    LIMIT 5;


-- **************************************** --

------ ********* INTERMEDIO ------ *********


-- Mostrar el número total de canciones en cada género.
SELECT genres.Name AS Gener,
        COUNT(*) AS 'Total Songs'
    FROM tracks
    INNER JOIN genres
    ON genres.GenreId = tracks.GenreId
    GROUP BY Gener;


-- Calcular el precio promedio de las canciones en la base de datos.
SELECT AVG(UnitPrice) AS 'Promedio Precio'
    FROM tracks;

-- Listar los clientes que realizaron más de 10 compras.
SELECT customers.CustomerId, customers.LastName, COUNT(*) AS Count
    FROM invoices
    INNER JOIN customers
    ON customers.CustomerId = invoices.CustomerId
    GROUP BY invoices.CustomerId, customers.LastName
    HAVING Count > 10;

-- Obtener el número total de facturas generadas por cada cliente.
SELECT customers.CustomerId, customers.FirstName, COUNT(*) AS Count
    FROM invoices
    INNER JOIN customers
    ON customers.CustomerId = invoices.CustomerId
    GROUP BY invoices.CustomerId

-- Encontrar las playlists que contienen más de 15 canciones.
SELECT playlist_track.PlaylistId, 
       playlists.Name,
       COUNT(tracks.TrackId) AS Cantidad
    FROM playlists
    INNER JOIN playlist_track
        ON playlist_track.PlaylistId = playlists.PlaylistId
    INNER JOIN tracks
        ON tracks.TrackId = playlist_track.TrackId
    GROUP BY playlist_track.PlaylistId
    HAVING Cantidad > 15;

-- Calcular los ingresos totales generados por cada cliente.
SELECT  invoices.InvoiceId,
        customers.FirstName,
        SUM(invoices.Total) AS Total_Revenue
    FROM invoices
    INNER JOIN customers
        ON customers.CustomerId = invoices.CustomerId
    GROUP BY customers.CustomerId, customers.FirstName;

-- Mostrar las canciones más vendidas y cuántas unidades se vendieron.
SELECT  t.Name AS Song,
        SUM(ii.Quantity) AS suma
    FROM invoice_items AS ii
    INNER JOIN tracks AS t
        ON t.TrackId = ii.TrackId
    GROUP BY t.TrackId, t.Name
    ORDER BY suma DESC;

-- Obtener el nombre de los artistas que tienen más de 5 álbumes.
SELECT  artists.Name AS Artist, 
        COUNT(albums.AlbumId) AS AlbumCount
    FROM artists
    INNER JOIN albums 
        ON artists.ArtistId = albums.ArtistId
    GROUP BY artists.ArtistId
    HAVING COUNT(albums.AlbumId) > 5;


-- Listar los empleados junto con el número de clientes asignados a ellos.
SELECT e.LastName AS Name_Employ,
        COUNT(*)
    FROM customers AS c
    INNER JOIN employees AS e
        ON e.EmployeeId = c.SupportRepId 
    GROUP BY c.SupportRepId

-- Calcular el ingreso total generado por cada género.
SELECT  genres.Name,
        SUM(i.UnitPrice) AS Ganancias
    FROM tracks AS t
    INNER JOIN invoice_items AS i
        ON i.TrackId = t.TrackId
    INNER JOIN genres
        ON genres.GenreId = t.GenreId
    GROUP BY t.GenreId 
    ORDER BY Ganancias DESC;


-- **************************************** --

------ ********* AVANZADO ------ *********


-- Determinar cuál género generó los mayores ingresos.
SELECT  genres.Name,
        SUM(i.UnitPrice) AS Ganancias
    FROM tracks AS t
    INNER JOIN invoice_items AS i
        ON i.TrackId = t.TrackId
    INNER JOIN genres
        ON genres.GenreId = t.GenreId
    GROUP BY t.GenreId 
    ORDER BY Ganancias DESC
    LIMIT 1;

-- Obtener el top 5 de los clientes que han gastado más dinero.
SELECT  c.LastName,
        c.FirstName,
        SUM(i.Total) AS Total
    FROM invoices AS i
    INNER JOIN customers AS c
        ON c.CustomerId = i.CustomerId
    GROUP BY i.CustomerId
    ORDER BY Total DESC
    LIMIT 5;

-- Encontrar los álbumes que contienen canciones de más de un género.
SELECT  t.AlbumId,
        a.Title AS 'Title Album',
        COUNT(DISTINCT GenreId) AS 'Generos diferentes'
    FROM tracks AS t
    INNER JOIN albums AS a
        ON a.AlbumId = t.AlbumId
    GROUP BY t.AlbumId
    HAVING COUNT(DISTINCT GenreId)>1;

-- Calcular la duración total de las canciones en cada playlist.
SELECT   p.Name AS name_Play,
        SUM(t.Milliseconds)/60000 AS Minutos
    FROM playlist_track AS pt
    INNER JOIN tracks AS t
        ON t.TrackId = pt.TrackId
    INNER JOIN playlists AS p 
        ON p.PlaylistId = pt.PlaylistId 
    GROUP BY p.Name 


-- Mostrar el top 5 de los artistas que tienen más canciones disponibles.
SELECT  ar.Name AS Artist,
        COUNT(t.TrackId) AS Songs
    FROM tracks AS t
    INNER JOIN albums AS a
        ON a.AlbumId = t.AlbumId
    INNER JOIN artists AS ar 
        ON ar.ArtistId  = a.ArtistId
    GROUP BY a.ArtistId
    ORDER BY Songs DESC
    LIMIT 5;


-- Obtener las playlists con las canciones más caras (promedio de precio).
SELECT  p.Name,
        AVG(t.UnitPrice) AS avg_price
    FROM playlists AS p
    INNER JOIN playlist_track AS pt 
        ON pt.PlaylistId = p.PlaylistId
    INNER JOIN tracks AS t 
        ON t.TrackId = pt.TrackId
    GROUP BY p.PlaylistId, p.Name
    ORDER BY avg_price DESC;

-- Encontrar al cliente con el mayor número de canciones compradas de un solo género.
SELECT i.CustomerId,
       c.FirstName,
       c.LastName,
       g.Name AS Gener,
       COUNT(*) AS TotalSongs
    FROM invoice_items AS ii 
    INNER JOIN tracks AS t 
        ON t.TrackId = ii.TrackId
    INNER JOIN invoices AS i
        ON i.InvoiceId = ii.InvoiceId
    INNER JOIN customers AS c
        ON c.CustomerId = i.CustomerId
    INNER JOIN genres AS g 
        ON g.GenreId = t.GenreId
    GROUP BY i.CustomerId, c.FirstName, c.LastName, g.Name
    ORDER BY TotalSongs DESC
    LIMIT 1;


-- Identificar si algún cliente no ha realizado compras y mostrar sus datos.

SELECT c.CustomerId, c.FirstName, c.LastName, c.Email
FROM customers AS c 
LEFT JOIN invoices AS i 
    ON i.CustomerId = c.CustomerId
WHERE i.CustomerId IS NULL;


SELECT COUNT(*) AS total_clientes FROM customers;

SELECT COUNT(DISTINCT CustomerId) AS clientes_con_compras FROM invoices;

SELECT c.CustomerId, c.FirstName, c.LastName, c.Email
FROM customers AS c
WHERE NOT EXISTS (
    SELECT 1 FROM invoices i WHERE i.CustomerId = c.CustomerId
);

-- Determinar cuántas canciones fueron vendidas en cada ciudad.
SELECT i.BillingCity,
        COUNT(t.TrackId) AS Songs
    FROM invoices AS i
    INNER JOIN invoice_items AS ii 
        ON ii.InvoiceId = i.InvoiceId
    INNER JOIN tracks AS t 
        ON t.TrackId = ii.TrackId
    GROUP BY i.BillingCity
    ORDER BY Songs DESC;



-- Construir una consulta que muestre todos los ingresos generados por cada artista, basados en la venta de sus canciones.

SELECT ar.Name AS Artist,
        COUNT(DISTINCT t.TrackId) AS Canciones,
        SUM(ii.UnitPrice) AS Total
    FROM invoice_items AS ii 
    INNER JOIN tracks AS t 
        ON t.TrackId = ii.TrackId
    INNER JOIN albums AS a 
        ON a.AlbumId = t.AlbumId
    INNER JOIN artists AS ar 
        ON ar.ArtistId = a.ArtistId
    GROUP BY ar.Name, ar.ArtistId
    ORDER BY Total DESC;


