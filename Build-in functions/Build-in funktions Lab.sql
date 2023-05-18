SELECT 
    id, title
FROM
    books
WHERE
    title LIKE ('the%');

SELECT 
    id, REPLACE(title, 'The', '***')
FROM
    books
WHERE
    SUBSTRING(title, 1, 3) = 'the';

SELECT 
    id, title
FROM
    books
WHERE
    SUBSTRING(title, 1, 3) = 'the';

SELECT 
    ROUND(SUM(cost), 2)
FROM
    books;

SELECT 
    first_name, TIMESTAMPDIFF(YEAR, born, NOW())
FROM
    authors;

SELECT 
    *
FROM
    books
WHERE
    title LIKE ('Harry Potter%')