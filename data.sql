-- Insert authors
INSERT INTO authors (name, date_of_birth, date_of_death, bio, nationality)
VALUES
    ('Jane Austen', '1775-12-16', NULL, 'English novelist known for her six major novels.', 'British'),
    ('Mark Twain', '1835-11-30', '1910-04-21', 'American writer, humorist, and lecturer.', 'American'),
    ('George Orwell', '1903-06-25', '1950-01-21', 'English novelist and essayist.', 'British'),
    ('J.K. Rowling', '1965-07-31', NULL, 'British author, best known for the Harry Potter series.', 'British'),
    ('Isaac Asimov', '1920-01-02', '1992-04-06', 'American author and professor of biochemistry.', 'American');

-- Insert genres
INSERT INTO genres (name)
VALUES
    ('Fiction'),
    ('Non-Fiction'),
    ('Fantasy'),
    ('Science Fiction'),
    ('Romance'),
    ('Mystery'),
    ('Biography'),
    ('Dystopian');

-- Insert books
INSERT INTO books (title, published_year, copies_available, isbn, language, is_published)
VALUES
    ('Pride and Prejudice', '1813-01-28', 5, '978-3-16-148410-0', 'English', TRUE),
    ('Adventures of Huckleberry Finn', '1884-02-18', 3, '978-0-14-243717-9', 'English', TRUE),
    ('1984', '1949-06-08', 4, '978-0-452-28423-4', 'English', TRUE),
    ('Harry Potter and the Philosophers Stone', '1997-06-26', 10, '978-0-7475-3274-9', 'English', TRUE),
    ('Foundation', '1951-06-01', 2, '978-0-553-80371-0', 'English', TRUE);

-- Insert data into books_genres
INSERT INTO books_genres (book_id, gener_id)
VALUES
    (1, 1),  -- Pride and Prejudice -> Fiction
    (1, 5),  -- Pride and Prejudice -> Romance
    (2, 1),  -- Adventures of Huckleberry Finn -> Fiction
    (2, 6),  -- Adventures of Huckleberry Finn -> Adventure
    (3, 1),  -- 1984 -> Fiction
    (3, 4),  -- 1984 -> Dystopian
    (4, 1),  -- Harry Potter and the Philosopher's Stone -> Fiction
    (4, 3),  -- Harry Potter and the Philosopher's Stone -> Fantasy
    (5, 4);  -- Foundation -> Science Fiction


-- Insert users
INSERT INTO users (name, email, phone_number, address, usership_type, date_of_birth)
VALUES
    ('Alice Smith', 'alice@example.com', '09123456789', '123 Main St, Cityville', 'Premium', '1990-05-15'),
    ('Bob Johnson', 'bob@example.com', '09876543210', '456 Elm St, Townsville', 'Basic', '1985-07-20'),
    ('Charlie Brown', 'charlie@example.com', '09112233445', '789 Maple St, Villageburg', 'VIP', '1992-03-10'),
    ('Diana Prince', 'diana@example.com', '09334455678', '321 Oak St, Metropolis', 'Employee', '1980-12-31'),
    ('Eve Adams', 'eve@example.com', '09098765432', '654 Pine St, Gotham', 'Basic', '1995-11-11');

-- Insert loans
INSERT INTO loans (book_id, user_id, due_date, return_date)
VALUES
    (1, 1, '2023-12-01', NULL),
    (2, 2, '2023-12-05', NULL),
    (3, 3, '2023-12-10', '2023-12-08'),
    (4, 4, '2023-12-15', NULL),
    (5, 5, '2023-12-20', NULL);

-- Insert reviews
INSERT INTO reviews (book_id, user_id, rating, comment, is_published)
VALUES
    (1, 1, 9, 'A timeless classic!', TRUE),
    (2, 2, 8, 'Very entertaining and insightful.', TRUE),
    (3, 3, 10, 'A must-read for everyone!', TRUE),
    (4, 4, 7, 'Loved the story and characters.', TRUE),
    (5, 5, 9, 'Science fiction at its best!', TRUE);