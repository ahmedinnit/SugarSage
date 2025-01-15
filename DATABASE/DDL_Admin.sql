USE sugarsage_db;

CREATE TABLE Admins (
	admin_id INT AUTO_INCREMENT UNIQUE PRIMARY KEY,
	Fname VARCHAR(30),
    Lname VARCHAR(30),
    email VARCHAR(50) UNIQUE,
    dob DATE,
    gender CHAR,
    country VARCHAR(30),
    city VARCHAR(30),
    phoneNumber VARCHAR(11),
    password VARCHAR(255),
    status VARCHAR(10),
    profile_picture VARCHAR(300),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login DATETIME DEFAULT CURRENT_TIMESTAMP
);