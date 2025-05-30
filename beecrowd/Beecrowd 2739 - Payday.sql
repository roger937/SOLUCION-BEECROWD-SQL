SELECT name, cast(EXTRACT(day from payday) AS INT) AS day
FROM loan;
