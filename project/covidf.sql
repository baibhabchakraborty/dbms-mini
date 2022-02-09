-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 20, 2022 at 07:38 AM
-- Server version: 10.4.19-MariaDB
-- PHP Version: 8.0.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `covidf`
--

-- --------------------------------------------------------

--
-- Table structure for table `bookingpatient`
--

CREATE TABLE `bookingpatient` (
  `id` int(11) NOT NULL,
  `srfid` varchar(50) NOT NULL,
  `bedtype` varchar(50) NOT NULL,
  `hcode` varchar(50) NOT NULL,
  `spo2` int(11) NOT NULL,
  `pname` varchar(50) NOT NULL,
  `pphone` varchar(12) NOT NULL,
  `paddress` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `bookingpatient`
--

INSERT INTO `bookingpatient` (`id`, `srfid`, `bedtype`, `hcode`, `spo2`, `pname`, `pphone`, `paddress`) VALUES
(5, '1111', 'ICUBed', '222222', 78, 'Baibhab Chakraborty', '2233445566', 'abc street'),
(6, '2222', 'NormalBed', '333333', 79, 'Aishwarya Iyer', '22667567546', 'def street');

-- --------------------------------------------------------

--
-- Table structure for table `hospitaldata`
--

CREATE TABLE `hospitaldata` (
  `id` int(11) NOT NULL,
  `hcode` varchar(200) NOT NULL,
  `hname` varchar(200) NOT NULL,
  `normalbed` int(11) NOT NULL,
  `hicubed` int(11) NOT NULL,
  `icubed` int(11) NOT NULL,
  `vbed` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `hospitaldata`
--

INSERT INTO `hospitaldata` (`id`, `hcode`, `hname`, `normalbed`, `hicubed`, `icubed`, `vbed`) VALUES
(4, '222222 ', 'Kurukshetra Hospital', 5, 2, 6, 3),
(5, '333333 ', 'Nalanda Hospital', 4, 5, 5, 5);

--
-- Triggers `hospitaldata`
--
DELIMITER $$
CREATE TRIGGER `Insert` AFTER INSERT ON `hospitaldata` FOR EACH ROW INSERT INTO trig VALUES(null,NEW.hcode,NEW.normalbed,NEW.hicubed,NEW.icubed,NEW.vbed,' INSERTED',NOW())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Update` AFTER UPDATE ON `hospitaldata` FOR EACH ROW INSERT INTO trig VALUES(null,NEW.hcode,NEW.normalbed,NEW.hicubed,NEW.icubed,NEW.vbed,' UPDATED',NOW())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `delet` BEFORE DELETE ON `hospitaldata` FOR EACH ROW INSERT INTO trig VALUES(null,OLD.hcode,OLD.normalbed,OLD.hicubed,OLD.icubed,OLD.vbed,' DELETED',NOW())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `hospitaluser`
--

CREATE TABLE `hospitaluser` (
  `id` int(11) NOT NULL,
  `hcode` varchar(20) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `hospitaluser`
--

INSERT INTO `hospitaluser` (`id`, `hcode`, `email`, `password`) VALUES
(12, '222222', 'baibhab.baishakhi@gmail.com', 'pbkdf2:sha256:260000$h1zOHaDHeXShJQV0$537c9c059dd04235a2d686ca77739f7ec93ee27000bbed3a79113c2b8683bbce'),
(13, '333333', 'baisahkhi.baibhab@gmail.com', 'pbkdf2:sha256:260000$pYyH5Aog6JhzRwy5$59a9b46895202ff730424b7c085bc2de43233f6d75232663780e2e27bcbcb810');

-- --------------------------------------------------------

--
-- Table structure for table `test`
--

CREATE TABLE `test` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `trig`
--

CREATE TABLE `trig` (
  `id` int(11) NOT NULL,
  `hcode` varchar(50) NOT NULL,
  `normalbed` int(11) NOT NULL,
  `hicubed` int(11) NOT NULL,
  `icubed` int(11) NOT NULL,
  `vbed` int(11) NOT NULL,
  `querys` varchar(50) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `trig`
--

INSERT INTO `trig` (`id`, `hcode`, `normalbed`, `hicubed`, `icubed`, `vbed`, `querys`, `date`) VALUES
(4, '222222 ', 5, 2, 7, 3, ' INSERTED', '2022-01-15'),
(5, '222222 ', 5, 2, 6, 3, ' UPDATED', '2022-01-15'),
(6, '333333 ', 5, 5, 5, 5, ' INSERTED', '2022-01-15'),
(7, '333333 ', 4, 5, 5, 5, ' UPDATED', '2022-01-15');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `srfid` varchar(20) NOT NULL,
  `email` varchar(100) NOT NULL,
  `dob` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `srfid`, `email`, `dob`) VALUES
(12, '1111', 'baishakhi.baibhab@gmail.com', 'pbkdf2:sha256:260000$9NhZFOJNY1u1OyWI$c5e2d0d07fae7f344b23ecd3c062017758fc4a46dbecbf45edd5ce13f3191354'),
(13, '2222', 'baibhab.baishakhi@gmail.com', 'pbkdf2:sha256:260000$BYvflQ0LYoscwfKp$baafffc5dfb137456aab588a4744fbf5cea2d1f1647743d65d163ec9eb9222cb');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bookingpatient`
--
ALTER TABLE `bookingpatient`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `srfid` (`srfid`(20));

--
-- Indexes for table `hospitaldata`
--
ALTER TABLE `hospitaldata`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `hcode` (`hcode`);

--
-- Indexes for table `hospitaluser`
--
ALTER TABLE `hospitaluser`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `test`
--
ALTER TABLE `test`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trig`
--
ALTER TABLE `trig`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `srfid` (`srfid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bookingpatient`
--
ALTER TABLE `bookingpatient`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `hospitaldata`
--
ALTER TABLE `hospitaldata`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `hospitaluser`
--
ALTER TABLE `hospitaluser`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `test`
--
ALTER TABLE `test`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `trig`
--
ALTER TABLE `trig`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
