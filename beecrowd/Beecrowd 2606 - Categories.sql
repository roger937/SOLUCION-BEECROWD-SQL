SELECT products.id, products.name
FROM products, categories
WHERE categories.name LIKE 'super%' AND products.id_categories=categories.id
