CREATE OR REPLACE FUNCTION get_user_statistics()
RETURNS TABLE (total_users INT, active_users INT, inactive_users INT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        COUNT (*) AS total_users,
        COUNT (CASE WHEN is_active THEN 1 END) AS active_users,
        COUNT (CASE WHEN NOT is_active THEN 1 END) AS inactive_users
    FROM users;
END;
$$;


CREATE OR REPLACE FUNCTION get_book_loans_summary()
RETURNS TABLE (total_loans INT, returned_loans INT, pending_loans INT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        COUNT (*) AS total_loans,
        COUNT (CASE WHEN return_date IS NOT NULL THEN 1 END) AS returned_loans,
        COUNT (CASE WHEN pending_loans IS NULL THEN 1 END) AS pending_loans
    FROM loans;
END;
$$;


CREATE OR REPLACE FUNCTION get_top_rated_books(limit_value INT)
RETURNS TABLE (book_id INT, average_rating FLOAT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY

    SELECT book_id, AVG(rating) AS average_rating FROM reviews
    WHERE  is_published = TRUE 
    GROUP BY book_id
    ORDER BY average_rating 
    LIMIT limit_value;
END;
$$;


CREATE OR REPLACE FUNCTION get_active_user_with_loans()
RETURNS TABLE(user_id INT, user_name TEXT, book_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY

    SELECT 
        u.id AS user_id,
        u.name AS user_name,
        l.book_id
    FROM
        users u
    JOIN
        loans l ON u.id = l.user_id
    WHERE
        u.is_active = TRUE AND l.return_date IS NULL;
END;
$$;


CREATE OR REPLACE FUNCTION update_book_availability()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE books
    SET copies_available = (
        SELECT COUNT(*) FROM loans WHERE book_id = books.id AND return_date IS NULL
    )
    WHERE id = NEW.book_id;
    
    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER after_loan_insert
AFTER INSERT ON loans
FOR EACH ROW
EXECUTE FUNCTION update_book_availability();

CREATE OR REPLACE TRIGGER after_loan_update
AFTER UPDATE OF return_date ON loans
FOR EACH ROW
WHEN (OLD.return_date IS NULL AND NEW.return_date IS NOT NULL)
EXECUTE FUNCTION update_book_availability();


CREATE OR REPLACE FUNCTION get_genre_distribution()
RETURNS TABLE (genre_name VARCHAR, genre_count INT, genre_ratio FLOAT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY

    SELECT
        g.name AS genre_name,
        COUNT(bg.book_id) AS genre_count,
        COUNT(bg.book_id) * 1.0 / (SELECT COUNT(*) FROM books) AS genre_ratio
    FROM
        genres g
    LEFT JOIN
        books_genres bg ON g.id = bg.gener_id
    GROUP BY 
        g.id, g.name
    ORDER BY 
        genre_count DESC;

END;
$$;



CREATE OR REPLACE FUNCTION loan_book(user_id INT, book_id INT, due_date TIMESTAMP)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
    IF (SELECT copies_available FROM books WHERE id = book_id) > 0 THEN
        INSERT INTO loans(user_id, book_id, due_date)
        VALUES(user_id, book_id, due_date);
    ELSE 
        RAISE EXCEPTION 'No copies available for the book with ID %', book_id;
    END IF;
END;
$$;


CREATE OR REPLACE FUNCTION calculate_age_authors(birth_date DATE)
RETURNS TABLE (name VARCHAR, date_of_birth DATE, date_of_death DATE, age_death INT, nationality VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY

    SELECT
        name,
        date_of_birth,
        date_of_death,
        COALESCE(
            EXTRACT(
                YEAR FROM AGE(COALESCE(date_of_death, CURRENT_DATE), date_of_birth)
            ), 0
        ) AS age_death,
        nationality
    FROM authors;
END;
$$;