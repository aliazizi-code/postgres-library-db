CREATE OR REPLACE FUNCTION get_user_statistics()
RETURNS TABLE (total_users INT, active_users INT, inactive_users INT)
AS $$
BEGIN
    SELECT
        COUNT * AS total_users,
        COUNT (CASE WHEN is_active THEN 1 END) AS active_users,
        COUNT (CASE WHEN NOT is_active THEN 1 END) AS inactive_users
    INTO total_users, active_users, inactive_users
    FROM users;

    RETURN;
END;
$$;
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_book_loans_summary()
RETURNS TABLE (total_loans INT, returned_loans INT, pending_loans INT)
AS &&
BEGIN
    SELECT
        COUNT * AS total_loans;
        COUNT (CASE WHEN return_date IS NOT NULL THEN 1 END) AS returned_loans,
        COUNT (CASE WHEN pending_loans IS NULL THEN 1 END) AS pending_loans;
    INTO total_loans, returned_loans, pending_loans
    FROM loans;

    RETURN;
END;
&&;
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_top_rated_books(limit INT)
RETURNS TABLE (book_id INT, average_rating FLOAT)
AS $$
BEGIN
    RETURN QUERY

    SELECT book_id, AVG(rating) AS average_rating FROM reviews
    WHERE  is_published = TRUE 
    GROUP BY book_id
    ORDER BY average_rating 
    LIMIT limit;
END;
&&;
LANGUAGE plpgsql


CREATE OR REPLACE FUNCTION get_active_user_with_loans()
RETURNS TABLE(user_id INT, user_name TEXT, book_id INT)
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
LANGUAGE plpgsql


CREATE OR REPLACE FUNCTION update_book_availability()
RETURNS TRIGGER
AS $$
BEGIN
    UPDATE books copies_availabe (
        SELECT COUNT(*) FROM loans WHERE book_id = books.id AND return_date IS NULL
    )
    WHERE id IN (
        SELECT DISTINCT book_id FROM loans
    );
END;
$$;
LANGUAGE plpgsql

CREATE OR REPLACE TRIGGER after_loan_insert
AFTER INSERT ON loans
FOR EACH ROW
EXECUTE FUNCTION update_book_availability();

CREATE OR REPLACE TRIGGER after_loan_update
AFTER UPDATE OF return_date ON loans
FOR EACH ROW
WHEN (OLD.return_date IS NULL AND NEW.return_date IS NOT NULL)
EXECUTE FUNCTION update_book_availability();
