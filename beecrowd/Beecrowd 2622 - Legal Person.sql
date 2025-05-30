select c.name
FROM customers C
INNER JOIN legal_person l
ON c.id = l.id_customers;
