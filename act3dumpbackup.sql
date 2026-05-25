-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: gamestore
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activity_log`
--

DROP TABLE IF EXISTS `activity_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_log` (
  `logId` int NOT NULL AUTO_INCREMENT,
  `tableName` varchar(50) NOT NULL,
  `action` varchar(10) NOT NULL,
  `recordId` int DEFAULT NULL,
  `details` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`logId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_log`
--

LOCK TABLES `activity_log` WRITE;
/*!40000 ALTER TABLE `activity_log` DISABLE KEYS */;
INSERT INTO `activity_log` VALUES (1,'games','INSERT',11,'Added game Demo Game (FPS, 2026)'),(2,'games','UPDATE',11,'Updated: Demo Game (Sale) | price 14.99 -> 9.99 | title Demo Game -> Demo Game (Sale)'),(3,'games','DELETE',11,'Removed game: Demo Game (Sale) (id = 11)');
/*!40000 ALTER TABLE `activity_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `companies`
--

DROP TABLE IF EXISTS `companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `companies` (
  `companyId` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `country` varchar(50) DEFAULT NULL,
  `foundedYear` int DEFAULT NULL,
  `website` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`companyId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companies`
--

LOCK TABLES `companies` WRITE;
/*!40000 ALTER TABLE `companies` DISABLE KEYS */;
INSERT INTO `companies` VALUES (1,'Valve Corporation','USA',1996,'https://www.valvesoftware.com'),(2,'CD Projekt','Poland',1994,'https://www.cdprojekt.com'),(3,'Ubisoft','France',1986,'https://www.ubisoft.com'),(4,'Electronic Arts','USA',1982,'https://www.ea.com'),(5,'Bethesda Softworks','USA',1986,'https://bethesda.net'),(6,'Rockstar Games','USA',1998,'https://www.rockstargames.com'),(7,'Capcom','Japan',1979,'https://www.capcom.co.jp'),(8,'Square Enix','Japan',1975,'https://www.square-enix.com'),(9,'SEGA','Japan',1960,'https://sega.com'),(10,'Bandai Namco','Japan',2006,'https://www.bandainamcoent.com');
/*!40000 ALTER TABLE `companies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `companysalesreport`
--

DROP TABLE IF EXISTS `companysalesreport`;
/*!50001 DROP VIEW IF EXISTS `companysalesreport`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `companysalesreport` AS SELECT 
 1 AS `companyName`,
 1 AS `totalRevenue`,
 1 AS `totalSales`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `games`
--

DROP TABLE IF EXISTS `games`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `games` (
  `gameId` int NOT NULL,
  `title` varchar(100) NOT NULL,
  `companyId` int DEFAULT NULL,
  `genre` varchar(50) DEFAULT NULL,
  `releaseYear` int DEFAULT NULL,
  `price` decimal(7,2) DEFAULT NULL,
  PRIMARY KEY (`gameId`),
  KEY `companyId` (`companyId`),
  CONSTRAINT `games_ibfk_1` FOREIGN KEY (`companyId`) REFERENCES `companies` (`companyId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `games`
--

LOCK TABLES `games` WRITE;
/*!40000 ALTER TABLE `games` DISABLE KEYS */;
INSERT INTO `games` VALUES (1,'Half-Life 2',1,'FPS',2004,9.99),(2,'The Witcher 3',2,'RPG',2015,29.99),(3,'Assassin\'s Creed Odyssey',3,'Action',2018,39.99),(4,'FIFA 23',4,'Sports',2022,49.99),(5,'Skyrim',5,'RPG',2011,19.99),(6,'GTA V',6,'Action',2013,19.99),(7,'Resident Evil 2',7,'Horror',2019,24.99),(8,'Final Fantasy XV',8,'RPG',2016,19.99),(9,'Sonic Mania',9,'Platformer',2017,14.99),(10,'Dark Souls III',10,'Action',2016,39.99);
/*!40000 ALTER TABLE `games` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `games_after_insert` AFTER INSERT ON `games` FOR EACH ROW begin
	insert into activity_log (tableName, action, recordId, details)
    values (
		'games',
        'INSERT',
        new.gameId,
        concat('Added game ', new.title, ' (', new.genre, ', ', new.releaseYear, ')')
        );
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `games_after_update` AFTER UPDATE ON `games` FOR EACH ROW begin
	insert into activity_log (tableName, action, recordId, details)
    values (
		'games',
        'UPDATE',
        new.gameId,
        concat(
			'Updated: ', new.title,
            if(old.price != new.price, concat(' | price ', old.price, ' -> ', new.price), ''),
            if(old.title != new.title, concat(' | title ', old.title, ' -> ', new.title), '')
            )
        );
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `games_after_delete` AFTER DELETE ON `games` FOR EACH ROW begin
	insert into activity_log (tableName, action, recordId, details)
    values (
		'games',
        'DELETE',
        OLD.gameId,
        concat('Removed game: ', old.title, ' (id = ', old.gameId, ')')
        );
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `mostpopulargames`
--

DROP TABLE IF EXISTS `mostpopulargames`;
/*!50001 DROP VIEW IF EXISTS `mostpopulargames`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `mostpopulargames` AS SELECT 
 1 AS `title`,
 1 AS `purchases`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `purchases`
--

DROP TABLE IF EXISTS `purchases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchases` (
  `purchaseId` int NOT NULL,
  `userId` int DEFAULT NULL,
  `gameId` int DEFAULT NULL,
  `purchaseDate` date DEFAULT NULL,
  `amountPaid` decimal(7,2) DEFAULT NULL,
  `paymentMethod` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`purchaseId`),
  KEY `userId` (`userId`),
  KEY `gameId` (`gameId`),
  CONSTRAINT `purchases_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`),
  CONSTRAINT `purchases_ibfk_2` FOREIGN KEY (`gameId`) REFERENCES `games` (`gameId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchases`
--

LOCK TABLES `purchases` WRITE;
/*!40000 ALTER TABLE `purchases` DISABLE KEYS */;
INSERT INTO `purchases` VALUES (1,1,1,'2021-02-01',9.99,'Credit Card'),(2,2,2,'2021-05-13',29.99,'PayPal'),(3,3,3,'2022-05-14',39.99,'Credit Card'),(4,4,4,'2021-01-03',49.99,'Debit Card'),(5,5,5,'2022-01-29',19.99,'Credit Card'),(6,6,6,'2021-08-15',19.99,'Credit Card'),(7,7,7,'2022-02-10',24.99,'PayPal'),(8,8,8,'2022-03-29',19.99,'Credit Card'),(9,9,9,'2022-09-01',14.99,'Debit Card'),(10,10,10,'2021-11-13',39.99,'Credit Card');
/*!40000 ALTER TABLE `purchases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `reviewId` int NOT NULL,
  `userId` int DEFAULT NULL,
  `gameId` int DEFAULT NULL,
  `rating` int DEFAULT NULL,
  `reviewText` varchar(500) DEFAULT NULL,
  `reviewDate` date DEFAULT NULL,
  PRIMARY KEY (`reviewId`),
  KEY `userId` (`userId`),
  KEY `gameId` (`gameId`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`),
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`gameId`) REFERENCES `games` (`gameId`),
  CONSTRAINT `reviews_chk_1` CHECK ((`rating` between 1 and 10))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (1,1,1,10,'Masterpiece of its time!','2021-02-02'),(2,2,2,9,'Amazing story and world.','2021-05-14'),(3,3,3,8,'Nice action, but repetitive.','2022-05-15'),(4,4,4,7,'Good, but microtransactions...','2021-01-05'),(5,5,5,10,'Best RPG ever.','2022-01-30'),(6,6,6,10,'Brilliant game!','2021-08-16'),(7,7,7,8,'Scary and fun.','2022-02-11'),(8,8,8,7,'Visuals are great.','2022-03-30'),(9,9,9,7,'Classic platformer.','2022-09-02'),(10,10,10,9,'Challenging but rewarding.','2021-11-14');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `topratedgames`
--

DROP TABLE IF EXISTS `topratedgames`;
/*!50001 DROP VIEW IF EXISTS `topratedgames`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `topratedgames` AS SELECT 
 1 AS `title`,
 1 AS `avgRating`,
 1 AS `numReviews`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `userId` int NOT NULL,
  `username` varchar(30) NOT NULL,
  `email` varchar(100) NOT NULL,
  `registrationDate` date DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `age` int DEFAULT NULL,
  PRIMARY KEY (`userId`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'alexgamer','alex@games.com','2021-01-15','USA',28),(2,'cdprojektfan','cdproj@fan.com','2021-05-10','Poland',24),(3,'frenchgamer','frenchgamer@fr.com','2022-02-12','France',32),(4,'fpsking','kingfps@shoot.com','2020-12-08','UK',21),(5,'japanfan','japan@fan.com','2021-04-18','Japan',23),(6,'gamer007','gamer007@game.com','2021-06-09','USA',27),(7,'bethesdadude','bethesda@dude.com','2021-07-21','USA',34),(8,'ecurious','e.curio@sample.com','2022-03-17','Canada',29),(9,'platformpro','platform@pro.com','2022-08-22','Australia',19),(10,'sportsfan','sports@fan.com','2021-11-12','Brazil',25);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'gamestore'
--

--
-- Dumping routines for database 'gamestore'
--
/*!50003 DROP FUNCTION IF EXISTS `GetAverageRatingByTitle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GetAverageRatingByTitle`(gameTitle VARCHAR(100)) RETURNS decimal(4,2)
    DETERMINISTIC
BEGIN
    DECLARE avgRating DECIMAL(4,2);
    SELECT AVG(r.rating) INTO avgRating
    FROM Reviews r
    JOIN Games g ON r.gameId = g.gameId
    WHERE g.title = gameTitle;
    RETURN avgRating;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `RegisterUserAndPurchase` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `RegisterUserAndPurchase`(
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

    INSERT INTO Users (userId, username, email, registrationDate, country, age)
    VALUES (
        (SELECT IFNULL(MAX(userId), 0) + 1 FROM Users), newUsername, newEmail, regDate, regCountry, regAge
    );

    SET newUserId = (SELECT userId FROM Users WHERE email = newEmail);

    INSERT INTO Purchases (purchaseId, userId, gameId, purchaseDate, amountPaid, paymentMethod)
    VALUES (
        (SELECT IFNULL(MAX(purchaseId), 0) + 1 FROM Purchases), newUserId, purchasedGameId, CURDATE(), paidAmount, payMethod
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `companysalesreport`
--

/*!50001 DROP VIEW IF EXISTS `companysalesreport`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `companysalesreport` AS select `c`.`name` AS `companyName`,sum(`p`.`amountPaid`) AS `totalRevenue`,count(`p`.`purchaseId`) AS `totalSales` from ((`companies` `c` join `games` `g` on((`c`.`companyId` = `g`.`companyId`))) join `purchases` `p` on((`g`.`gameId` = `p`.`gameId`))) group by `c`.`companyId`,`c`.`name` order by `totalRevenue` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `mostpopulargames`
--

/*!50001 DROP VIEW IF EXISTS `mostpopulargames`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `mostpopulargames` AS select `g`.`title` AS `title`,count(`p`.`purchaseId`) AS `purchases` from (`games` `g` join `purchases` `p` on((`g`.`gameId` = `p`.`gameId`))) group by `g`.`gameId`,`g`.`title` order by `purchases` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `topratedgames`
--

/*!50001 DROP VIEW IF EXISTS `topratedgames`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `topratedgames` AS select `g`.`title` AS `title`,avg(`r`.`rating`) AS `avgRating`,count(`r`.`reviewId`) AS `numReviews` from (`games` `g` join `reviews` `r` on((`g`.`gameId` = `r`.`gameId`))) group by `g`.`gameId`,`g`.`title` having (count(`r`.`reviewId`) >= 1) order by `avgRating` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-09  1:30:52
