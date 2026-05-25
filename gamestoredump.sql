-- GameStore Database Clean Schema (Required for C# Backend)

DROP DATABASE IF EXISTS gamestore;
CREATE DATABASE gamestore;
USE gamestore;

-- 1. Companies Table
CREATE TABLE `companies` (
  `companyId` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `country` varchar(50) DEFAULT NULL,
  `foundedYear` int DEFAULT NULL,
  `website` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`companyId`)
);

-- 2. Users Table (Updated for Authentication & User Management)
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` varchar(20) DEFAULT 'user',
  `status` varchar(20) DEFAULT 'active',
  `registrationDate` date DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `age` int DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
);

-- 3. Games Table
CREATE TABLE `games` (
  `gameId` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `companyId` int DEFAULT NULL,
  `genre` varchar(50) DEFAULT NULL,
  `releaseYear` int DEFAULT NULL,
  `price` decimal(7,2) DEFAULT NULL,
  PRIMARY KEY (`gameId`),
  CONSTRAINT `games_ibfk_1` FOREIGN KEY (`companyId`) REFERENCES `companies` (`companyId`)
);

-- 4. Purchases Table
CREATE TABLE `purchases` (
  `purchaseId` int NOT NULL AUTO_INCREMENT,
  `userId` int DEFAULT NULL,
  `gameId` int DEFAULT NULL,
  `purchaseDate` date DEFAULT NULL,
  `amount` decimal(7,2) DEFAULT NULL,
  `paymentMethod` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`purchaseId`),
  CONSTRAINT `purchases_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`user_id`),
  CONSTRAINT `purchases_ibfk_2` FOREIGN KEY (`gameId`) REFERENCES `games` (`gameId`)
);

-- 5. Reviews Table
CREATE TABLE `reviews` (
  `reviewId` int NOT NULL AUTO_INCREMENT,
  `userId` int DEFAULT NULL,
  `gameId` int DEFAULT NULL,
  `rating` int DEFAULT NULL,
  `reviewText` varchar(500) DEFAULT NULL,
  `reviewDate` date DEFAULT NULL,
  PRIMARY KEY (`reviewId`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`user_id`),
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`gameId`) REFERENCES `games` (`gameId`)
);

-- 6. Activity Log Table
CREATE TABLE `activity_log` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `table_name` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `record_id` int DEFAULT NULL,
  `details` varchar(500) DEFAULT NULL,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`)
);

-- 7. Views
CREATE VIEW `companysalesreport` AS 
SELECT c.name AS companyName, SUM(p.amount) AS totalRevenue, COUNT(p.purchaseId) AS totalSales 
FROM companies c 
JOIN games g ON c.companyId = g.companyId 
JOIN purchases p ON g.gameId = p.gameId 
GROUP BY c.companyId, c.name;

CREATE VIEW `mostpopulargames` AS 
SELECT g.title AS title, COUNT(p.purchaseId) AS purchases 
FROM games g 
JOIN purchases p ON g.gameId = p.gameId 
GROUP BY g.gameId, g.title;

CREATE VIEW `topratedgames` AS 
SELECT g.title AS title, AVG(r.rating) AS avgRating, COUNT(r.reviewId) AS numReviews 
FROM games g 
JOIN reviews r ON g.gameId = r.gameId 
GROUP BY g.gameId, g.title 
HAVING count(r.reviewId) >= 1;

-- 8. Triggers
DELIMITER ;;

CREATE TRIGGER `games_after_insert` AFTER INSERT ON `games` FOR EACH ROW 
BEGIN
	INSERT INTO activity_log (table_name, action, record_id, details)
    VALUES ('games', 'INSERT', new.gameId, CONCAT('Added game ', new.title, ' (', new.genre, ', ', new.releaseYear, ')'));
END;;

CREATE TRIGGER `games_after_update` AFTER UPDATE ON `games` FOR EACH ROW 
BEGIN
	INSERT INTO activity_log (table_name, action, record_id, details)
    VALUES ('games', 'UPDATE', new.gameId, CONCAT('Updated: ', new.title, IF(old.price != new.price, CONCAT(' | price ', old.price, ' -> ', new.price), ''), IF(old.title != new.title, CONCAT(' | title ', old.title, ' -> ', new.title), '')));
END;;

CREATE TRIGGER `games_after_delete` AFTER DELETE ON `games` FOR EACH ROW 
BEGIN
	INSERT INTO activity_log (table_name, action, record_id, details)
    VALUES ('games', 'DELETE', OLD.gameId, CONCAT('Removed game: ', old.title, ' (id = ', old.gameId, ')'));
END;;

-- 9. Functions and Procedures
CREATE FUNCTION `GetAverageRatingByTitle`(gameTitle VARCHAR(100)) RETURNS decimal(4,2)
DETERMINISTIC
BEGIN
    DECLARE avgRating DECIMAL(4,2);
    SELECT AVG(r.rating) INTO avgRating FROM reviews r JOIN games g ON r.gameId = g.gameId WHERE g.title = gameTitle;
    RETURN avgRating;
END;;

CREATE PROCEDURE `RegisterUserAndPurchase`(
    IN newUsername VARCHAR(30),
    IN newEmail VARCHAR(100),
    IN regDate DATE,
    IN regCountry VARCHAR(50),
    IN regAge INT,
    IN purchasedGameId INT,
    IN paidAmount DECIMAL(7,2),
    IN payMethod VARCHAR(30)
)
BEGIN
    DECLARE newUserId INT;
    SELECT user_id INTO newUserId FROM users WHERE username = newUsername OR email = newEmail LIMIT 1;
    
    IF newUserId IS NULL THEN
        INSERT INTO users (username, email, registrationDate, country, age, password_hash)
        VALUES (newUsername, newEmail, regDate, regCountry, regAge, MD5('defaultpass'));
        SET newUserId = LAST_INSERT_ID();
    END IF;
    
    INSERT INTO purchases (userId, gameId, purchaseDate, amount, paymentMethod)
    VALUES (newUserId, purchasedGameId, CURDATE(), paidAmount, payMethod);
END;;

DELIMITER ;

-- =========================================
-- DUMMY DATA FOR TESTING / DEMONSTRATION
-- =========================================

-- Insert Companies
INSERT INTO `companies` (`name`, `country`, `foundedYear`, `website`) VALUES 
('Nintendo', 'Japan', 1889, 'nintendo.com'),
('Valve', 'USA', 1996, 'valvesoftware.com'),
('CD Projekt Red', 'Poland', 2002, 'cdprojekt.com');

-- Insert Games
INSERT INTO `games` (`title`, `companyId`, `genre`, `releaseYear`, `price`) VALUES 
('Zelda: Breath of the Wild', 1, 'Adventure', 2017, 59.99),
('Super Mario Odyssey', 1, 'Platformer', 2017, 59.99),
('Portal 2', 2, 'Puzzle', 2011, 9.99),
('Half-Life 2', 2, 'Shooter', 2004, 9.99),
('The Witcher 3', 3, 'RPG', 2015, 39.99),
('Cyberpunk 2077', 3, 'RPG', 2020, 59.99);

-- Insert Users
INSERT INTO `users` (`username`, `email`, `password_hash`, `role`, `status`, `registrationDate`, `country`, `age`) VALUES 
('admin', 'admin@gamestore.com', MD5('password123'), 'admin', 'active', '2023-01-01', 'USA', 30),
('john_doe', 'john@example.com', MD5('pass123'), 'user', 'active', '2023-05-15', 'USA', 25),
('jane_smith', 'jane@example.com', MD5('pass123'), 'user', 'active', '2023-06-20', 'UK', 28),
('gamer_x', 'gamerx@example.com', MD5('pass123'), 'user', 'inactive', '2023-07-10', 'Canada', 21);

-- Insert Purchases
INSERT INTO `purchases` (`userId`, `gameId`, `purchaseDate`, `amount`, `paymentMethod`) VALUES 
(2, 1, '2023-05-16', 59.99, 'Credit Card'),
(2, 5, '2023-05-20', 39.99, 'PayPal'),
(3, 3, '2023-06-21', 9.99, 'Credit Card'),
(4, 6, '2023-07-11', 59.99, 'Debit Card');

-- Insert Reviews
INSERT INTO `reviews` (`userId`, `gameId`, `rating`, `reviewText`, `reviewDate`) VALUES 
(2, 1, 5, 'Absolute masterpiece!', '2023-05-25'),
(2, 5, 5, 'Best RPG ever.', '2023-06-01'),
(3, 3, 4, 'Great puzzles.', '2023-06-25'),
(4, 6, 3, 'Good but buggy.', '2023-07-15');
