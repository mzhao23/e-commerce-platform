/*
 Navicat Premium Dump SQL

 Source Server         : ecomm
 Source Server Type    : MySQL
 Source Server Version : 90500 (9.5.0)
 Source Host           : localhost:3306
 Source Schema         : ecommerce_db

 Target Server Type    : MySQL
 Target Server Version : 90500 (9.5.0)
 File Encoding         : 65001

 Date: 18/12/2025 13:46:07
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for BrandInfo
-- ----------------------------
DROP TABLE IF EXISTS `BrandInfo`;
CREATE TABLE `BrandInfo` (
  `BrandId` int NOT NULL AUTO_INCREMENT,
  `BrandName` varchar(100) NOT NULL,
  `BrandDesc` text,
  `ContactNumber` varchar(20) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `BrandWeb` varchar(255) DEFAULT NULL,
  `Rating` decimal(3,2) DEFAULT NULL,
  `CreatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`BrandId`),
  UNIQUE KEY `BrandName` (`BrandName`),
  KEY `idx_brand_name` (`BrandName`),
  KEY `idx_brand_rating` (`Rating`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of BrandInfo
-- ----------------------------
BEGIN;
INSERT INTO `BrandInfo` (`BrandId`, `BrandName`, `BrandDesc`, `ContactNumber`, `Email`, `BrandWeb`, `Rating`, `CreatedAt`, `UpdatedAt`) VALUES (1, 'Apple', 'Premium electronics and software company', '1-800-275-2273', 'contact@apple.com', 'https://www.apple.com', 4.85, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `BrandInfo` (`BrandId`, `BrandName`, `BrandDesc`, `ContactNumber`, `Email`, `BrandWeb`, `Rating`, `CreatedAt`, `UpdatedAt`) VALUES (2, 'Samsung', 'Global leader in electronics and appliances', '1-800-726-7864', 'support@samsung.com', 'https://www.samsung.com', 4.65, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `BrandInfo` (`BrandId`, `BrandName`, `BrandDesc`, `ContactNumber`, `Email`, `BrandWeb`, `Rating`, `CreatedAt`, `UpdatedAt`) VALUES (3, 'Sony', 'Entertainment and electronics giant', '1-800-222-7669', 'support@sony.com', 'https://www.sony.com', 4.55, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `BrandInfo` (`BrandId`, `BrandName`, `BrandDesc`, `ContactNumber`, `Email`, `BrandWeb`, `Rating`, `CreatedAt`, `UpdatedAt`) VALUES (4, 'Microsoft', 'Software and hardware technology company', '1-800-642-7676', 'support@microsoft.com', 'https://www.microsoft.com', 4.50, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `BrandInfo` (`BrandId`, `BrandName`, `BrandDesc`, `ContactNumber`, `Email`, `BrandWeb`, `Rating`, `CreatedAt`, `UpdatedAt`) VALUES (5, 'Dell', 'Computer technology company', '1-800-624-9897', 'support@dell.com', 'https://www.dell.com', 4.30, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `BrandInfo` (`BrandId`, `BrandName`, `BrandDesc`, `ContactNumber`, `Email`, `BrandWeb`, `Rating`, `CreatedAt`, `UpdatedAt`) VALUES (6, 'Nintendo', 'Video game company', '1-800-255-3700', 'support@nintendo.com', 'https://www.nintendo.com', 4.70, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `BrandInfo` (`BrandId`, `BrandName`, `BrandDesc`, `ContactNumber`, `Email`, `BrandWeb`, `Rating`, `CreatedAt`, `UpdatedAt`) VALUES (7, 'Bose', 'Audio equipment manufacturer', '1-800-999-2673', 'support@bose.com', 'https://www.bose.com', 4.60, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `BrandInfo` (`BrandId`, `BrandName`, `BrandDesc`, `ContactNumber`, `Email`, `BrandWeb`, `Rating`, `CreatedAt`, `UpdatedAt`) VALUES (8, 'LG', 'Electronics and appliances company', '1-800-243-0000', 'support@lg.com', 'https://www.lg.com', 4.25, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `BrandInfo` (`BrandId`, `BrandName`, `BrandDesc`, `ContactNumber`, `Email`, `BrandWeb`, `Rating`, `CreatedAt`, `UpdatedAt`) VALUES (9, 'HP', 'Computer and printer manufacturer', '1-800-474-6836', 'support@hp.com', 'https://www.hp.com', 4.20, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `BrandInfo` (`BrandId`, `BrandName`, `BrandDesc`, `ContactNumber`, `Email`, `BrandWeb`, `Rating`, `CreatedAt`, `UpdatedAt`) VALUES (10, 'Lenovo', 'Computer technology company', '1-855-253-6686', 'support@lenovo.com', 'https://www.lenovo.com', 4.15, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
COMMIT;

-- ----------------------------
-- Table structure for CustomerAddress
-- ----------------------------
DROP TABLE IF EXISTS `CustomerAddress`;
CREATE TABLE `CustomerAddress` (
  `AddressId` int NOT NULL AUTO_INCREMENT,
  `CustomerId` int NOT NULL,
  `Street` varchar(200) NOT NULL,
  `City` varchar(100) NOT NULL,
  `State` varchar(50) NOT NULL,
  `Zipcode` varchar(20) NOT NULL,
  `IsDefault` tinyint(1) DEFAULT '0',
  `CreatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`AddressId`),
  KEY `idx_address_customer` (`CustomerId`),
  KEY `idx_address_location` (`State`,`City`),
  CONSTRAINT `customeraddress_ibfk_1` FOREIGN KEY (`CustomerId`) REFERENCES `CustomerInfo` (`CustomerId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of CustomerAddress
-- ----------------------------
BEGIN;
INSERT INTO `CustomerAddress` (`AddressId`, `CustomerId`, `Street`, `City`, `State`, `Zipcode`, `IsDefault`, `CreatedAt`, `UpdatedAt`) VALUES (3, 2, '789 Oak Drive', 'Los Angeles', 'CA', '90001', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `CustomerAddress` (`AddressId`, `CustomerId`, `Street`, `City`, `State`, `Zipcode`, `IsDefault`, `CreatedAt`, `UpdatedAt`) VALUES (4, 3, '321 Pine Road', 'Chicago', 'IL', '60601', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `CustomerAddress` (`AddressId`, `CustomerId`, `Street`, `City`, `State`, `Zipcode`, `IsDefault`, `CreatedAt`, `UpdatedAt`) VALUES (5, 4, '654 Maple Lane', 'Houston', 'TX', '77001', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `CustomerAddress` (`AddressId`, `CustomerId`, `Street`, `City`, `State`, `Zipcode`, `IsDefault`, `CreatedAt`, `UpdatedAt`) VALUES (6, 4, '987 Cedar Court', 'Houston', 'TX', '77002', 0, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `CustomerAddress` (`AddressId`, `CustomerId`, `Street`, `City`, `State`, `Zipcode`, `IsDefault`, `CreatedAt`, `UpdatedAt`) VALUES (7, 5, '147 Elm Street', 'Phoenix', 'AZ', '85001', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `CustomerAddress` (`AddressId`, `CustomerId`, `Street`, `City`, `State`, `Zipcode`, `IsDefault`, `CreatedAt`, `UpdatedAt`) VALUES (8, 6, '258 Birch Avenue', 'Philadelphia', 'PA', '19101', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `CustomerAddress` (`AddressId`, `CustomerId`, `Street`, `City`, `State`, `Zipcode`, `IsDefault`, `CreatedAt`, `UpdatedAt`) VALUES (9, 7, '369 Walnut Way', 'San Antonio', 'TX', '78201', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `CustomerAddress` (`AddressId`, `CustomerId`, `Street`, `City`, `State`, `Zipcode`, `IsDefault`, `CreatedAt`, `UpdatedAt`) VALUES (10, 8, '741 Cherry Lane', 'San Diego', 'CA', '92101', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `CustomerAddress` (`AddressId`, `CustomerId`, `Street`, `City`, `State`, `Zipcode`, `IsDefault`, `CreatedAt`, `UpdatedAt`) VALUES (11, 9, '852 Spruce Drive', 'Dallas', 'TX', '75201', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `CustomerAddress` (`AddressId`, `CustomerId`, `Street`, `City`, `State`, `Zipcode`, `IsDefault`, `CreatedAt`, `UpdatedAt`) VALUES (12, 10, '963 Willow Road', 'San Jose', 'CA', '95101', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `CustomerAddress` (`AddressId`, `CustomerId`, `Street`, `City`, `State`, `Zipcode`, `IsDefault`, `CreatedAt`, `UpdatedAt`) VALUES (13, 11, '100 Test Street', 'New York', 'NY', '10001', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `CustomerAddress` (`AddressId`, `CustomerId`, `Street`, `City`, `State`, `Zipcode`, `IsDefault`, `CreatedAt`, `UpdatedAt`) VALUES (14, 14, '123 Main St', 'New York', 'NY', '10001', 1, '2025-12-13 23:45:53', '2025-12-13 23:45:53');
COMMIT;

-- ----------------------------
-- Table structure for CustomerInfo
-- ----------------------------
DROP TABLE IF EXISTS `CustomerInfo`;
CREATE TABLE `CustomerInfo` (
  `CustomerId` int NOT NULL AUTO_INCREMENT,
  `CusFirstName` varchar(50) NOT NULL,
  `CusLastName` varchar(50) NOT NULL,
  `CusDOB` date DEFAULT NULL,
  `CusPhoneNum` varchar(15) DEFAULT NULL,
  `CusEmail` varchar(100) NOT NULL,
  `PasswordHash` varchar(255) NOT NULL,
  `CreatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`CustomerId`),
  UNIQUE KEY `CusEmail` (`CusEmail`),
  UNIQUE KEY `CusPhoneNum` (`CusPhoneNum`),
  KEY `idx_customer_name` (`CusLastName`,`CusFirstName`),
  KEY `idx_customer_email` (`CusEmail`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of CustomerInfo
-- ----------------------------
BEGIN;
INSERT INTO `CustomerInfo` (`CustomerId`, `CusFirstName`, `CusLastName`, `CusDOB`, `CusPhoneNum`, `CusEmail`, `PasswordHash`, `CreatedAt`, `UpdatedAt`) VALUES (2, 'John', 'Smith', '1990-05-15', '1234567001', 'john.smith@email.com', 'scrypt:32768:8:1$PRtzIJmFvA4r25XM$d73ca3ad22acdbd4ee9cdab6ff587c4261029254e4e6d446bf1b735da2d99e8bd21dc268878acdec51104f1994a920237e6e300a4bb4892f442fcb749edc570d', '2025-12-13 23:18:42', '2025-12-13 23:44:07');
INSERT INTO `CustomerInfo` (`CustomerId`, `CusFirstName`, `CusLastName`, `CusDOB`, `CusPhoneNum`, `CusEmail`, `PasswordHash`, `CreatedAt`, `UpdatedAt`) VALUES (3, 'Emily', 'Johnson', '1988-08-22', '1234567002', 'emily.j@email.com', 'scrypt:32768:8:1$PRtzIJmFvA4r25XM$d73ca3ad22acdbd4ee9cdab6ff587c4261029254e4e6d446bf1b735da2d99e8bd21dc268878acdec51104f1994a920237e6e300a4bb4892f442fcb749edc570d', '2025-12-13 23:18:42', '2025-12-13 23:44:07');
INSERT INTO `CustomerInfo` (`CustomerId`, `CusFirstName`, `CusLastName`, `CusDOB`, `CusPhoneNum`, `CusEmail`, `PasswordHash`, `CreatedAt`, `UpdatedAt`) VALUES (4, 'Michael', 'Williams', '1995-03-10', '1234567003', 'michael.w@email.com', 'scrypt:32768:8:1$PRtzIJmFvA4r25XM$d73ca3ad22acdbd4ee9cdab6ff587c4261029254e4e6d446bf1b735da2d99e8bd21dc268878acdec51104f1994a920237e6e300a4bb4892f442fcb749edc570d', '2025-12-13 23:18:42', '2025-12-13 23:44:07');
INSERT INTO `CustomerInfo` (`CustomerId`, `CusFirstName`, `CusLastName`, `CusDOB`, `CusPhoneNum`, `CusEmail`, `PasswordHash`, `CreatedAt`, `UpdatedAt`) VALUES (5, 'Sarah', 'Brown', '1992-11-28', '1234567004', 'sarah.b@email.com', 'scrypt:32768:8:1$PRtzIJmFvA4r25XM$d73ca3ad22acdbd4ee9cdab6ff587c4261029254e4e6d446bf1b735da2d99e8bd21dc268878acdec51104f1994a920237e6e300a4bb4892f442fcb749edc570d', '2025-12-13 23:18:42', '2025-12-13 23:44:07');
INSERT INTO `CustomerInfo` (`CustomerId`, `CusFirstName`, `CusLastName`, `CusDOB`, `CusPhoneNum`, `CusEmail`, `PasswordHash`, `CreatedAt`, `UpdatedAt`) VALUES (6, 'David', 'Jones', '1985-07-04', '1234567005', 'david.jones@email.com', 'scrypt:32768:8:1$PRtzIJmFvA4r25XM$d73ca3ad22acdbd4ee9cdab6ff587c4261029254e4e6d446bf1b735da2d99e8bd21dc268878acdec51104f1994a920237e6e300a4bb4892f442fcb749edc570d', '2025-12-13 23:18:42', '2025-12-13 23:44:07');
INSERT INTO `CustomerInfo` (`CustomerId`, `CusFirstName`, `CusLastName`, `CusDOB`, `CusPhoneNum`, `CusEmail`, `PasswordHash`, `CreatedAt`, `UpdatedAt`) VALUES (7, 'Jessica', 'Garcia', '1998-01-17', '1234567006', 'jessica.g@email.com', 'scrypt:32768:8:1$PRtzIJmFvA4r25XM$d73ca3ad22acdbd4ee9cdab6ff587c4261029254e4e6d446bf1b735da2d99e8bd21dc268878acdec51104f1994a920237e6e300a4bb4892f442fcb749edc570d', '2025-12-13 23:18:42', '2025-12-13 23:44:07');
INSERT INTO `CustomerInfo` (`CustomerId`, `CusFirstName`, `CusLastName`, `CusDOB`, `CusPhoneNum`, `CusEmail`, `PasswordHash`, `CreatedAt`, `UpdatedAt`) VALUES (8, 'Daniel', 'Miller', '1991-09-30', '1234567007', 'daniel.m@email.com', 'scrypt:32768:8:1$PRtzIJmFvA4r25XM$d73ca3ad22acdbd4ee9cdab6ff587c4261029254e4e6d446bf1b735da2d99e8bd21dc268878acdec51104f1994a920237e6e300a4bb4892f442fcb749edc570d', '2025-12-13 23:18:42', '2025-12-13 23:44:07');
INSERT INTO `CustomerInfo` (`CustomerId`, `CusFirstName`, `CusLastName`, `CusDOB`, `CusPhoneNum`, `CusEmail`, `PasswordHash`, `CreatedAt`, `UpdatedAt`) VALUES (9, 'Ashley', 'Davis', '1993-04-12', '1234567008', 'ashley.d@email.com', 'scrypt:32768:8:1$PRtzIJmFvA4r25XM$d73ca3ad22acdbd4ee9cdab6ff587c4261029254e4e6d446bf1b735da2d99e8bd21dc268878acdec51104f1994a920237e6e300a4bb4892f442fcb749edc570d', '2025-12-13 23:18:42', '2025-12-13 23:44:07');
INSERT INTO `CustomerInfo` (`CustomerId`, `CusFirstName`, `CusLastName`, `CusDOB`, `CusPhoneNum`, `CusEmail`, `PasswordHash`, `CreatedAt`, `UpdatedAt`) VALUES (10, 'James', 'Rodriguez', '1987-12-05', '1234567009', 'james.r@email.com', 'scrypt:32768:8:1$PRtzIJmFvA4r25XM$d73ca3ad22acdbd4ee9cdab6ff587c4261029254e4e6d446bf1b735da2d99e8bd21dc268878acdec51104f1994a920237e6e300a4bb4892f442fcb749edc570d', '2025-12-13 23:18:42', '2025-12-13 23:44:07');
INSERT INTO `CustomerInfo` (`CustomerId`, `CusFirstName`, `CusLastName`, `CusDOB`, `CusPhoneNum`, `CusEmail`, `PasswordHash`, `CreatedAt`, `UpdatedAt`) VALUES (11, 'Amanda', 'Martinez', '1996-06-25', '1234567010', 'amanda.m@email.com', 'scrypt:32768:8:1$PRtzIJmFvA4r25XM$d73ca3ad22acdbd4ee9cdab6ff587c4261029254e4e6d446bf1b735da2d99e8bd21dc268878acdec51104f1994a920237e6e300a4bb4892f442fcb749edc570d', '2025-12-13 23:18:42', '2025-12-13 23:44:07');
INSERT INTO `CustomerInfo` (`CustomerId`, `CusFirstName`, `CusLastName`, `CusDOB`, `CusPhoneNum`, `CusEmail`, `PasswordHash`, `CreatedAt`, `UpdatedAt`) VALUES (14, 'Test', 'User', '1995-01-01', '9999999999', 'test@test.com', 'scrypt:32768:8:1$PRtzIJmFvA4r25XM$d73ca3ad22acdbd4ee9cdab6ff587c4261029254e4e6d446bf1b735da2d99e8bd21dc268878acdec51104f1994a920237e6e300a4bb4892f442fcb749edc570d', '2025-12-13 23:34:39', '2025-12-13 23:44:07');
INSERT INTO `CustomerInfo` (`CustomerId`, `CusFirstName`, `CusLastName`, `CusDOB`, `CusPhoneNum`, `CusEmail`, `PasswordHash`, `CreatedAt`, `UpdatedAt`) VALUES (15, 'Sq', 'W', NULL, NULL, 'sqw@wsq.com', 'scrypt:32768:8:1$PeYQ9nI8Ys2lfuaI$517e37dd685fe3ae11cae0fe8e41497ae1f3b41d9d4b27b205c453b3718a585780a1cab09d0e794734c45b5dfaa70fed36460ee65e3abd7d9ae9c657d9993b69', '2025-12-14 15:32:56', '2025-12-14 15:32:56');
COMMIT;

-- ----------------------------
-- Table structure for CustomerLoginLog
-- ----------------------------
DROP TABLE IF EXISTS `CustomerLoginLog`;
CREATE TABLE `CustomerLoginLog` (
  `LoginId` bigint NOT NULL AUTO_INCREMENT,
  `CustomerId` int NOT NULL,
  `LoginTime` datetime NOT NULL,
  `LogoutTime` datetime DEFAULT NULL,
  `LoginIp` varchar(45) DEFAULT NULL,
  `CreatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`LoginId`,`LoginTime`),
  KEY `idx_login_customer` (`CustomerId`),
  KEY `idx_login_time` (`LoginTime`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50100 PARTITION BY RANGE (year(`LoginTime`))
(PARTITION p2023 VALUES LESS THAN (2024) ENGINE = InnoDB,
 PARTITION p2024 VALUES LESS THAN (2025) ENGINE = InnoDB,
 PARTITION p2025 VALUES LESS THAN (2026) ENGINE = InnoDB,
 PARTITION p_future VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */;

-- ----------------------------
-- Records of CustomerLoginLog
-- ----------------------------
BEGIN;
INSERT INTO `CustomerLoginLog` (`LoginId`, `CustomerId`, `LoginTime`, `LogoutTime`, `LoginIp`, `CreatedAt`) VALUES (1, 1, '2024-01-15 09:30:00', '2024-01-15 10:45:00', '192.168.1.101', '2025-12-13 23:18:42');
INSERT INTO `CustomerLoginLog` (`LoginId`, `CustomerId`, `LoginTime`, `LogoutTime`, `LoginIp`, `CreatedAt`) VALUES (2, 1, '2024-02-20 14:00:00', '2024-02-20 15:30:00', '192.168.1.101', '2025-12-13 23:18:42');
INSERT INTO `CustomerLoginLog` (`LoginId`, `CustomerId`, `LoginTime`, `LogoutTime`, `LoginIp`, `CreatedAt`) VALUES (3, 2, '2024-01-16 11:00:00', '2024-01-16 12:00:00', '192.168.1.102', '2025-12-13 23:18:42');
INSERT INTO `CustomerLoginLog` (`LoginId`, `CustomerId`, `LoginTime`, `LogoutTime`, `LoginIp`, `CreatedAt`) VALUES (4, 3, '2024-02-10 16:30:00', '2024-02-10 17:45:00', '192.168.1.103', '2025-12-13 23:18:42');
INSERT INTO `CustomerLoginLog` (`LoginId`, `CustomerId`, `LoginTime`, `LogoutTime`, `LoginIp`, `CreatedAt`) VALUES (5, 4, '2024-03-05 08:00:00', '2024-03-05 09:30:00', '192.168.1.104', '2025-12-13 23:18:42');
INSERT INTO `CustomerLoginLog` (`LoginId`, `CustomerId`, `LoginTime`, `LogoutTime`, `LoginIp`, `CreatedAt`) VALUES (6, 5, '2024-03-12 13:15:00', '2024-03-12 14:00:00', '192.168.1.105', '2025-12-13 23:18:42');
INSERT INTO `CustomerLoginLog` (`LoginId`, `CustomerId`, `LoginTime`, `LogoutTime`, `LoginIp`, `CreatedAt`) VALUES (7, 6, '2024-04-01 10:00:00', '2024-04-01 11:30:00', '192.168.1.106', '2025-12-13 23:18:42');
INSERT INTO `CustomerLoginLog` (`LoginId`, `CustomerId`, `LoginTime`, `LogoutTime`, `LoginIp`, `CreatedAt`) VALUES (8, 7, '2024-04-15 15:45:00', '2024-04-15 16:30:00', '192.168.1.107', '2025-12-13 23:18:42');
INSERT INTO `CustomerLoginLog` (`LoginId`, `CustomerId`, `LoginTime`, `LogoutTime`, `LoginIp`, `CreatedAt`) VALUES (9, 8, '2024-05-08 09:00:00', '2024-05-08 10:00:00', '192.168.1.108', '2025-12-13 23:18:42');
INSERT INTO `CustomerLoginLog` (`LoginId`, `CustomerId`, `LoginTime`, `LogoutTime`, `LoginIp`, `CreatedAt`) VALUES (10, 9, '2024-05-20 14:30:00', '2024-05-20 15:45:00', '192.168.1.109', '2025-12-13 23:18:42');
INSERT INTO `CustomerLoginLog` (`LoginId`, `CustomerId`, `LoginTime`, `LogoutTime`, `LoginIp`, `CreatedAt`) VALUES (11, 10, '2024-06-03 11:00:00', '2024-06-03 12:30:00', '192.168.1.110', '2025-12-13 23:18:42');
INSERT INTO `CustomerLoginLog` (`LoginId`, `CustomerId`, `LoginTime`, `LogoutTime`, `LoginIp`, `CreatedAt`) VALUES (12, 1, '2025-01-10 08:00:00', '2025-01-10 09:30:00', '192.168.1.101', '2025-12-13 23:18:42');
INSERT INTO `CustomerLoginLog` (`LoginId`, `CustomerId`, `LoginTime`, `LogoutTime`, `LoginIp`, `CreatedAt`) VALUES (13, 2, '2025-01-12 10:00:00', '2025-01-12 11:00:00', '192.168.1.102', '2025-12-13 23:18:42');
INSERT INTO `CustomerLoginLog` (`LoginId`, `CustomerId`, `LoginTime`, `LogoutTime`, `LoginIp`, `CreatedAt`) VALUES (14, 3, '2025-01-15 14:00:00', '2025-01-15 15:30:00', '192.168.1.103', '2025-12-13 23:18:42');
INSERT INTO `CustomerLoginLog` (`LoginId`, `CustomerId`, `LoginTime`, `LogoutTime`, `LoginIp`, `CreatedAt`) VALUES (15, 4, '2025-02-01 09:30:00', '2025-02-01 10:45:00', '192.168.1.104', '2025-12-13 23:18:42');
INSERT INTO `CustomerLoginLog` (`LoginId`, `CustomerId`, `LoginTime`, `LogoutTime`, `LoginIp`, `CreatedAt`) VALUES (16, 5, '2025-02-10 16:00:00', '2025-02-10 17:00:00', '192.168.1.105', '2025-12-13 23:18:42');
INSERT INTO `CustomerLoginLog` (`LoginId`, `CustomerId`, `LoginTime`, `LogoutTime`, `LoginIp`, `CreatedAt`) VALUES (17, 6, '2025-03-01 11:30:00', '2025-03-01 12:30:00', '192.168.1.106', '2025-12-13 23:18:42');
INSERT INTO `CustomerLoginLog` (`LoginId`, `CustomerId`, `LoginTime`, `LogoutTime`, `LoginIp`, `CreatedAt`) VALUES (18, 7, '2025-03-15 13:00:00', '2025-03-15 14:30:00', '192.168.1.107', '2025-12-13 23:18:42');
INSERT INTO `CustomerLoginLog` (`LoginId`, `CustomerId`, `LoginTime`, `LogoutTime`, `LoginIp`, `CreatedAt`) VALUES (19, 8, '2025-04-01 08:30:00', '2025-04-01 09:30:00', '192.168.1.108', '2025-12-13 23:18:42');
INSERT INTO `CustomerLoginLog` (`LoginId`, `CustomerId`, `LoginTime`, `LogoutTime`, `LoginIp`, `CreatedAt`) VALUES (20, 9, '2025-04-10 15:00:00', NULL, '192.168.1.109', '2025-12-13 23:18:42');
COMMIT;

-- ----------------------------
-- Table structure for InventoryInfo
-- ----------------------------
DROP TABLE IF EXISTS `InventoryInfo`;
CREATE TABLE `InventoryInfo` (
  `InventoryId` bigint NOT NULL AUTO_INCREMENT,
  `ProductId` int NOT NULL,
  `WarehouseId` int NOT NULL,
  `CurrentCnt` int NOT NULL DEFAULT '0',
  `LockCnt` int NOT NULL DEFAULT '0',
  `InTransitCnt` int NOT NULL DEFAULT '0',
  `CreatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`InventoryId`),
  UNIQUE KEY `ProductId` (`ProductId`,`WarehouseId`),
  KEY `idx_inventory_product` (`ProductId`),
  KEY `idx_inventory_warehouse` (`WarehouseId`),
  CONSTRAINT `inventoryinfo_ibfk_1` FOREIGN KEY (`ProductId`) REFERENCES `ProductInfo` (`ProductId`) ON DELETE CASCADE,
  CONSTRAINT `inventoryinfo_ibfk_2` FOREIGN KEY (`WarehouseId`) REFERENCES `WarehouseInfo` (`WarehouseId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of InventoryInfo
-- ----------------------------
BEGIN;
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (1, 1, 1, 150, 10, 20, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (2, 2, 1, 200, 15, 25, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (3, 5, 1, 80, 5, 10, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (4, 8, 1, 50, 3, 8, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (5, 12, 1, 100, 8, 15, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (6, 15, 1, 120, 6, 12, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (7, 16, 1, 180, 12, 20, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (8, 18, 1, 90, 4, 10, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (9, 1, 2, 180, 12, 25, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (10, 3, 2, 120, 8, 15, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (11, 4, 2, 150, 10, 18, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (12, 9, 2, 70, 4, 8, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (13, 13, 2, 200, 15, 30, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (14, 17, 2, 100, 6, 12, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (15, 19, 2, 80, 5, 10, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (16, 20, 2, 60, 3, 8, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (17, 2, 3, 160, 10, 20, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (18, 6, 3, 140, 8, 15, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (19, 7, 3, 90, 5, 10, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (20, 10, 3, 55, 3, 6, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (21, 11, 3, 45, 2, 5, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (22, 14, 3, 110, 7, 12, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (23, 1, 4, 100, 6, 12, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (24, 3, 4, 80, 5, 10, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (25, 5, 4, 60, 4, 8, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (26, 12, 4, 90, 5, 10, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (27, 15, 4, 75, 4, 8, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (28, 8, 5, 40, 2, 5, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (29, 9, 5, 50, 3, 6, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (30, 13, 5, 120, 8, 15, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (31, 16, 5, 100, 6, 10, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `InventoryInfo` (`InventoryId`, `ProductId`, `WarehouseId`, `CurrentCnt`, `LockCnt`, `InTransitCnt`, `CreatedAt`, `UpdatedAt`) VALUES (32, 18, 5, 70, 4, 8, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
COMMIT;

-- ----------------------------
-- Table structure for OrderDetail
-- ----------------------------
DROP TABLE IF EXISTS `OrderDetail`;
CREATE TABLE `OrderDetail` (
  `OrderDtId` bigint NOT NULL AUTO_INCREMENT,
  `OrderId` bigint NOT NULL,
  `ProductId` int NOT NULL,
  `ProductName` varchar(255) NOT NULL,
  `ProductCount` int NOT NULL,
  `TotalPrice` decimal(10,2) NOT NULL,
  `CreatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`OrderDtId`),
  KEY `idx_orderdetail_order` (`OrderId`),
  KEY `idx_orderdetail_product` (`ProductId`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of OrderDetail
-- ----------------------------
BEGIN;
INSERT INTO `OrderDetail` (`OrderDtId`, `OrderId`, `ProductId`, `ProductName`, `ProductCount`, `TotalPrice`, `CreatedAt`, `UpdatedAt`) VALUES (1, 1, 1, 'iPhone 15 Pro Max', 1, 1199.00, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `OrderDetail` (`OrderDtId`, `OrderId`, `ProductId`, `ProductName`, `ProductCount`, `TotalPrice`, `CreatedAt`, `UpdatedAt`) VALUES (2, 2, 2, 'iPhone 15', 1, 799.00, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `OrderDetail` (`OrderDtId`, `OrderId`, `ProductId`, `ProductName`, `ProductCount`, `TotalPrice`, `CreatedAt`, `UpdatedAt`) VALUES (3, 3, 3, 'Samsung Galaxy S24 Ultra', 1, 1299.00, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `OrderDetail` (`OrderDtId`, `OrderId`, `ProductId`, `ProductName`, `ProductCount`, `TotalPrice`, `CreatedAt`, `UpdatedAt`) VALUES (4, 4, 6, 'iPad Air', 1, 599.00, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `OrderDetail` (`OrderDtId`, `OrderId`, `ProductId`, `ProductName`, `ProductCount`, `TotalPrice`, `CreatedAt`, `UpdatedAt`) VALUES (5, 5, 8, 'MacBook Pro 14\"', 1, 1999.00, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `OrderDetail` (`OrderDtId`, `OrderId`, `ProductId`, `ProductName`, `ProductCount`, `TotalPrice`, `CreatedAt`, `UpdatedAt`) VALUES (6, 6, 13, 'Nintendo Switch OLED', 1, 349.00, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `OrderDetail` (`OrderDtId`, `OrderId`, `ProductId`, `ProductName`, `ProductCount`, `TotalPrice`, `CreatedAt`, `UpdatedAt`) VALUES (7, 7, 12, 'PlayStation 5', 1, 499.00, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `OrderDetail` (`OrderDtId`, `OrderId`, `ProductId`, `ProductName`, `ProductCount`, `TotalPrice`, `CreatedAt`, `UpdatedAt`) VALUES (8, 8, 15, 'Sony WH-1000XM5', 1, 349.00, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `OrderDetail` (`OrderDtId`, `OrderId`, `ProductId`, `ProductName`, `ProductCount`, `TotalPrice`, `CreatedAt`, `UpdatedAt`) VALUES (9, 9, 16, 'AirPods Pro 2', 1, 249.00, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `OrderDetail` (`OrderDtId`, `OrderId`, `ProductId`, `ProductName`, `ProductCount`, `TotalPrice`, `CreatedAt`, `UpdatedAt`) VALUES (10, 10, 18, 'Apple Watch Series 9', 1, 399.00, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `OrderDetail` (`OrderDtId`, `OrderId`, `ProductId`, `ProductName`, `ProductCount`, `TotalPrice`, `CreatedAt`, `UpdatedAt`) VALUES (11, 11, 20, 'AirPods Max', 1, 549.00, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `OrderDetail` (`OrderDtId`, `OrderId`, `ProductId`, `ProductName`, `ProductCount`, `TotalPrice`, `CreatedAt`, `UpdatedAt`) VALUES (12, 12, 10, 'Dell XPS 15', 1, 1499.00, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `OrderDetail` (`OrderDtId`, `OrderId`, `ProductId`, `ProductName`, `ProductCount`, `TotalPrice`, `CreatedAt`, `UpdatedAt`) VALUES (13, 13, 1, 'iPhone 15 Pro Max', 1, 1199.00, '2025-12-13 23:45:53', '2025-12-13 23:45:53');
INSERT INTO `OrderDetail` (`OrderDtId`, `OrderId`, `ProductId`, `ProductName`, `ProductCount`, `TotalPrice`, `CreatedAt`, `UpdatedAt`) VALUES (14, 13, 5, 'iPad Pro 12.9\"', 2, 2198.00, '2025-12-13 23:45:53', '2025-12-13 23:45:53');
COMMIT;

-- ----------------------------
-- Table structure for OrderInfo
-- ----------------------------
DROP TABLE IF EXISTS `OrderInfo`;
CREATE TABLE `OrderInfo` (
  `OrderId` bigint NOT NULL AUTO_INCREMENT,
  `CustomerId` int NOT NULL,
  `AddressId` int NOT NULL,
  `TotalAmount` decimal(10,2) NOT NULL,
  `PaymentId` bigint NOT NULL,
  `TrackingNum` varchar(100) DEFAULT NULL,
  `OrderStatus` varchar(20) DEFAULT 'pending',
  `ShippedAt` datetime DEFAULT NULL,
  `ReceivedAt` datetime DEFAULT NULL,
  `CreatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`OrderId`,`CreatedAt`),
  KEY `idx_order_customer` (`CustomerId`),
  KEY `idx_order_status` (`OrderStatus`),
  KEY `idx_order_tracking` (`TrackingNum`),
  CONSTRAINT `orderinfo_chk_1` CHECK ((`OrderStatus` in (_utf8mb4'pending',_utf8mb4'shipped',_utf8mb4'delivered',_utf8mb4'cancelled')))
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50100 PARTITION BY RANGE (year(`CreatedAt`))
(PARTITION p2023 VALUES LESS THAN (2024) ENGINE = InnoDB,
 PARTITION p2024 VALUES LESS THAN (2025) ENGINE = InnoDB,
 PARTITION p2025 VALUES LESS THAN (2026) ENGINE = InnoDB,
 PARTITION p_future VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */;

-- ----------------------------
-- Records of OrderInfo
-- ----------------------------
BEGIN;
INSERT INTO `OrderInfo` (`OrderId`, `CustomerId`, `AddressId`, `TotalAmount`, `PaymentId`, `TrackingNum`, `OrderStatus`, `ShippedAt`, `ReceivedAt`, `CreatedAt`, `UpdatedAt`) VALUES (1, 1, 1, 1199.00, 1, 'TRK20240615001', 'delivered', '2024-06-16 08:00:00', '2024-06-20 14:30:00', '2024-06-15 10:30:00', '2025-12-13 23:18:42');
INSERT INTO `OrderInfo` (`OrderId`, `CustomerId`, `AddressId`, `TotalAmount`, `PaymentId`, `TrackingNum`, `OrderStatus`, `ShippedAt`, `ReceivedAt`, `CreatedAt`, `UpdatedAt`) VALUES (2, 2, 3, 799.00, 2, 'TRK20240616002', 'delivered', '2024-06-17 09:00:00', '2024-06-22 11:00:00', '2024-06-16 14:45:00', '2025-12-13 23:18:42');
INSERT INTO `OrderInfo` (`OrderId`, `CustomerId`, `AddressId`, `TotalAmount`, `PaymentId`, `TrackingNum`, `OrderStatus`, `ShippedAt`, `ReceivedAt`, `CreatedAt`, `UpdatedAt`) VALUES (3, 3, 4, 1299.00, 3, 'TRK20240701003', 'delivered', '2024-07-02 10:00:00', '2024-07-06 16:00:00', '2024-07-01 09:15:00', '2025-12-13 23:18:42');
INSERT INTO `OrderInfo` (`OrderId`, `CustomerId`, `AddressId`, `TotalAmount`, `PaymentId`, `TrackingNum`, `OrderStatus`, `ShippedAt`, `ReceivedAt`, `CreatedAt`, `UpdatedAt`) VALUES (4, 4, 5, 599.00, 4, 'TRK20240710004', 'delivered', '2024-07-11 08:30:00', '2024-07-15 13:00:00', '2024-07-10 16:20:00', '2025-12-13 23:18:42');
INSERT INTO `OrderInfo` (`OrderId`, `CustomerId`, `AddressId`, `TotalAmount`, `PaymentId`, `TrackingNum`, `OrderStatus`, `ShippedAt`, `ReceivedAt`, `CreatedAt`, `UpdatedAt`) VALUES (5, 5, 7, 1999.00, 5, 'TRK20240715005', 'delivered', '2024-07-16 09:00:00', '2024-07-20 15:30:00', '2024-07-15 11:00:00', '2025-12-13 23:18:42');
INSERT INTO `OrderInfo` (`OrderId`, `CustomerId`, `AddressId`, `TotalAmount`, `PaymentId`, `TrackingNum`, `OrderStatus`, `ShippedAt`, `ReceivedAt`, `CreatedAt`, `UpdatedAt`) VALUES (6, 6, 8, 349.00, 6, 'TRK20240801006', 'delivered', '2024-08-02 10:30:00', '2024-08-06 12:00:00', '2024-08-01 13:30:00', '2025-12-13 23:18:42');
INSERT INTO `OrderInfo` (`OrderId`, `CustomerId`, `AddressId`, `TotalAmount`, `PaymentId`, `TrackingNum`, `OrderStatus`, `ShippedAt`, `ReceivedAt`, `CreatedAt`, `UpdatedAt`) VALUES (7, 7, 9, 499.00, 7, 'TRK20240810007', 'shipped', '2024-08-11 08:00:00', NULL, '2024-08-10 15:45:00', '2025-12-13 23:18:42');
INSERT INTO `OrderInfo` (`OrderId`, `CustomerId`, `AddressId`, `TotalAmount`, `PaymentId`, `TrackingNum`, `OrderStatus`, `ShippedAt`, `ReceivedAt`, `CreatedAt`, `UpdatedAt`) VALUES (8, 8, 10, 349.00, 8, 'TRK20240820008', 'cancelled', NULL, NULL, '2024-08-20 10:00:00', '2025-12-13 23:18:42');
INSERT INTO `OrderInfo` (`OrderId`, `CustomerId`, `AddressId`, `TotalAmount`, `PaymentId`, `TrackingNum`, `OrderStatus`, `ShippedAt`, `ReceivedAt`, `CreatedAt`, `UpdatedAt`) VALUES (9, 9, 11, 249.00, 9, 'TRK20240905009', 'delivered', '2024-09-06 09:30:00', '2024-09-10 14:00:00', '2024-09-05 12:15:00', '2025-12-13 23:18:42');
INSERT INTO `OrderInfo` (`OrderId`, `CustomerId`, `AddressId`, `TotalAmount`, `PaymentId`, `TrackingNum`, `OrderStatus`, `ShippedAt`, `ReceivedAt`, `CreatedAt`, `UpdatedAt`) VALUES (10, 10, 12, 399.00, 10, 'TRK20240915010', 'shipped', '2024-09-16 08:00:00', NULL, '2024-09-15 17:30:00', '2025-12-13 23:18:42');
INSERT INTO `OrderInfo` (`OrderId`, `CustomerId`, `AddressId`, `TotalAmount`, `PaymentId`, `TrackingNum`, `OrderStatus`, `ShippedAt`, `ReceivedAt`, `CreatedAt`, `UpdatedAt`) VALUES (11, 1, 1, 549.00, 11, 'TRK20250110011', 'pending', NULL, NULL, '2025-01-10 09:00:00', '2025-12-13 23:18:42');
INSERT INTO `OrderInfo` (`OrderId`, `CustomerId`, `AddressId`, `TotalAmount`, `PaymentId`, `TrackingNum`, `OrderStatus`, `ShippedAt`, `ReceivedAt`, `CreatedAt`, `UpdatedAt`) VALUES (12, 2, 3, 1499.00, 12, 'TRK20250120012', 'shipped', '2025-01-21 10:00:00', NULL, '2025-01-20 14:30:00', '2025-12-13 23:18:42');
INSERT INTO `OrderInfo` (`OrderId`, `CustomerId`, `AddressId`, `TotalAmount`, `PaymentId`, `TrackingNum`, `OrderStatus`, `ShippedAt`, `ReceivedAt`, `CreatedAt`, `UpdatedAt`) VALUES (13, 14, 14, 3397.00, 16, NULL, 'pending', NULL, NULL, '2025-12-13 23:45:53', '2025-12-13 23:45:53');
COMMIT;

-- ----------------------------
-- Table structure for PaymentInfo
-- ----------------------------
DROP TABLE IF EXISTS `PaymentInfo`;
CREATE TABLE `PaymentInfo` (
  `PaymentId` bigint NOT NULL AUTO_INCREMENT,
  `CustomerId` int NOT NULL,
  `PaymentMethod` varchar(50) NOT NULL,
  `PaymentAmount` decimal(10,2) NOT NULL,
  `PaymentStatus` varchar(20) DEFAULT 'pending',
  `PaymentTime` datetime DEFAULT NULL,
  `RefundTime` datetime DEFAULT NULL,
  `RefundAmount` decimal(10,2) DEFAULT '0.00',
  `FailureReason` varchar(255) DEFAULT NULL,
  `CreatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`PaymentId`,`CreatedAt`),
  KEY `idx_payment_customer` (`CustomerId`),
  KEY `idx_payment_status` (`PaymentStatus`),
  KEY `idx_payment_time` (`PaymentTime`),
  CONSTRAINT `paymentinfo_chk_1` CHECK ((`PaymentStatus` in (_utf8mb4'pending',_utf8mb4'completed',_utf8mb4'failed',_utf8mb4'refunded')))
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50100 PARTITION BY RANGE (year(`CreatedAt`))
(PARTITION p2023 VALUES LESS THAN (2024) ENGINE = InnoDB,
 PARTITION p2024 VALUES LESS THAN (2025) ENGINE = InnoDB,
 PARTITION p2025 VALUES LESS THAN (2026) ENGINE = InnoDB,
 PARTITION p_future VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */;

-- ----------------------------
-- Records of PaymentInfo
-- ----------------------------
BEGIN;
INSERT INTO `PaymentInfo` (`PaymentId`, `CustomerId`, `PaymentMethod`, `PaymentAmount`, `PaymentStatus`, `PaymentTime`, `RefundTime`, `RefundAmount`, `FailureReason`, `CreatedAt`, `UpdatedAt`) VALUES (1, 1, 'credit_card', 1199.00, 'completed', '2024-06-15 10:30:00', NULL, 0.00, NULL, '2024-06-15 10:25:00', '2025-12-13 23:18:42');
INSERT INTO `PaymentInfo` (`PaymentId`, `CustomerId`, `PaymentMethod`, `PaymentAmount`, `PaymentStatus`, `PaymentTime`, `RefundTime`, `RefundAmount`, `FailureReason`, `CreatedAt`, `UpdatedAt`) VALUES (2, 2, 'paypal', 799.00, 'completed', '2024-06-16 14:45:00', NULL, 0.00, NULL, '2024-06-16 14:40:00', '2025-12-13 23:18:42');
INSERT INTO `PaymentInfo` (`PaymentId`, `CustomerId`, `PaymentMethod`, `PaymentAmount`, `PaymentStatus`, `PaymentTime`, `RefundTime`, `RefundAmount`, `FailureReason`, `CreatedAt`, `UpdatedAt`) VALUES (3, 3, 'credit_card', 1299.00, 'completed', '2024-07-01 09:15:00', NULL, 0.00, NULL, '2024-07-01 09:10:00', '2025-12-13 23:18:42');
INSERT INTO `PaymentInfo` (`PaymentId`, `CustomerId`, `PaymentMethod`, `PaymentAmount`, `PaymentStatus`, `PaymentTime`, `RefundTime`, `RefundAmount`, `FailureReason`, `CreatedAt`, `UpdatedAt`) VALUES (4, 4, 'debit_card', 599.00, 'completed', '2024-07-10 16:20:00', NULL, 0.00, NULL, '2024-07-10 16:15:00', '2025-12-13 23:18:42');
INSERT INTO `PaymentInfo` (`PaymentId`, `CustomerId`, `PaymentMethod`, `PaymentAmount`, `PaymentStatus`, `PaymentTime`, `RefundTime`, `RefundAmount`, `FailureReason`, `CreatedAt`, `UpdatedAt`) VALUES (5, 5, 'credit_card', 1999.00, 'completed', '2024-07-15 11:00:00', NULL, 0.00, NULL, '2024-07-15 10:55:00', '2025-12-13 23:18:42');
INSERT INTO `PaymentInfo` (`PaymentId`, `CustomerId`, `PaymentMethod`, `PaymentAmount`, `PaymentStatus`, `PaymentTime`, `RefundTime`, `RefundAmount`, `FailureReason`, `CreatedAt`, `UpdatedAt`) VALUES (6, 6, 'paypal', 349.00, 'completed', '2024-08-01 13:30:00', NULL, 0.00, NULL, '2024-08-01 13:25:00', '2025-12-13 23:18:42');
INSERT INTO `PaymentInfo` (`PaymentId`, `CustomerId`, `PaymentMethod`, `PaymentAmount`, `PaymentStatus`, `PaymentTime`, `RefundTime`, `RefundAmount`, `FailureReason`, `CreatedAt`, `UpdatedAt`) VALUES (7, 7, 'credit_card', 499.00, 'completed', '2024-08-10 15:45:00', NULL, 0.00, NULL, '2024-08-10 15:40:00', '2025-12-13 23:18:42');
INSERT INTO `PaymentInfo` (`PaymentId`, `CustomerId`, `PaymentMethod`, `PaymentAmount`, `PaymentStatus`, `PaymentTime`, `RefundTime`, `RefundAmount`, `FailureReason`, `CreatedAt`, `UpdatedAt`) VALUES (8, 8, 'credit_card', 349.00, 'refunded', '2024-08-20 10:00:00', '2024-08-25 14:00:00', 349.00, NULL, '2024-08-20 09:55:00', '2025-12-13 23:18:42');
INSERT INTO `PaymentInfo` (`PaymentId`, `CustomerId`, `PaymentMethod`, `PaymentAmount`, `PaymentStatus`, `PaymentTime`, `RefundTime`, `RefundAmount`, `FailureReason`, `CreatedAt`, `UpdatedAt`) VALUES (9, 9, 'debit_card', 249.00, 'completed', '2024-09-05 12:15:00', NULL, 0.00, NULL, '2024-09-05 12:10:00', '2025-12-13 23:18:42');
INSERT INTO `PaymentInfo` (`PaymentId`, `CustomerId`, `PaymentMethod`, `PaymentAmount`, `PaymentStatus`, `PaymentTime`, `RefundTime`, `RefundAmount`, `FailureReason`, `CreatedAt`, `UpdatedAt`) VALUES (10, 10, 'credit_card', 399.00, 'completed', '2024-09-15 17:30:00', NULL, 0.00, NULL, '2024-09-15 17:25:00', '2025-12-13 23:18:42');
INSERT INTO `PaymentInfo` (`PaymentId`, `CustomerId`, `PaymentMethod`, `PaymentAmount`, `PaymentStatus`, `PaymentTime`, `RefundTime`, `RefundAmount`, `FailureReason`, `CreatedAt`, `UpdatedAt`) VALUES (11, 1, 'paypal', 549.00, 'completed', '2025-01-10 09:00:00', NULL, 0.00, NULL, '2025-01-10 08:55:00', '2025-12-13 23:18:42');
INSERT INTO `PaymentInfo` (`PaymentId`, `CustomerId`, `PaymentMethod`, `PaymentAmount`, `PaymentStatus`, `PaymentTime`, `RefundTime`, `RefundAmount`, `FailureReason`, `CreatedAt`, `UpdatedAt`) VALUES (12, 2, 'credit_card', 1499.00, 'completed', '2025-01-20 14:30:00', NULL, 0.00, NULL, '2025-01-20 14:25:00', '2025-12-13 23:18:42');
INSERT INTO `PaymentInfo` (`PaymentId`, `CustomerId`, `PaymentMethod`, `PaymentAmount`, `PaymentStatus`, `PaymentTime`, `RefundTime`, `RefundAmount`, `FailureReason`, `CreatedAt`, `UpdatedAt`) VALUES (13, 3, 'credit_card', 299.00, 'failed', NULL, NULL, 0.00, 'Insufficient funds', '2025-02-01 10:00:00', '2025-12-13 23:18:42');
INSERT INTO `PaymentInfo` (`PaymentId`, `CustomerId`, `PaymentMethod`, `PaymentAmount`, `PaymentStatus`, `PaymentTime`, `RefundTime`, `RefundAmount`, `FailureReason`, `CreatedAt`, `UpdatedAt`) VALUES (14, 4, 'debit_card', 149.00, 'completed', '2025-02-10 11:45:00', NULL, 0.00, NULL, '2025-02-10 11:40:00', '2025-12-13 23:18:42');
INSERT INTO `PaymentInfo` (`PaymentId`, `CustomerId`, `PaymentMethod`, `PaymentAmount`, `PaymentStatus`, `PaymentTime`, `RefundTime`, `RefundAmount`, `FailureReason`, `CreatedAt`, `UpdatedAt`) VALUES (15, 5, 'credit_card', 849.00, 'pending', NULL, NULL, 0.00, NULL, '2025-03-01 16:00:00', '2025-12-13 23:18:42');
INSERT INTO `PaymentInfo` (`PaymentId`, `CustomerId`, `PaymentMethod`, `PaymentAmount`, `PaymentStatus`, `PaymentTime`, `RefundTime`, `RefundAmount`, `FailureReason`, `CreatedAt`, `UpdatedAt`) VALUES (16, 14, 'credit_card', 3397.00, 'completed', NULL, NULL, 0.00, NULL, '2025-12-13 23:45:53', '2025-12-13 23:45:53');
COMMIT;

-- ----------------------------
-- Table structure for ProductCategory
-- ----------------------------
DROP TABLE IF EXISTS `ProductCategory`;
CREATE TABLE `ProductCategory` (
  `CategoryId` int NOT NULL AUTO_INCREMENT,
  `CategoryName` varchar(100) NOT NULL,
  `ParentId` int DEFAULT NULL,
  `CategoryLevel` int NOT NULL,
  `CreatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CategoryImage` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`CategoryId`),
  UNIQUE KEY `CategoryName` (`CategoryName`,`CategoryLevel`),
  KEY `idx_category_parent` (`ParentId`),
  KEY `idx_category_level` (`CategoryLevel`),
  CONSTRAINT `productcategory_ibfk_1` FOREIGN KEY (`ParentId`) REFERENCES `ProductCategory` (`CategoryId`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of ProductCategory
-- ----------------------------
BEGIN;
INSERT INTO `ProductCategory` (`CategoryId`, `CategoryName`, `ParentId`, `CategoryLevel`, `CreatedAt`, `UpdatedAt`, `CategoryImage`) VALUES (1, 'Electronics', NULL, 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42', NULL);
INSERT INTO `ProductCategory` (`CategoryId`, `CategoryName`, `ParentId`, `CategoryLevel`, `CreatedAt`, `UpdatedAt`, `CategoryImage`) VALUES (2, 'Computers', NULL, 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42', NULL);
INSERT INTO `ProductCategory` (`CategoryId`, `CategoryName`, `ParentId`, `CategoryLevel`, `CreatedAt`, `UpdatedAt`, `CategoryImage`) VALUES (3, 'Gaming', NULL, 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42', NULL);
INSERT INTO `ProductCategory` (`CategoryId`, `CategoryName`, `ParentId`, `CategoryLevel`, `CreatedAt`, `UpdatedAt`, `CategoryImage`) VALUES (4, 'Audio', NULL, 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42', NULL);
INSERT INTO `ProductCategory` (`CategoryId`, `CategoryName`, `ParentId`, `CategoryLevel`, `CreatedAt`, `UpdatedAt`, `CategoryImage`) VALUES (5, 'Wearables', NULL, 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42', NULL);
INSERT INTO `ProductCategory` (`CategoryId`, `CategoryName`, `ParentId`, `CategoryLevel`, `CreatedAt`, `UpdatedAt`, `CategoryImage`) VALUES (6, 'Smartphones', 1, 2, '2025-12-13 23:18:42', '2025-12-13 23:18:42', NULL);
INSERT INTO `ProductCategory` (`CategoryId`, `CategoryName`, `ParentId`, `CategoryLevel`, `CreatedAt`, `UpdatedAt`, `CategoryImage`) VALUES (7, 'Tablets', 1, 2, '2025-12-13 23:18:42', '2025-12-13 23:18:42', NULL);
INSERT INTO `ProductCategory` (`CategoryId`, `CategoryName`, `ParentId`, `CategoryLevel`, `CreatedAt`, `UpdatedAt`, `CategoryImage`) VALUES (8, 'Laptops', 2, 2, '2025-12-13 23:18:42', '2025-12-13 23:18:42', NULL);
INSERT INTO `ProductCategory` (`CategoryId`, `CategoryName`, `ParentId`, `CategoryLevel`, `CreatedAt`, `UpdatedAt`, `CategoryImage`) VALUES (9, 'Desktops', 2, 2, '2025-12-13 23:18:42', '2025-12-13 23:18:42', NULL);
INSERT INTO `ProductCategory` (`CategoryId`, `CategoryName`, `ParentId`, `CategoryLevel`, `CreatedAt`, `UpdatedAt`, `CategoryImage`) VALUES (10, 'Consoles', 3, 2, '2025-12-13 23:18:42', '2025-12-18 13:37:47', 'category_10.jpeg');
INSERT INTO `ProductCategory` (`CategoryId`, `CategoryName`, `ParentId`, `CategoryLevel`, `CreatedAt`, `UpdatedAt`, `CategoryImage`) VALUES (11, 'Games', 3, 2, '2025-12-13 23:18:42', '2025-12-13 23:18:42', NULL);
INSERT INTO `ProductCategory` (`CategoryId`, `CategoryName`, `ParentId`, `CategoryLevel`, `CreatedAt`, `UpdatedAt`, `CategoryImage`) VALUES (12, 'Headphones', 4, 2, '2025-12-13 23:18:42', '2025-12-18 13:22:34', 'category_12.jpg');
INSERT INTO `ProductCategory` (`CategoryId`, `CategoryName`, `ParentId`, `CategoryLevel`, `CreatedAt`, `UpdatedAt`, `CategoryImage`) VALUES (13, 'Speakers', 4, 2, '2025-12-13 23:18:42', '2025-12-18 13:22:34', 'category_13.jpg');
INSERT INTO `ProductCategory` (`CategoryId`, `CategoryName`, `ParentId`, `CategoryLevel`, `CreatedAt`, `UpdatedAt`, `CategoryImage`) VALUES (14, 'Smartwatches', 5, 2, '2025-12-13 23:18:42', '2025-12-18 13:22:34', 'category_14.jpg');
INSERT INTO `ProductCategory` (`CategoryId`, `CategoryName`, `ParentId`, `CategoryLevel`, `CreatedAt`, `UpdatedAt`, `CategoryImage`) VALUES (15, 'Fitness Trackers', 5, 2, '2025-12-13 23:18:42', '2025-12-18 13:22:34', 'category_15.jpg');
INSERT INTO `ProductCategory` (`CategoryId`, `CategoryName`, `ParentId`, `CategoryLevel`, `CreatedAt`, `UpdatedAt`, `CategoryImage`) VALUES (16, 'iOS Phones', 6, 3, '2025-12-13 23:18:42', '2025-12-18 13:37:47', 'category_16.png');
INSERT INTO `ProductCategory` (`CategoryId`, `CategoryName`, `ParentId`, `CategoryLevel`, `CreatedAt`, `UpdatedAt`, `CategoryImage`) VALUES (17, 'Android Phones', 6, 3, '2025-12-13 23:18:42', '2025-12-18 13:37:47', 'category_17.png');
INSERT INTO `ProductCategory` (`CategoryId`, `CategoryName`, `ParentId`, `CategoryLevel`, `CreatedAt`, `UpdatedAt`, `CategoryImage`) VALUES (18, 'iPad', 7, 3, '2025-12-13 23:18:42', '2025-12-18 13:22:34', 'category_18.jpg');
INSERT INTO `ProductCategory` (`CategoryId`, `CategoryName`, `ParentId`, `CategoryLevel`, `CreatedAt`, `UpdatedAt`, `CategoryImage`) VALUES (19, 'Android Tablets', 7, 3, '2025-12-13 23:18:42', '2025-12-18 13:22:34', 'category_19.jpg');
INSERT INTO `ProductCategory` (`CategoryId`, `CategoryName`, `ParentId`, `CategoryLevel`, `CreatedAt`, `UpdatedAt`, `CategoryImage`) VALUES (20, 'Gaming Laptops', 8, 3, '2025-12-13 23:18:42', '2025-12-18 13:22:34', 'category_20.jpg');
INSERT INTO `ProductCategory` (`CategoryId`, `CategoryName`, `ParentId`, `CategoryLevel`, `CreatedAt`, `UpdatedAt`, `CategoryImage`) VALUES (21, 'Business Laptops', 8, 3, '2025-12-13 23:18:42', '2025-12-18 13:22:34', 'category_21.jpg');
COMMIT;

-- ----------------------------
-- Table structure for ProductInfo
-- ----------------------------
DROP TABLE IF EXISTS `ProductInfo`;
CREATE TABLE `ProductInfo` (
  `ProductId` int NOT NULL AUTO_INCREMENT,
  `ProductName` varchar(255) NOT NULL,
  `BrandId` int NOT NULL,
  `CategoryId` int NOT NULL,
  `Price` decimal(10,2) NOT NULL,
  `ProductDesc` text,
  `PublishStatus` int DEFAULT '1',
  `CreatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ProductId`),
  KEY `idx_product_brand` (`BrandId`),
  KEY `idx_product_category` (`CategoryId`),
  KEY `idx_product_price` (`Price`),
  KEY `idx_product_status` (`PublishStatus`),
  FULLTEXT KEY `idx_product_search` (`ProductName`,`ProductDesc`),
  CONSTRAINT `productinfo_ibfk_1` FOREIGN KEY (`BrandId`) REFERENCES `BrandInfo` (`BrandId`) ON DELETE RESTRICT,
  CONSTRAINT `productinfo_ibfk_2` FOREIGN KEY (`CategoryId`) REFERENCES `ProductCategory` (`CategoryId`) ON DELETE RESTRICT,
  CONSTRAINT `productinfo_chk_1` CHECK ((`PublishStatus` in (0,1)))
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of ProductInfo
-- ----------------------------
BEGIN;
INSERT INTO `ProductInfo` (`ProductId`, `ProductName`, `BrandId`, `CategoryId`, `Price`, `ProductDesc`, `PublishStatus`, `CreatedAt`, `UpdatedAt`) VALUES (1, 'iPhone 15 Pro Max', 1, 16, 1199.00, 'Latest Apple smartphone with A17 Pro chip, titanium design, and advanced camera system', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductInfo` (`ProductId`, `ProductName`, `BrandId`, `CategoryId`, `Price`, `ProductDesc`, `PublishStatus`, `CreatedAt`, `UpdatedAt`) VALUES (2, 'iPhone 15', 1, 16, 799.00, 'Apple smartphone with A16 chip and Dynamic Island', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductInfo` (`ProductId`, `ProductName`, `BrandId`, `CategoryId`, `Price`, `ProductDesc`, `PublishStatus`, `CreatedAt`, `UpdatedAt`) VALUES (3, 'Samsung Galaxy S24 Ultra', 2, 17, 1299.00, 'Premium Android phone with S Pen and AI features', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductInfo` (`ProductId`, `ProductName`, `BrandId`, `CategoryId`, `Price`, `ProductDesc`, `PublishStatus`, `CreatedAt`, `UpdatedAt`) VALUES (4, 'Samsung Galaxy S24', 2, 17, 899.00, 'Flagship Android smartphone with Galaxy AI', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductInfo` (`ProductId`, `ProductName`, `BrandId`, `CategoryId`, `Price`, `ProductDesc`, `PublishStatus`, `CreatedAt`, `UpdatedAt`) VALUES (5, 'iPad Pro 12.9\"', 1, 18, 1099.00, 'Professional tablet with M2 chip and Liquid Retina XDR display', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductInfo` (`ProductId`, `ProductName`, `BrandId`, `CategoryId`, `Price`, `ProductDesc`, `PublishStatus`, `CreatedAt`, `UpdatedAt`) VALUES (6, 'iPad Air', 1, 18, 599.00, 'Versatile tablet with M1 chip', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductInfo` (`ProductId`, `ProductName`, `BrandId`, `CategoryId`, `Price`, `ProductDesc`, `PublishStatus`, `CreatedAt`, `UpdatedAt`) VALUES (7, 'Samsung Galaxy Tab S9', 2, 19, 849.00, 'Premium Android tablet with AMOLED display', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductInfo` (`ProductId`, `ProductName`, `BrandId`, `CategoryId`, `Price`, `ProductDesc`, `PublishStatus`, `CreatedAt`, `UpdatedAt`) VALUES (8, 'MacBook Pro 14\"', 1, 20, 1999.00, 'Professional laptop with M3 Pro chip', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductInfo` (`ProductId`, `ProductName`, `BrandId`, `CategoryId`, `Price`, `ProductDesc`, `PublishStatus`, `CreatedAt`, `UpdatedAt`) VALUES (9, 'MacBook Air 15\"', 1, 21, 1299.00, 'Thin and light laptop with M2 chip', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductInfo` (`ProductId`, `ProductName`, `BrandId`, `CategoryId`, `Price`, `ProductDesc`, `PublishStatus`, `CreatedAt`, `UpdatedAt`) VALUES (10, 'Dell XPS 15', 5, 21, 1499.00, 'Premium Windows laptop with OLED display', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductInfo` (`ProductId`, `ProductName`, `BrandId`, `CategoryId`, `Price`, `ProductDesc`, `PublishStatus`, `CreatedAt`, `UpdatedAt`) VALUES (11, 'Lenovo ThinkPad X1 Carbon', 10, 21, 1649.00, 'Business ultrabook with Intel Core processor', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductInfo` (`ProductId`, `ProductName`, `BrandId`, `CategoryId`, `Price`, `ProductDesc`, `PublishStatus`, `CreatedAt`, `UpdatedAt`) VALUES (12, 'PlayStation 5', 3, 10, 499.00, 'Next-gen gaming console with 4K gaming', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductInfo` (`ProductId`, `ProductName`, `BrandId`, `CategoryId`, `Price`, `ProductDesc`, `PublishStatus`, `CreatedAt`, `UpdatedAt`) VALUES (13, 'Nintendo Switch OLED', 6, 10, 349.00, 'Hybrid gaming console with OLED screen', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductInfo` (`ProductId`, `ProductName`, `BrandId`, `CategoryId`, `Price`, `ProductDesc`, `PublishStatus`, `CreatedAt`, `UpdatedAt`) VALUES (14, 'Xbox Series X', 4, 10, 499.00, 'Powerful gaming console with Game Pass', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductInfo` (`ProductId`, `ProductName`, `BrandId`, `CategoryId`, `Price`, `ProductDesc`, `PublishStatus`, `CreatedAt`, `UpdatedAt`) VALUES (15, 'Sony WH-1000XM5', 3, 12, 349.00, 'Premium wireless noise-cancelling headphones', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductInfo` (`ProductId`, `ProductName`, `BrandId`, `CategoryId`, `Price`, `ProductDesc`, `PublishStatus`, `CreatedAt`, `UpdatedAt`) VALUES (16, 'AirPods Pro 2', 1, 12, 249.00, 'True wireless earbuds with active noise cancellation', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductInfo` (`ProductId`, `ProductName`, `BrandId`, `CategoryId`, `Price`, `ProductDesc`, `PublishStatus`, `CreatedAt`, `UpdatedAt`) VALUES (17, 'Bose SoundLink Flex', 7, 13, 149.00, 'Portable Bluetooth speaker with deep bass', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductInfo` (`ProductId`, `ProductName`, `BrandId`, `CategoryId`, `Price`, `ProductDesc`, `PublishStatus`, `CreatedAt`, `UpdatedAt`) VALUES (18, 'Apple Watch Series 9', 1, 14, 399.00, 'Advanced smartwatch with health monitoring', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductInfo` (`ProductId`, `ProductName`, `BrandId`, `CategoryId`, `Price`, `ProductDesc`, `PublishStatus`, `CreatedAt`, `UpdatedAt`) VALUES (19, 'Samsung Galaxy Watch 6', 2, 14, 299.00, 'Android smartwatch with fitness tracking', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductInfo` (`ProductId`, `ProductName`, `BrandId`, `CategoryId`, `Price`, `ProductDesc`, `PublishStatus`, `CreatedAt`, `UpdatedAt`) VALUES (20, 'AirPods Max', 1, 12, 549.00, 'Over-ear headphones with spatial audio', 1, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
COMMIT;

-- ----------------------------
-- Table structure for ProductRating
-- ----------------------------
DROP TABLE IF EXISTS `ProductRating`;
CREATE TABLE `ProductRating` (
  `RatingId` bigint NOT NULL AUTO_INCREMENT,
  `CustomerId` int NOT NULL,
  `ProductId` int NOT NULL,
  `RatingScore` int NOT NULL,
  `Review` text,
  `CreatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`RatingId`),
  UNIQUE KEY `CustomerId` (`CustomerId`,`ProductId`),
  KEY `idx_rating_product` (`ProductId`),
  KEY `idx_rating_customer` (`CustomerId`),
  KEY `idx_rating_score` (`RatingScore`),
  CONSTRAINT `productrating_ibfk_1` FOREIGN KEY (`CustomerId`) REFERENCES `CustomerInfo` (`CustomerId`) ON DELETE CASCADE,
  CONSTRAINT `productrating_ibfk_2` FOREIGN KEY (`ProductId`) REFERENCES `ProductInfo` (`ProductId`) ON DELETE CASCADE,
  CONSTRAINT `productrating_chk_1` CHECK ((`RatingScore` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of ProductRating
-- ----------------------------
BEGIN;
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (2, 2, 1, 4, 'Great phone but a bit expensive.', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (3, 3, 1, 5, 'Best iPhone ever! Love the titanium design.', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (4, 4, 3, 5, 'The S Pen integration is fantastic for note-taking.', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (5, 5, 3, 4, 'Great phone, but Samsung bloatware is annoying.', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (6, 6, 5, 5, 'Perfect for creative work. The display is stunning.', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (7, 7, 5, 5, 'M2 chip is incredibly fast for video editing.', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (8, 8, 8, 5, 'Best laptop I have ever owned. Worth every penny.', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (9, 9, 8, 4, 'Excellent performance but gets warm under heavy load.', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (10, 10, 9, 5, 'Love the 15-inch screen size. Perfect for productivity.', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (12, 2, 12, 4, 'Great console but hard to find games on disc.', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (13, 3, 13, 5, 'Perfect for gaming on the go. OLED screen is beautiful.', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (14, 4, 13, 5, 'Great for family gaming nights!', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (15, 5, 15, 5, 'Best noise cancellation on the market. Super comfortable.', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (16, 6, 15, 4, 'Amazing sound quality but touch controls take time to learn.', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (17, 7, 16, 5, 'Perfect fit and amazing sound. Love the transparency mode.', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (18, 8, 16, 4, 'Great earbuds but wish battery lasted longer.', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (19, 9, 17, 4, 'Good portable speaker. Bass is impressive for its size.', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (20, 10, 17, 5, 'Waterproof and sounds great outdoors!', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (22, 2, 18, 4, 'Great watch but battery only lasts a day.', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (23, 3, 19, 4, 'Good smartwatch for Android users. Sleep tracking is accurate.', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (24, 4, 2, 5, 'Great value iPhone. Dynamic Island is useful.', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (25, 5, 4, 4, 'Solid phone with good camera.', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (26, 6, 6, 5, 'Perfect tablet for students.', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (27, 7, 10, 4, 'Beautiful display but runs hot sometimes.', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (28, 8, 11, 5, 'Best business laptop. Keyboard is amazing.', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (29, 9, 14, 5, 'Game Pass is the best deal in gaming.', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ProductRating` (`RatingId`, `CustomerId`, `ProductId`, `RatingScore`, `Review`, `CreatedAt`, `UpdatedAt`) VALUES (30, 10, 20, 5, 'Premium headphones with premium sound. Worth it!', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
COMMIT;

-- ----------------------------
-- Table structure for ProductRecommendation
-- ----------------------------
DROP TABLE IF EXISTS `ProductRecommendation`;
CREATE TABLE `ProductRecommendation` (
  `RecommendationId` bigint NOT NULL AUTO_INCREMENT,
  `CustomerId` int NOT NULL,
  `ProductId` int NOT NULL,
  `RecommendationType` varchar(50) NOT NULL,
  `RecommendationScore` decimal(5,4) NOT NULL,
  `RecommendationReason` varchar(200) DEFAULT NULL,
  `IsClicked` tinyint(1) DEFAULT '0',
  `IsPurchased` tinyint(1) DEFAULT '0',
  `CreatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ExpiresAt` datetime NOT NULL,
  PRIMARY KEY (`RecommendationId`,`CreatedAt`),
  KEY `idx_rec_customer` (`CustomerId`),
  KEY `idx_rec_product` (`ProductId`),
  KEY `idx_rec_type` (`RecommendationType`),
  KEY `idx_rec_score` (`RecommendationScore`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50100 PARTITION BY RANGE (year(`CreatedAt`))
(PARTITION p2024 VALUES LESS THAN (2025) ENGINE = InnoDB,
 PARTITION p2025 VALUES LESS THAN (2026) ENGINE = InnoDB,
 PARTITION p_future VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */;

-- ----------------------------
-- Records of ProductRecommendation
-- ----------------------------
BEGIN;
INSERT INTO `ProductRecommendation` (`RecommendationId`, `CustomerId`, `ProductId`, `RecommendationType`, `RecommendationScore`, `RecommendationReason`, `IsClicked`, `IsPurchased`, `CreatedAt`, `ExpiresAt`) VALUES (1, 1, 3, 'collaborative_filtering', 0.9523, 'Based on similar users purchases', 1, 0, '2025-01-01 00:00:00', '2025-12-31 23:59:59');
INSERT INTO `ProductRecommendation` (`RecommendationId`, `CustomerId`, `ProductId`, `RecommendationType`, `RecommendationScore`, `RecommendationReason`, `IsClicked`, `IsPurchased`, `CreatedAt`, `ExpiresAt`) VALUES (2, 1, 8, 'content_based', 0.8876, 'You may like this Apple product', 0, 0, '2025-01-01 00:00:00', '2025-12-31 23:59:59');
INSERT INTO `ProductRecommendation` (`RecommendationId`, `CustomerId`, `ProductId`, `RecommendationType`, `RecommendationScore`, `RecommendationReason`, `IsClicked`, `IsPurchased`, `CreatedAt`, `ExpiresAt`) VALUES (3, 1, 15, 'xgboost_model', 0.8234, 'ML recommendation based on your behavior', 1, 1, '2025-01-01 00:00:00', '2025-12-31 23:59:59');
INSERT INTO `ProductRecommendation` (`RecommendationId`, `CustomerId`, `ProductId`, `RecommendationType`, `RecommendationScore`, `RecommendationReason`, `IsClicked`, `IsPurchased`, `CreatedAt`, `ExpiresAt`) VALUES (4, 1, 18, 'hybrid', 0.7891, 'Recommended for you', 0, 0, '2025-01-01 00:00:00', '2025-12-31 23:59:59');
INSERT INTO `ProductRecommendation` (`RecommendationId`, `CustomerId`, `ProductId`, `RecommendationType`, `RecommendationScore`, `RecommendationReason`, `IsClicked`, `IsPurchased`, `CreatedAt`, `ExpiresAt`) VALUES (5, 2, 1, 'collaborative_filtering', 0.9234, 'Popular among similar users', 1, 0, '2025-01-01 00:00:00', '2025-12-31 23:59:59');
INSERT INTO `ProductRecommendation` (`RecommendationId`, `CustomerId`, `ProductId`, `RecommendationType`, `RecommendationScore`, `RecommendationReason`, `IsClicked`, `IsPurchased`, `CreatedAt`, `ExpiresAt`) VALUES (6, 2, 5, 'content_based', 0.8567, 'Based on your browsing history', 0, 0, '2025-01-01 00:00:00', '2025-12-31 23:59:59');
INSERT INTO `ProductRecommendation` (`RecommendationId`, `CustomerId`, `ProductId`, `RecommendationType`, `RecommendationScore`, `RecommendationReason`, `IsClicked`, `IsPurchased`, `CreatedAt`, `ExpiresAt`) VALUES (7, 2, 12, 'xgboost_model', 0.8123, 'You might enjoy gaming', 1, 0, '2025-01-01 00:00:00', '2025-12-31 23:59:59');
INSERT INTO `ProductRecommendation` (`RecommendationId`, `CustomerId`, `ProductId`, `RecommendationType`, `RecommendationScore`, `RecommendationReason`, `IsClicked`, `IsPurchased`, `CreatedAt`, `ExpiresAt`) VALUES (8, 2, 16, 'hybrid', 0.7654, 'Frequently bought together', 0, 0, '2025-01-01 00:00:00', '2025-12-31 23:59:59');
INSERT INTO `ProductRecommendation` (`RecommendationId`, `CustomerId`, `ProductId`, `RecommendationType`, `RecommendationScore`, `RecommendationReason`, `IsClicked`, `IsPurchased`, `CreatedAt`, `ExpiresAt`) VALUES (9, 3, 4, 'collaborative_filtering', 0.9012, 'Similar users also bought', 0, 0, '2025-01-01 00:00:00', '2025-12-31 23:59:59');
INSERT INTO `ProductRecommendation` (`RecommendationId`, `CustomerId`, `ProductId`, `RecommendationType`, `RecommendationScore`, `RecommendationReason`, `IsClicked`, `IsPurchased`, `CreatedAt`, `ExpiresAt`) VALUES (10, 3, 9, 'content_based', 0.8456, 'Based on your preferences', 1, 0, '2025-01-01 00:00:00', '2025-12-31 23:59:59');
INSERT INTO `ProductRecommendation` (`RecommendationId`, `CustomerId`, `ProductId`, `RecommendationType`, `RecommendationScore`, `RecommendationReason`, `IsClicked`, `IsPurchased`, `CreatedAt`, `ExpiresAt`) VALUES (11, 3, 13, 'xgboost_model', 0.7890, 'Trending in your area', 0, 0, '2025-01-01 00:00:00', '2025-12-31 23:59:59');
INSERT INTO `ProductRecommendation` (`RecommendationId`, `CustomerId`, `ProductId`, `RecommendationType`, `RecommendationScore`, `RecommendationReason`, `IsClicked`, `IsPurchased`, `CreatedAt`, `ExpiresAt`) VALUES (12, 3, 19, 'hybrid', 0.7234, 'Recommended for you', 0, 0, '2025-01-01 00:00:00', '2025-12-31 23:59:59');
INSERT INTO `ProductRecommendation` (`RecommendationId`, `CustomerId`, `ProductId`, `RecommendationType`, `RecommendationScore`, `RecommendationReason`, `IsClicked`, `IsPurchased`, `CreatedAt`, `ExpiresAt`) VALUES (13, 4, 1, 'xgboost_model', 0.8765, 'Top pick for you', 1, 0, '2025-01-01 00:00:00', '2025-12-31 23:59:59');
INSERT INTO `ProductRecommendation` (`RecommendationId`, `CustomerId`, `ProductId`, `RecommendationType`, `RecommendationScore`, `RecommendationReason`, `IsClicked`, `IsPurchased`, `CreatedAt`, `ExpiresAt`) VALUES (14, 4, 8, 'collaborative_filtering', 0.8234, 'Users like you also viewed', 0, 0, '2025-01-01 00:00:00', '2025-12-31 23:59:59');
INSERT INTO `ProductRecommendation` (`RecommendationId`, `CustomerId`, `ProductId`, `RecommendationType`, `RecommendationScore`, `RecommendationReason`, `IsClicked`, `IsPurchased`, `CreatedAt`, `ExpiresAt`) VALUES (15, 4, 15, 'content_based', 0.7654, 'Matches your interests', 0, 0, '2025-01-01 00:00:00', '2025-12-31 23:59:59');
INSERT INTO `ProductRecommendation` (`RecommendationId`, `CustomerId`, `ProductId`, `RecommendationType`, `RecommendationScore`, `RecommendationReason`, `IsClicked`, `IsPurchased`, `CreatedAt`, `ExpiresAt`) VALUES (16, 4, 20, 'hybrid', 0.7123, 'You may also like', 0, 0, '2025-01-01 00:00:00', '2025-12-31 23:59:59');
INSERT INTO `ProductRecommendation` (`RecommendationId`, `CustomerId`, `ProductId`, `RecommendationType`, `RecommendationScore`, `RecommendationReason`, `IsClicked`, `IsPurchased`, `CreatedAt`, `ExpiresAt`) VALUES (17, 5, 3, 'xgboost_model', 0.9123, 'Highly recommended', 1, 1, '2025-01-01 00:00:00', '2025-12-31 23:59:59');
INSERT INTO `ProductRecommendation` (`RecommendationId`, `CustomerId`, `ProductId`, `RecommendationType`, `RecommendationScore`, `RecommendationReason`, `IsClicked`, `IsPurchased`, `CreatedAt`, `ExpiresAt`) VALUES (18, 5, 6, 'collaborative_filtering', 0.8567, 'Popular choice', 0, 0, '2025-01-01 00:00:00', '2025-12-31 23:59:59');
INSERT INTO `ProductRecommendation` (`RecommendationId`, `CustomerId`, `ProductId`, `RecommendationType`, `RecommendationScore`, `RecommendationReason`, `IsClicked`, `IsPurchased`, `CreatedAt`, `ExpiresAt`) VALUES (19, 5, 12, 'content_based', 0.7890, 'Based on your activity', 1, 0, '2025-01-01 00:00:00', '2025-12-31 23:59:59');
INSERT INTO `ProductRecommendation` (`RecommendationId`, `CustomerId`, `ProductId`, `RecommendationType`, `RecommendationScore`, `RecommendationReason`, `IsClicked`, `IsPurchased`, `CreatedAt`, `ExpiresAt`) VALUES (20, 5, 17, 'hybrid', 0.7345, 'Suggested for you', 0, 0, '2025-01-01 00:00:00', '2025-12-31 23:59:59');
INSERT INTO `ProductRecommendation` (`RecommendationId`, `CustomerId`, `ProductId`, `RecommendationType`, `RecommendationScore`, `RecommendationReason`, `IsClicked`, `IsPurchased`, `CreatedAt`, `ExpiresAt`) VALUES (21, 11, 1, 'xgboost_model', 0.9500, 'Best seller recommendation', 0, 0, '2025-01-01 00:00:00', '2025-12-31 23:59:59');
INSERT INTO `ProductRecommendation` (`RecommendationId`, `CustomerId`, `ProductId`, `RecommendationType`, `RecommendationScore`, `RecommendationReason`, `IsClicked`, `IsPurchased`, `CreatedAt`, `ExpiresAt`) VALUES (22, 11, 8, 'collaborative_filtering', 0.9100, 'Top rated product', 0, 0, '2025-01-01 00:00:00', '2025-12-31 23:59:59');
INSERT INTO `ProductRecommendation` (`RecommendationId`, `CustomerId`, `ProductId`, `RecommendationType`, `RecommendationScore`, `RecommendationReason`, `IsClicked`, `IsPurchased`, `CreatedAt`, `ExpiresAt`) VALUES (23, 11, 12, 'content_based', 0.8700, 'Popular gaming choice', 0, 0, '2025-01-01 00:00:00', '2025-12-31 23:59:59');
INSERT INTO `ProductRecommendation` (`RecommendationId`, `CustomerId`, `ProductId`, `RecommendationType`, `RecommendationScore`, `RecommendationReason`, `IsClicked`, `IsPurchased`, `CreatedAt`, `ExpiresAt`) VALUES (24, 11, 15, 'hybrid', 0.8300, 'Premium audio pick', 0, 0, '2025-01-01 00:00:00', '2025-12-31 23:59:59');
COMMIT;

-- ----------------------------
-- Table structure for ReturnItem
-- ----------------------------
DROP TABLE IF EXISTS `ReturnItem`;
CREATE TABLE `ReturnItem` (
  `ReturnItemId` bigint NOT NULL AUTO_INCREMENT,
  `ReturnId` bigint NOT NULL,
  `ProductId` int NOT NULL,
  `ProductName` varchar(255) NOT NULL,
  `Quantity` int NOT NULL,
  `Price` decimal(10,2) NOT NULL,
  `RefundAmount` decimal(10,2) DEFAULT NULL,
  `CreatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ReturnItemId`),
  KEY `idx_returnitem_return` (`ReturnId`),
  KEY `idx_returnitem_product` (`ProductId`),
  CONSTRAINT `returnitem_ibfk_1` FOREIGN KEY (`ReturnId`) REFERENCES `ReturnOrder` (`ReturnId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of ReturnItem
-- ----------------------------
BEGIN;
INSERT INTO `ReturnItem` (`ReturnItemId`, `ReturnId`, `ProductId`, `ProductName`, `Quantity`, `Price`, `RefundAmount`, `CreatedAt`, `UpdatedAt`) VALUES (1, 1, 15, 'Sony WH-1000XM5', 1, 349.00, 349.00, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ReturnItem` (`ReturnItemId`, `ReturnId`, `ProductId`, `ProductName`, `Quantity`, `Price`, `RefundAmount`, `CreatedAt`, `UpdatedAt`) VALUES (2, 2, 2, 'iPhone 15', 1, 799.00, 0.00, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ReturnItem` (`ReturnItemId`, `ReturnId`, `ProductId`, `ProductName`, `Quantity`, `Price`, `RefundAmount`, `CreatedAt`, `UpdatedAt`) VALUES (3, 3, 6, 'iPad Air', 1, 599.00, 599.00, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
COMMIT;

-- ----------------------------
-- Table structure for ReturnOrder
-- ----------------------------
DROP TABLE IF EXISTS `ReturnOrder`;
CREATE TABLE `ReturnOrder` (
  `ReturnId` bigint NOT NULL AUTO_INCREMENT,
  `OrderId` bigint NOT NULL,
  `CustomerId` int NOT NULL,
  `ReturnType` varchar(50) NOT NULL,
  `ReturnReason` text,
  `ReturnAmount` decimal(10,2) DEFAULT NULL,
  `ReturnStatus` varchar(20) DEFAULT 'pending',
  `CustomerNote` text,
  `AdminNote` text,
  `EvidenceUrls` text,
  `TrackingNumber` varchar(100) DEFAULT NULL,
  `RefundMethod` varchar(50) DEFAULT NULL,
  `RefundTransactionId` varchar(100) DEFAULT NULL,
  `ApprovedAt` timestamp NULL DEFAULT NULL,
  `RefundedAt` timestamp NULL DEFAULT NULL,
  `CreatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ReturnId`),
  KEY `idx_return_order` (`OrderId`),
  KEY `idx_return_customer` (`CustomerId`),
  KEY `idx_return_status` (`ReturnStatus`),
  CONSTRAINT `returnorder_chk_1` CHECK ((`ReturnStatus` in (_utf8mb4'pending',_utf8mb4'approved',_utf8mb4'rejected',_utf8mb4'refunded')))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of ReturnOrder
-- ----------------------------
BEGIN;
INSERT INTO `ReturnOrder` (`ReturnId`, `OrderId`, `CustomerId`, `ReturnType`, `ReturnReason`, `ReturnAmount`, `ReturnStatus`, `CustomerNote`, `AdminNote`, `EvidenceUrls`, `TrackingNumber`, `RefundMethod`, `RefundTransactionId`, `ApprovedAt`, `RefundedAt`, `CreatedAt`, `UpdatedAt`) VALUES (1, 8, 8, 'refund', 'Product not as described', 349.00, 'refunded', 'The noise cancellation is not working properly.', 'Verified defect, approved for full refund.', NULL, 'RTN20240825001', 'original_payment', NULL, '2024-08-23 10:00:00', '2024-08-25 14:00:00', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ReturnOrder` (`ReturnId`, `OrderId`, `CustomerId`, `ReturnType`, `ReturnReason`, `ReturnAmount`, `ReturnStatus`, `CustomerNote`, `AdminNote`, `EvidenceUrls`, `TrackingNumber`, `RefundMethod`, `RefundTransactionId`, `ApprovedAt`, `RefundedAt`, `CreatedAt`, `UpdatedAt`) VALUES (2, 2, 2, 'exchange', 'Wrong color received', 0.00, 'approved', 'Received white instead of black.', 'Shipping error confirmed. Exchange approved.', NULL, 'RTN20240625001', NULL, NULL, '2024-06-25 11:00:00', NULL, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ReturnOrder` (`ReturnId`, `OrderId`, `CustomerId`, `ReturnType`, `ReturnReason`, `ReturnAmount`, `ReturnStatus`, `CustomerNote`, `AdminNote`, `EvidenceUrls`, `TrackingNumber`, `RefundMethod`, `RefundTransactionId`, `ApprovedAt`, `RefundedAt`, `CreatedAt`, `UpdatedAt`) VALUES (3, 4, 4, 'refund', 'Changed mind', 599.00, 'pending', 'No longer need the tablet.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
COMMIT;

-- ----------------------------
-- Table structure for ShopCart
-- ----------------------------
DROP TABLE IF EXISTS `ShopCart`;
CREATE TABLE `ShopCart` (
  `CartId` bigint NOT NULL AUTO_INCREMENT,
  `CustomerId` int NOT NULL,
  `ProductId` int NOT NULL,
  `ProductNum` int NOT NULL,
  `Price` decimal(10,2) NOT NULL,
  `CreatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`CartId`),
  UNIQUE KEY `CustomerId` (`CustomerId`,`ProductId`),
  KEY `idx_cart_customer` (`CustomerId`),
  KEY `idx_cart_product` (`ProductId`),
  CONSTRAINT `shopcart_ibfk_1` FOREIGN KEY (`CustomerId`) REFERENCES `CustomerInfo` (`CustomerId`) ON DELETE CASCADE,
  CONSTRAINT `shopcart_ibfk_2` FOREIGN KEY (`ProductId`) REFERENCES `ProductInfo` (`ProductId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of ShopCart
-- ----------------------------
BEGIN;
INSERT INTO `ShopCart` (`CartId`, `CustomerId`, `ProductId`, `ProductNum`, `Price`, `CreatedAt`, `UpdatedAt`) VALUES (3, 2, 8, 1, 1999.00, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ShopCart` (`CartId`, `CustomerId`, `ProductId`, `ProductNum`, `Price`, `CreatedAt`, `UpdatedAt`) VALUES (4, 3, 12, 1, 499.00, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ShopCart` (`CartId`, `CustomerId`, `ProductId`, `ProductNum`, `Price`, `CreatedAt`, `UpdatedAt`) VALUES (5, 3, 15, 1, 349.00, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ShopCart` (`CartId`, `CustomerId`, `ProductId`, `ProductNum`, `Price`, `CreatedAt`, `UpdatedAt`) VALUES (6, 4, 18, 1, 399.00, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ShopCart` (`CartId`, `CustomerId`, `ProductId`, `ProductNum`, `Price`, `CreatedAt`, `UpdatedAt`) VALUES (7, 5, 9, 1, 1299.00, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ShopCart` (`CartId`, `CustomerId`, `ProductId`, `ProductNum`, `Price`, `CreatedAt`, `UpdatedAt`) VALUES (8, 6, 17, 2, 149.00, '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `ShopCart` (`CartId`, `CustomerId`, `ProductId`, `ProductNum`, `Price`, `CreatedAt`, `UpdatedAt`) VALUES (11, 14, 5, 1, 1099.00, '2025-12-14 15:55:31', '2025-12-14 15:55:31');
COMMIT;

-- ----------------------------
-- Table structure for UnstructuredDataRef
-- ----------------------------
DROP TABLE IF EXISTS `UnstructuredDataRef`;
CREATE TABLE `UnstructuredDataRef` (
  `DataRefId` bigint NOT NULL AUTO_INCREMENT,
  `RefType` varchar(50) NOT NULL,
  `RefId` int NOT NULL,
  `FilePath` varchar(500) NOT NULL,
  `DataPeriod` varchar(20) NOT NULL,
  `RecordCount` int DEFAULT NULL,
  `FileSize` bigint DEFAULT NULL,
  `CreatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`DataRefId`),
  KEY `idx_dataref_type` (`RefType`),
  KEY `idx_dataref_period` (`DataPeriod`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of UnstructuredDataRef
-- ----------------------------
BEGIN;
INSERT INTO `UnstructuredDataRef` (`DataRefId`, `RefType`, `RefId`, `FilePath`, `DataPeriod`, `RecordCount`, `FileSize`, `CreatedAt`) VALUES (1, 'user_behavior', 0, '/data/behavior/behavior_2024_11.json', '2024-11', 51926, 15728640, '2025-12-13 23:18:42');
INSERT INTO `UnstructuredDataRef` (`DataRefId`, `RefType`, `RefId`, `FilePath`, `DataPeriod`, `RecordCount`, `FileSize`, `CreatedAt`) VALUES (2, 'user_behavior', 0, '/data/behavior/behavior_2024_12.json', '2024-12', 48532, 14680064, '2025-12-13 23:18:42');
INSERT INTO `UnstructuredDataRef` (`DataRefId`, `RefType`, `RefId`, `FilePath`, `DataPeriod`, `RecordCount`, `FileSize`, `CreatedAt`) VALUES (3, 'user_features', 0, '/data/features/user_features.csv', '2024-12', 2000, 524288, '2025-12-13 23:18:42');
INSERT INTO `UnstructuredDataRef` (`DataRefId`, `RefType`, `RefId`, `FilePath`, `DataPeriod`, `RecordCount`, `FileSize`, `CreatedAt`) VALUES (4, 'product_features', 0, '/data/features/product_features.csv', '2024-12', 900, 262144, '2025-12-13 23:18:42');
INSERT INTO `UnstructuredDataRef` (`DataRefId`, `RefType`, `RefId`, `FilePath`, `DataPeriod`, `RecordCount`, `FileSize`, `CreatedAt`) VALUES (5, 'search_logs', 0, '/data/search/search_logs_2024_12.json', '2024-12', 125000, 41943040, '2025-12-13 23:18:42');
INSERT INTO `UnstructuredDataRef` (`DataRefId`, `RefType`, `RefId`, `FilePath`, `DataPeriod`, `RecordCount`, `FileSize`, `CreatedAt`) VALUES (6, 'search_logs', 0, './data/searches/searches_2025_12.json', '2025-12', 1, 229, '2025-12-14 15:55:11');
INSERT INTO `UnstructuredDataRef` (`DataRefId`, `RefType`, `RefId`, `FilePath`, `DataPeriod`, `RecordCount`, `FileSize`, `CreatedAt`) VALUES (7, 'user_behavior', 0, './data/behavior/behavior_2025_12.json', '2025-12', 5, 4116, '2025-12-14 15:55:28');
COMMIT;

-- ----------------------------
-- Table structure for WarehouseInfo
-- ----------------------------
DROP TABLE IF EXISTS `WarehouseInfo`;
CREATE TABLE `WarehouseInfo` (
  `WarehouseId` int NOT NULL AUTO_INCREMENT,
  `WarehouseName` varchar(100) NOT NULL,
  `WarehouseTel` varchar(20) DEFAULT NULL,
  `ContactName` varchar(100) DEFAULT NULL,
  `Street` varchar(200) DEFAULT NULL,
  `City` varchar(100) DEFAULT NULL,
  `State` varchar(50) DEFAULT NULL,
  `Zipcode` varchar(20) DEFAULT NULL,
  `CreatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`WarehouseId`),
  KEY `idx_warehouse_location` (`State`,`City`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of WarehouseInfo
-- ----------------------------
BEGIN;
INSERT INTO `WarehouseInfo` (`WarehouseId`, `WarehouseName`, `WarehouseTel`, `ContactName`, `Street`, `City`, `State`, `Zipcode`, `CreatedAt`, `UpdatedAt`) VALUES (1, 'East Coast Warehouse', '201-555-0101', 'Robert Wilson', '100 Industrial Parkway', 'Newark', 'NJ', '07101', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `WarehouseInfo` (`WarehouseId`, `WarehouseName`, `WarehouseTel`, `ContactName`, `Street`, `City`, `State`, `Zipcode`, `CreatedAt`, `UpdatedAt`) VALUES (2, 'West Coast Warehouse', '310-555-0102', 'Jennifer Lee', '200 Commerce Drive', 'Los Angeles', 'CA', '90001', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `WarehouseInfo` (`WarehouseId`, `WarehouseName`, `WarehouseTel`, `ContactName`, `Street`, `City`, `State`, `Zipcode`, `CreatedAt`, `UpdatedAt`) VALUES (3, 'Central Warehouse', '312-555-0103', 'William Brown', '300 Distribution Lane', 'Chicago', 'IL', '60601', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `WarehouseInfo` (`WarehouseId`, `WarehouseName`, `WarehouseTel`, `ContactName`, `Street`, `City`, `State`, `Zipcode`, `CreatedAt`, `UpdatedAt`) VALUES (4, 'South Warehouse', '713-555-0104', 'Patricia Davis', '400 Logistics Road', 'Houston', 'TX', '77001', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
INSERT INTO `WarehouseInfo` (`WarehouseId`, `WarehouseName`, `WarehouseTel`, `ContactName`, `Street`, `City`, `State`, `Zipcode`, `CreatedAt`, `UpdatedAt`) VALUES (5, 'Northwest Warehouse', '206-555-0105', 'Christopher Martin', '500 Shipping Way', 'Seattle', 'WA', '98101', '2025-12-13 23:18:42', '2025-12-13 23:18:42');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
