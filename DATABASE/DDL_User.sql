CREATE DATABASE sugarsage_db;
USE sugarsage_db;

CREATE TABLE Users (
	user_id INT AUTO_INCREMENT PRIMARY KEY UNIQUE,
	fname VARCHAR(30),
    Lname VARCHAR(30),
    email VARCHAR(40) UNIQUE,
    dob DATE,
    gender VARCHAR(6),
    country VARCHAR(30),
    city VARCHAR(25),
    phoneNumber VARCHAR(11),
    password VARCHAR(255),	
    profile_picture VARCHAR(300),
    -- password_hash VARCHAR(255),
    status VARCHAR(10),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login DATETIME
);

CREATE TABLE HealthProfile(
	health_id INT AUTO_INCREMENT,
    user_id INT,
    diabetes_type VARCHAR(20),
    `weight (kgs)` DECIMAL(5,2),
    `height (m)` DECIMAL(3,1),
    fasting_sugar_level DECIMAL(5,2),
    post_meal_sugar_level DECIMAL(5,2),
--     insulin_levels DECIMAL(5,2),
    BMI DECIMAL(6,2),
    BMR DECIMAL(5,2),
    HbA1c DECIMAL(5,2),
    fat_per DECIMAL(3,1),
    carbs_per DECIMAL(3,1),
    protein_per DECIMAL(3,1),
    activity_level varchar(20),
    caloric_needs INT,
    consumed_calories INT,
    last_update DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    total_steps INT,
    steps_taken INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    PRIMARY KEY(health_id)
);

CREATE TABLE blood_sugar_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    sugar_level DECIMAL(5, 2) NOT NULL,
    date DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
    
CREATE TABLE weight_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    actual_weight DECIMAL(5, 2) NOT NULL,
    ideal_weight DECIMAL(5, 2) NOT NULL,
	date DATE NOT NULL,
    -- notes VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
    
CREATE TABLE Likes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,
    food_id INT,
    user_id INT,
    reaction INT,
    FOREIGN KEY (food_id) REFERENCES Foods(food_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    UNIQUE (user_id, food_id)
);

CREATE TABLE MealPlans(
	meal_id INT AUTO_INCREMENT UNIQUE NOT NULL, 
	-- food_id INT ,
    food_name VARCHAR(50),
    user_id INT,
    score INT,
    fats DECIMAL(3,1),
    carbs DECIMAL(3,1),
    protein DECIMAL(3,1),
    portion_size INT,
    meal_time VARCHAR(20),
    calories INT,
    date DATE DEFAULT current_timestamp,
    -- FOREIGN KEY(food_id) REFERENCES Foods(food_id),
    FOREIGN KEY(user_id) REFERENCES Users(user_id)
);
