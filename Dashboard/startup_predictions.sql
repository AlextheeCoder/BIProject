-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 26, 2023 at 10:44 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `startup_predictions`
--

-- --------------------------------------------------------

--
-- Table structure for table `predictions`
--

CREATE TABLE `predictions` (
  `id` int(11) NOT NULL,
  `funding_total_usd` decimal(15,2) DEFAULT NULL,
  `funding_rounds` int(11) DEFAULT NULL,
  `milestones` int(11) DEFAULT NULL,
  `category_code` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `industry` varchar(255) DEFAULT NULL,
  `prediction_result` varchar(255) DEFAULT NULL,
  `prediction_time` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `predictions`
--

INSERT INTO `predictions` (`id`, `funding_total_usd`, `funding_rounds`, `milestones`, `category_code`, `state`, `industry`, `prediction_result`, `prediction_time`) VALUES
(1, 1000000.00, 5, 2, 'advertising', 'California', 'Advertising', '1', '2023-11-26 21:39:13'),
(2, 100.00, 5, 2, 'advertising', 'California', 'Advertising', '0', '2023-11-25 21:48:47'),
(3, 9000000.00, 9, 5, 'cleantech', 'Other states', 'Enterprise', '1', '2023-10-26 22:19:14'),
(4, 1000000.00, 5, 2, 'biotech', 'New York', 'Enterprise', '1', '2023-11-26 23:03:02'),
(5, 78.00, 1, 5, 'advertising', 'California', 'Advertising', '0', '2023-10-26 23:05:44'),
(6, 1800000.00, 5, 3, 'biotech', 'Texas', 'Ecommerce', '1', '2023-11-26 23:07:00'),
(7, 1000.00, 2, 9, 'fashion', 'California', 'Consulting', '0', '2023-09-26 23:20:25'),
(8, 3500000.00, 3, 1, 'automotive', 'Other states', 'Software', '1', '2023-11-27 23:46:30');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `predictions`
--
ALTER TABLE `predictions`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `predictions`
--
ALTER TABLE `predictions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
