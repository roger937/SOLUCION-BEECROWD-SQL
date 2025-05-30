SELECT l.name, round((l.omega * 1.618), 3) AS "The N Factor" 
FROM life_registry l
INNER JOIN dimensions d
ON l.dimensions_id=d.id
WHERE d.name IN ('C875', 'C774') AND l.name LIKE 'Richard%'
ORDER BY l.omega ASC
