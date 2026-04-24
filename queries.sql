-- Завдання 1. Створення бази даних LibraryManagement

CREATE SCHEMA IF NOT EXISTS LibraryManagement;
USE LibraryManagement;

CREATE TABLE authors (
    author_id   INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(255) NOT NULL
);

CREATE TABLE genres (
    genre_id   INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(100) NOT NULL
);

CREATE TABLE books (
    book_id          INT AUTO_INCREMENT PRIMARY KEY,
    title            VARCHAR(255) NOT NULL,
    publication_year YEAR,
    author_id        INT,
    genre_id         INT,
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    FOREIGN KEY (genre_id)  REFERENCES genres(genre_id)
);

CREATE TABLE users (
    user_id  INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email    VARCHAR(255) NOT NULL
);

CREATE TABLE borrowed_books (
    borrow_id   INT AUTO_INCREMENT PRIMARY KEY,
    book_id     INT,
    user_id     INT,
    borrow_date DATE,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


-- Завдання 2. Тестові дані

INSERT INTO authors (author_name) VALUES
    ('George Orwell'),
    ('Frank Herbert');

INSERT INTO genres (genre_name) VALUES
    ('Dystopia'),
    ('Science Fiction');

INSERT INTO books (title, publication_year, author_id, genre_id) VALUES
    ('1984',  1949, 1, 1),
    ('Dune',  1965, 2, 2);

INSERT INTO users (username, email) VALUES
    ('farid_j',   'farid@example.com'),
    ('anna_k',    'anna@example.com');

INSERT INTO borrowed_books (book_id, user_id, borrow_date, return_date) VALUES
    (1, 1, '2024-01-10', '2024-01-24'),
    (2, 2, '2024-02-01', '2024-02-15');


-- Завдання 3. INNER JOIN усіх 8 таблиць (схема mydb_hw_03) та вибір усіх полів (*)

USE mydb_hw_03;

SELECT *
FROM order_details od
    INNER JOIN orders o       ON od.order_id   = o.id
    INNER JOIN customers cu   ON o.customer_id = cu.id
    INNER JOIN products p     ON od.product_id = p.id
    INNER JOIN categories cat ON p.category_id = cat.id
    INNER JOIN employees e    ON o.employee_id = e.employee_id
    INNER JOIN shippers sh    ON o.shipper_id  = sh.id
    INNER JOIN suppliers su   ON p.supplier_id = su.id;


-- Завдання 4.1. Кількість рядків результату

SELECT COUNT(*) AS total_rows
FROM order_details od
    INNER JOIN orders o       ON od.order_id   = o.id
    INNER JOIN customers cu   ON o.customer_id = cu.id
    INNER JOIN products p     ON od.product_id = p.id
    INNER JOIN categories cat ON p.category_id = cat.id
    INNER JOIN employees e    ON o.employee_id = e.employee_id
    INNER JOIN shippers sh    ON o.shipper_id  = sh.id
    INNER JOIN suppliers su   ON p.supplier_id = su.id;


-- Завдання 4.2. Відповідь у текстовому вигляді:
-- При заміні INNER JOIN на LEFT або RIGHT JOIN кількість рядків
-- може збільшитися, бо LEFT/RIGHT JOIN включають рядки з однієї
-- таблиці навіть якщо немає відповідності в іншій (NULL замість
-- відсутніх значень). INNER JOIN повертає тільки рядки з
-- відповідністю в обох таблицях, тому дає мінімальну кількість.


-- Завдання 4.3. Фільтр: employee_id > 3 та <= 10

SELECT *
FROM order_details od
    INNER JOIN orders o       ON od.order_id   = o.id
    INNER JOIN customers cu   ON o.customer_id = cu.id
    INNER JOIN products p     ON od.product_id = p.id
    INNER JOIN categories cat ON p.category_id = cat.id
    INNER JOIN employees e    ON o.employee_id = e.employee_id
    INNER JOIN shippers sh    ON o.shipper_id  = sh.id
    INNER JOIN suppliers su   ON p.supplier_id = su.id
WHERE o.employee_id > 3 AND o.employee_id <= 10;


-- Завдання 4.4. Групування за назвою категорії,
--               кількість рядків, середня кількість товару
-- Завдання 4.5. Фільтр: середня кількість товару > 21
-- Завдання 4.6. Сортування за спаданням кількості рядків
-- Завдання 4.7. 4 рядки з пропуском першого (LIMIT 4 OFFSET 1)

SELECT
    cat.name            AS category_name,
    COUNT(*)            AS row_count,
    AVG(od.quantity)    AS avg_quantity
FROM order_details od
    INNER JOIN orders o       ON od.order_id   = o.id
    INNER JOIN customers cu   ON o.customer_id = cu.id
    INNER JOIN products p     ON od.product_id = p.id
    INNER JOIN categories cat ON p.category_id = cat.id
    INNER JOIN employees e    ON o.employee_id = e.employee_id
    INNER JOIN shippers sh    ON o.shipper_id  = sh.id
    INNER JOIN suppliers su   ON p.supplier_id = su.id
WHERE o.employee_id > 3 AND o.employee_id <= 10
GROUP BY cat.name
HAVING AVG(od.quantity) > 21
ORDER BY row_count DESC
LIMIT 4 OFFSET 1;