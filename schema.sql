CREATE TABLE authors(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    date_of_birth DATE NOT NULL,
    date_of_death DATE,
    bio TEXT,
    nationality VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_authors ON authors(name);


CREATE TABLE genres(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);
CREATE INDEX idx_genre ON genres(name);


CREATE TABLE books(
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    published_year DATE NOT NULL,
    copies_available INT DEFAULT 0,
    isbn VARCHAR(20) CHECK (length(isbn) <= 20 ),
    language VARCHAR(60),
    is_published BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_book_title ON books(title);
CREATE INDEX idx_book_isbn ON books(isbn);
CREATE INDEX idx_book_language ON books(language);


CREATE TABLE books_genres(
    book_id INT REFERENCES books(id) ON DELETE CASCADE,
    gener_id INT REFERENCES genres(id) ON DELETE CASCADE
);

CREATE TABLE users(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone_number VARCHAR(15) UNIQUE CHECK (phone_number ~ '^\(?(9|8|7|6)\)?([0-9]{8}))$'),
    address TEXT,
    usership_type VARCHAR(60) CHECK (usership_type IN ('Basic', 'Premium', 'VIP', 'Employee')) DEFAULT 'Basic' NOT NULL,
    date_of_birth DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    join_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_user_name ON users(name);
CREATE INDEX idx_user_email ON users(email);
CREATE INDEX idx_user_number ON users(phone_number);
CREATE INDEX idx_user_birthday ON users(date_of_birth);
CREATE INDEX idx_user_type ON users(usership_type);


CREATE UNLOGGED TABLE loans(
    id SERIAL PRIMARY KEY,
    book_id INT REFERENCES books(id) ON DELETE CASCADE,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    loan_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    due_date TIMESTAMP NOT NULL,
    return_date TIMESTAMP
);
CREATE INDEX idx_loan_date ON loans(loan_date);
CREATE INDEX idx_load_due ON loans(due_date);
CREATE INDEX idx_load_return ON loans(return_date);


CREATE UNLOGGED TABLE reviews(
    id SERIAL PRIMARY KEY,
    book_id INT REFERENCES books(id) ON DELETE CASCADE,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    rating INT CHECK (rating >= 1 AND rating <= 10) NOT NULL,
    comment TEXT NOT NULL,
    is_published BOOLEAN DEFAULT FALSE,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_review_rating ON reviews(rating);
CREATE INDEX idx_review_comment ON reviews(comment);
CREATE INDEX idx_review_date ON reviews(review_date);
