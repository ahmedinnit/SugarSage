USE sugarsage_db;

CREATE TABLE Foods (
	food_id INT AUTO_INCREMENT UNIQUE PRIMARY KEY,
	food_name VARCHAR(100) UNIQUE NOT NULL,
    food_urdu_name VARCHAR(50),
    category VARCHAR(60) NOT NULL,
    -- season VARCHAR(30),
    `energy (kCal)` INT NOT NULL,	
    `fats (g)` DECIMAL(4, 1) NOT NULL, 
    `proteins (g)` DECIMAL(4, 1) NOT NULL,
    `carbs (g)` DECIMAL(4, 1) NOT NULL,
    GI INT NOT NULL,
    GL INT NOT NULL
);

CREATE TABLE Feedbacks(
	feedback_id INT AUTO_INCREMENT UNIQUE PRIMARY KEY,
    user_id INT,
    feedback_type VARCHAR(10),
    feedback_topic VARCHAR(60),
    feedback_title VARCHAR(150),
    description VARCHAR(2000),
    created_at TIME,
    date DATE
);

CREATE TABLE Blogs(
	blog_id INT AUTO_INCREMENT UNIQUE PRIMARY KEY,
    blog_author VARCHAR(50),
    blog_title VARCHAR(150),
    blog_description VARCHAR(500),
    source_url VARCHAR(150),
    image_url VARCHAR(500),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);