-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 20, 2024 at 06:30 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `skincarestore`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddProduct` (IN `p_name` VARCHAR(255), IN `p_price` DECIMAL(10,2), IN `p_stock` INT, IN `p_description` TEXT, IN `p_brand_id` INT)   BEGIN
    INSERT INTO products (name, price, stock, description, brand_id)
    VALUES (p_name, p_price, p_stock, p_description, p_brand_id);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddProductWithControlFlow` (IN `p_name` VARCHAR(255), IN `p_price` DECIMAL(10,2), IN `p_stock` INT, IN `p_description` TEXT, IN `p_brand_id` INT)   BEGIN
    IF p_price < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Harga tidak boleh kurang dari 0.';
    ELSEIF p_stock < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stok tidak boleh kurang dari 0.';
    ELSE
        CASE
            WHEN p_price < 50 THEN
                INSERT INTO products (name, price, stock, description, brand_id)
                VALUES (p_name, p_price, p_stock, CONCAT(p_description, ' - Budget Product'), p_brand_id);
            WHEN p_price BETWEEN 50 AND 100 THEN
                INSERT INTO products (name, price, stock, description, brand_id)
                VALUES (p_name, p_price, p_stock, CONCAT(p_description, ' - Standard Product'), p_brand_id);
            ELSE
                INSERT INTO products (name, price, stock, description, brand_id)
                VALUES (p_name, p_price, p_stock, CONCAT(p_description, ' - Premium Product'), p_brand_id);
        END CASE;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllProducts` ()   BEGIN
    SELECT * FROM products;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetProductsByCategory` (IN `category_id` INT)   BEGIN
    SELECT p.id, p.name, p.price, p.stock, p.description, p.brand_id
    FROM products p
    JOIN productcategories pc ON p.id = pc.product_id
    WHERE pc.category_id = category_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `hitung_pendapatan_berdasarkan_tanggal` (IN `tanggal_mulai` DATE, IN `tanggal_akhir` DATE)   BEGIN
    DECLARE total_pendapatan DECIMAL(10,2);
    SELECT SUM(od.quantity * od.price) INTO total_pendapatan
    FROM orders o
    JOIN orderdetails od ON o.id = od.order_id
    WHERE o.order_date BETWEEN tanggal_mulai AND tanggal_akhir;
    SELECT total_pendapatan;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `hitung_total_pendapatan` ()   BEGIN
    DECLARE total_pendapatan DECIMAL(10,2);
    SELECT SUM(od.quantity * od.price) INTO total_pendapatan
    FROM orders o
    JOIN orderdetails od ON o.id = od.order_id;
    SELECT total_pendapatan;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateProductPrice` (IN `p_product_id` INT, IN `p_new_price` DECIMAL(10,2))   BEGIN
    UPDATE products
    SET price = p_new_price
    WHERE id = p_product_id;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `CountCustomers` () RETURNS INT(11)  BEGIN
    DECLARE customerCount INT;
    SELECT COUNT(*) INTO customerCount FROM Customers;
    RETURN customerCount;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `CountProductsByPriceAndStock` (`minPrice` DECIMAL(10,2), `minStock` INT) RETURNS INT(11)  BEGIN 
DECLARE productCount INT;
SELECT COUNT(*) INTO productCount 
FROM Products 
WHERE price > minPrice AND stock > minStock; RETURN productCount;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `account_id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` int(11) NOT NULL,
  `account_name` varchar(255) NOT NULL,
  `account_type` varchar(50) NOT NULL,
  `open_date` date NOT NULL,
  `balance` decimal(10,2) NOT NULL,
  `status` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `addresses`
--

CREATE TABLE `addresses` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `zip` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `addresses`
--

INSERT INTO `addresses` (`id`, `customer_id`, `address`, `city`, `state`, `zip`) VALUES
(1, 1, 'Jalan Gajah 12', 'Jakarta', 'DKI Jakarta', '12345'),
(2, 2, 'Jalan Harimau 6', 'Bekasi', 'DKI Jawa Barat', '67890'),
(3, 3, 'Jalan Kuda 7', 'Jakarta', 'DKI Jakarta', '11223'),
(4, 4, 'Jalan Elang 1', 'Gunung Kidul', 'Yogyakarta', '44556'),
(5, 5, 'Jalan Merpati 202', 'Jakarta', 'DKI Jakarta', '77889');

-- --------------------------------------------------------

--
-- Stand-in structure for view `availableproducts`
-- (See below for the actual view)
--
CREATE TABLE `availableproducts` (
`id` int(11)
,`name` varchar(100)
,`price` decimal(10,2)
,`stock` int(11)
,`description` text
,`brand_id` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `brands`
--

CREATE TABLE `brands` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `brands`
--

INSERT INTO `brands` (`id`, `name`, `country`) VALUES
(1, 'Brand A', 'USA'),
(2, 'Brand B', 'France'),
(3, 'Brand C', 'South Korea'),
(4, 'Brand D', 'Japan'),
(5, 'Brand E', 'Germany');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`) VALUES
(1, 'Cleanser'),
(2, 'Moisturizer'),
(3, 'Sunscreen'),
(4, 'Serum'),
(5, 'Toner');

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `age` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `name`, `email`, `age`) VALUES
(1, 'Kemala', 'kemala@gmail.com', 25),
(2, 'Ajeng', 'ajeng@gmail.com', 30),
(3, 'Ayu', 'ayu@gmail.com', 28),
(4, 'Puspa', 'puspus@gmail.com', 35),
(5, 'Aulia', 'lia@gmail.com', 22);

-- --------------------------------------------------------

--
-- Stand-in structure for view `customers_and_addresses`
-- (See below for the actual view)
--
CREATE TABLE `customers_and_addresses` (
`name` varchar(100)
,`address` text
,`city` varchar(100)
,`state` varchar(100)
,`zip` varchar(20)
);

-- --------------------------------------------------------

--
-- Table structure for table `deliveries`
--

CREATE TABLE `deliveries` (
  `id` int(11) DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `destination` text DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `time_issued` datetime DEFAULT NULL,
  `time_completed` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `deliveries`
--
DELIMITER $$
CREATE TRIGGER `delivery_completed` AFTER UPDATE ON `deliveries` FOR EACH ROW BEGIN
	UPDATE `orders` SET `status`='Delivered' WHERE id = OLD.order_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `old_orders`
-- (See below for the actual view)
--
CREATE TABLE `old_orders` (
`id` int(11)
,`customer_id` int(11)
,`order_date` date
,`status` varchar(50)
);

-- --------------------------------------------------------

--
-- Table structure for table `orderdetails`
--

CREATE TABLE `orderdetails` (
  `id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orderdetails`
--

INSERT INTO `orderdetails` (`id`, `order_id`, `product_id`, `quantity`, `price`) VALUES
(1, 1, 1, 2, 80000.00),
(2, 2, 2, 1, 70000.00),
(3, 3, 3, 4, 300000.00),
(4, 4, 4, 1, 850000.00),
(5, 5, 5, 2, 1200000.00);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `order_date` date DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `customer_id`, `order_date`, `status`) VALUES
(1, 1, '2024-07-01', 'Pending'),
(2, 2, '2024-07-02', 'Shipped'),
(3, 3, '2024-07-03', 'Delivered'),
(4, 4, '2024-07-04', 'Cancelled'),
(5, 5, '2024-07-05', 'Pending'),
(6, 2, '2024-08-01', 'shipped');

-- --------------------------------------------------------

--
-- Stand-in structure for view `order_summary`
-- (See below for the actual view)
--
CREATE TABLE `order_summary` (
`id` int(11)
,`order_date` date
);

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `payment_date` date DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `order_id`, `payment_date`, `amount`, `payment_method`) VALUES
(1, 1, '2024-07-01', 160000.00, 'Credit Card'),
(2, 2, '2024-07-02', 70000.00, 'PayPal'),
(3, 3, '2024-07-03', 1200000.00, 'Credit Card'),
(4, 4, '2024-07-04', 850000.00, 'Bank Transfer'),
(5, 5, '2024-07-05', 2400000.00, 'Credit Card');

-- --------------------------------------------------------

--
-- Table structure for table `productcategories`
--

CREATE TABLE `productcategories` (
  `product_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `productcategories`
--

INSERT INTO `productcategories` (`product_id`, `category_id`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- --------------------------------------------------------

--
-- Table structure for table `productlogs`
--

CREATE TABLE `productlogs` (
  `id` int(11) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `newstock` int(11) DEFAULT NULL,
  `date_added` datetime DEFAULT NULL,
  `date_removed` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `brand_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `price`, `stock`, `description`, `brand_id`) VALUES
(1, 'Facial Cleanser', 50000.00, 100, 'Cleanses your face', 1),
(2, 'Moisturizer', 70000.00, 50, 'Moisturizes your skin', 2),
(3, 'Sunscreen', 300000.00, 30, 'Protects from sun', 3),
(4, 'Serum', 850000.00, 20, 'Rejuvenates skin', 4),
(5, 'Toner', 1200000.00, 10, 'Balances skin pH', 5),
(8, 'Gentle Facewash', 125000.00, 10, 'Safe for sensitive skin - Premium Product', 1),
(9, 'Gentle Facewash', 125000.00, 10, 'Safe for sensitive skin - Premium Product', 1);

--
-- Triggers `products`
--
DELIMITER $$
CREATE TRIGGER `before_delete_products` BEFORE DELETE ON `products` FOR EACH ROW BEGIN
    IF OLD.stock > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete product that is still in stock';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_products` BEFORE INSERT ON `products` FOR EACH ROW BEGIN
    IF NEW.name IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product name cannot be empty';
    END IF;

    IF NEW.price < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product price cannot be negative';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_products` BEFORE UPDATE ON `products` FOR EACH ROW BEGIN
    IF NEW.name IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product name cannot be empty';
    END IF;

    IF NEW.price < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product price cannot be negative';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `new_product` AFTER INSERT ON `products` FOR EACH ROW BEGIN
    INSERT INTO productlogs(product_id, name, stockin, date_added, status) VALUES (NEW.id, NEW.name, NEW.stock, NOW(), 'NEW');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `product_removed` AFTER DELETE ON `products` FOR EACH ROW BEGIN
	UPDATE productlogs SET cur_stock = OLD.stock, date_removed = NOW(), status = 'REMOVED' WHERE product_id = OLD.id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `productsuppliers`
--

CREATE TABLE `productsuppliers` (
  `product_id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `productsuppliers`
--

INSERT INTO `productsuppliers` (`product_id`, `supplier_id`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- --------------------------------------------------------

--
-- Stand-in structure for view `products_and_categories`
-- (See below for the actual view)
--
CREATE TABLE `products_and_categories` (
`product_name` varchar(100)
,`categories_name` varchar(100)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `product_sales`
-- (See below for the actual view)
--
CREATE TABLE `product_sales` (
`product_id` int(11)
,`product_name` varchar(100)
,`total_quantity_sold` decimal(32,0)
,`total_sales` decimal(42,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `recent_orders`
-- (See below for the actual view)
--
CREATE TABLE `recent_orders` (
`id` int(11)
,`customer_id` int(11)
,`order_date` date
,`status` varchar(50)
);

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `id` int(11) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `rating` int(11) DEFAULT NULL,
  `comment` text DEFAULT NULL,
  `review_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reviews`
--

INSERT INTO `reviews` (`id`, `product_id`, `customer_id`, `rating`, `comment`, `review_date`) VALUES
(1, 1, 1, 5, 'Great product!', '2024-07-01'),
(2, 2, 2, 4, 'Very good', '2024-07-02'),
(3, 3, 3, 3, 'Average', '2024-07-03'),
(4, 4, 4, 5, 'Excellent!', '2024-07-04'),
(5, 5, 5, 4, 'Good value', '2024-07-05');

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `contact_info` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`id`, `name`, `contact_info`) VALUES
(1, 'Supplier Alpha', 'Contact Alpha'),
(2, 'Supplier  Beta', 'Contact Beta'),
(3, 'Supplier  Charlie', 'Contact Charlie'),
(4, 'Supplier  Delta', 'Contact Delta'),
(5, 'Supplier Fla', 'Contact Fla');

-- --------------------------------------------------------

--
-- Stand-in structure for view `upcoming_orders`
-- (See below for the actual view)
--
CREATE TABLE `upcoming_orders` (
`id` int(11)
,`order_date` date
,`status` varchar(50)
);

-- --------------------------------------------------------

--
-- Structure for view `availableproducts`
--
DROP TABLE IF EXISTS `availableproducts`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `availableproducts`  AS SELECT `products`.`id` AS `id`, `products`.`name` AS `name`, `products`.`price` AS `price`, `products`.`stock` AS `stock`, `products`.`description` AS `description`, `products`.`brand_id` AS `brand_id` FROM `products` WHERE `products`.`stock` > 0WITH CASCADEDCHECK OPTION  ;

-- --------------------------------------------------------

--
-- Structure for view `customers_and_addresses`
--
DROP TABLE IF EXISTS `customers_and_addresses`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `customers_and_addresses`  AS SELECT `c`.`name` AS `name`, `a`.`address` AS `address`, `a`.`city` AS `city`, `a`.`state` AS `state`, `a`.`zip` AS `zip` FROM (`customers` `c` join `addresses` `a` on(`c`.`id` = `a`.`customer_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `old_orders`
--
DROP TABLE IF EXISTS `old_orders`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `old_orders`  AS SELECT `orders`.`id` AS `id`, `orders`.`customer_id` AS `customer_id`, `orders`.`order_date` AS `order_date`, `orders`.`status` AS `status` FROM `orders` WHERE `orders`.`order_date` < '2024-07-20'WITH CASCADED CHECK OPTION  ;

-- --------------------------------------------------------

--
-- Structure for view `order_summary`
--
DROP TABLE IF EXISTS `order_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `order_summary`  AS SELECT `orders`.`id` AS `id`, `orders`.`order_date` AS `order_date` FROM `orders`WITH CASCADED CHECK OPTION  ;

-- --------------------------------------------------------

--
-- Structure for view `products_and_categories`
--
DROP TABLE IF EXISTS `products_and_categories`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `products_and_categories`  AS SELECT `p`.`name` AS `product_name`, `c`.`name` AS `categories_name` FROM ((`products` `p` join `productcategories` `pc` on(`p`.`id` = `pc`.`product_id`)) join `categories` `c` on(`pc`.`category_id` = `c`.`id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `product_sales`
--
DROP TABLE IF EXISTS `product_sales`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `product_sales`  AS SELECT `p`.`id` AS `product_id`, `p`.`name` AS `product_name`, sum(`od`.`quantity`) AS `total_quantity_sold`, sum(`od`.`quantity` * `od`.`price`) AS `total_sales` FROM ((`orderdetails` `od` join `products` `p` on(`od`.`product_id` = `p`.`id`)) join `orders` `o` on(`od`.`order_id` = `o`.`id`)) WHERE `o`.`status` = 'completed' GROUP BY `p`.`id`, `p`.`name` ;

-- --------------------------------------------------------

--
-- Structure for view `recent_orders`
--
DROP TABLE IF EXISTS `recent_orders`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `recent_orders`  AS SELECT `orders`.`id` AS `id`, `orders`.`customer_id` AS `customer_id`, `orders`.`order_date` AS `order_date`, `orders`.`status` AS `status` FROM `orders` WHERE `orders`.`order_date` > '2024-07-20'WITH CASCADED CHECK OPTION  ;

-- --------------------------------------------------------

--
-- Structure for view `upcoming_orders`
--
DROP TABLE IF EXISTS `upcoming_orders`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `upcoming_orders`  AS SELECT `os`.`id` AS `id`, `os`.`order_date` AS `order_date`, `o`.`status` AS `status` FROM (`order_summary` `os` join `orders` `o` on(`os`.`id` = `o`.`id`)) WHERE `os`.`order_date` > curdate()WITH CASCADED CHECK OPTION  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`account_id`),
  ADD KEY `idx_customer_account` (`customer_id`,`account_type`),
  ADD KEY `idx_account_name_status` (`account_name`,`status`),
  ADD KEY `idx_account_balance` (`account_name`,`balance`);

--
-- Indexes for table `addresses`
--
ALTER TABLE `addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `customer_id` (`customer_id`);

--
-- Indexes for table `brands`
--
ALTER TABLE `brands`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `deliveries`
--
ALTER TABLE `deliveries`
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `orderdetails`
--
ALTER TABLE `orderdetails`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `customer_id` (`customer_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `productcategories`
--
ALTER TABLE `productcategories`
  ADD PRIMARY KEY (`product_id`,`category_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `productlogs`
--
ALTER TABLE `productlogs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `brand_id` (`brand_id`);

--
-- Indexes for table `productsuppliers`
--
ALTER TABLE `productsuppliers`
  ADD PRIMARY KEY (`product_id`,`supplier_id`),
  ADD KEY `supplier_id` (`supplier_id`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `customer_id` (`customer_id`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `account_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `addresses`
--
ALTER TABLE `addresses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `brands`
--
ALTER TABLE `brands`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `orderdetails`
--
ALTER TABLE `orderdetails`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `productlogs`
--
ALTER TABLE `productlogs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `accounts`
--
ALTER TABLE `accounts`
  ADD CONSTRAINT `accounts_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`);

--
-- Constraints for table `addresses`
--
ALTER TABLE `addresses`
  ADD CONSTRAINT `addresses_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`);

--
-- Constraints for table `deliveries`
--
ALTER TABLE `deliveries`
  ADD CONSTRAINT `deliveries_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);

--
-- Constraints for table `orderdetails`
--
ALTER TABLE `orderdetails`
  ADD CONSTRAINT `orderdetails_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `orderdetails_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`);

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);

--
-- Constraints for table `productcategories`
--
ALTER TABLE `productcategories`
  ADD CONSTRAINT `productcategories_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `productcategories_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);

--
-- Constraints for table `productlogs`
--
ALTER TABLE `productlogs`
  ADD CONSTRAINT `productlogs_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`);

--
-- Constraints for table `productsuppliers`
--
ALTER TABLE `productsuppliers`
  ADD CONSTRAINT `productsuppliers_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `productsuppliers_ibfk_2` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`);

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
