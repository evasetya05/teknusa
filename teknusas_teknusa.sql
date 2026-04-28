-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Apr 28, 2026 at 09:25 AM
-- Server version: 10.6.24-MariaDB-cll-lve
-- PHP Version: 8.4.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `teknusas_teknusa`
--

-- --------------------------------------------------------

--
-- Table structure for table `about_teamexpert`
--

CREATE TABLE `about_teamexpert` (
  `id` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `role` varchar(200) NOT NULL,
  `about` longtext NOT NULL,
  `cover` varchar(100) NOT NULL,
  `facebook` varchar(250) NOT NULL,
  `twitter` varchar(250) NOT NULL,
  `instagram` varchar(250) NOT NULL,
  `linkedin` varchar(250) NOT NULL,
  `github` varchar(250) NOT NULL,
  `created_time` datetime(6) NOT NULL,
  `modified_time` datetime(6) NOT NULL,
  `views` int(10) UNSIGNED NOT NULL CHECK (`views` >= 0),
  `words` int(10) UNSIGNED NOT NULL CHECK (`words` >= 0),
  `status` varchar(1) NOT NULL,
  `stick` varchar(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `accounts_employer`
--

CREATE TABLE `accounts_employer` (
  `id` bigint(20) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `nickname` varchar(100) NOT NULL,
  `created_time` datetime(6) NOT NULL,
  `last_mod_time` datetime(6) NOT NULL,
  `source` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `accounts_employer_groups`
--

CREATE TABLE `accounts_employer_groups` (
  `id` bigint(20) NOT NULL,
  `employer_id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `accounts_employer_user_permissions`
--

CREATE TABLE `accounts_employer_user_permissions` (
  `id` bigint(20) NOT NULL,
  `employer_id` bigint(20) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add site', 1, 'add_site'),
(2, 'Can change site', 1, 'change_site'),
(3, 'Can delete site', 1, 'delete_site'),
(4, 'Can view site', 1, 'view_site'),
(5, 'Can add log entry', 2, 'add_logentry'),
(6, 'Can change log entry', 2, 'change_logentry'),
(7, 'Can delete log entry', 2, 'delete_logentry'),
(8, 'Can view log entry', 2, 'view_logentry'),
(9, 'Can add permission', 3, 'add_permission'),
(10, 'Can change permission', 3, 'change_permission'),
(11, 'Can delete permission', 3, 'delete_permission'),
(12, 'Can view permission', 3, 'view_permission'),
(13, 'Can add group', 4, 'add_group'),
(14, 'Can change group', 4, 'change_group'),
(15, 'Can delete group', 4, 'delete_group'),
(16, 'Can view group', 4, 'view_group'),
(17, 'Can add user', 5, 'add_user'),
(18, 'Can change user', 5, 'change_user'),
(19, 'Can delete user', 5, 'delete_user'),
(20, 'Can view user', 5, 'view_user'),
(21, 'Can add content type', 6, 'add_contenttype'),
(22, 'Can change content type', 6, 'change_contenttype'),
(23, 'Can delete content type', 6, 'delete_contenttype'),
(24, 'Can view content type', 6, 'view_contenttype'),
(25, 'Can add session', 7, 'add_session'),
(26, 'Can change session', 7, 'change_session'),
(27, 'Can delete session', 7, 'delete_session'),
(28, 'Can view session', 7, 'view_session'),
(29, 'Can add comment', 8, 'add_comment'),
(30, 'Can change comment', 8, 'change_comment'),
(31, 'Can delete comment', 8, 'delete_comment'),
(32, 'Can view comment', 8, 'view_comment'),
(33, 'Can add Custom code', 9, 'add_customcode'),
(34, 'Can change Custom code', 9, 'change_customcode'),
(35, 'Can delete Custom code', 9, 'delete_customcode'),
(36, 'Can view Custom code', 9, 'view_customcode'),
(37, 'Can add Links', 10, 'add_friendlinks'),
(38, 'Can change Links', 10, 'change_friendlinks'),
(39, 'Can delete Links', 10, 'delete_friendlinks'),
(40, 'Can view Links', 10, 'view_friendlinks'),
(41, 'Can add SEO Set up', 11, 'add_seo'),
(42, 'Can change SEO Set up', 11, 'change_seo'),
(43, 'Can delete SEO Set up', 11, 'delete_seo'),
(44, 'Can view SEO Set up', 11, 'view_seo'),
(45, 'Can add Site Information', 12, 'add_siteinfo'),
(46, 'Can change Site Information', 12, 'change_siteinfo'),
(47, 'Can delete Site Information', 12, 'delete_siteinfo'),
(48, 'Can view Site Information', 12, 'view_siteinfo'),
(49, 'Can add Social account', 13, 'add_social'),
(50, 'Can change Social account', 13, 'change_social'),
(51, 'Can delete Social account', 13, 'delete_social'),
(52, 'Can view Social account', 13, 'view_social'),
(53, 'Can add Talk about labels', 14, 'add_talktags'),
(54, 'Can change Talk about labels', 14, 'change_talktags'),
(55, 'Can delete Talk about labels', 14, 'delete_talktags'),
(56, 'Can view Talk about labels', 14, 'view_talktags'),
(57, 'Can add Talk about content', 15, 'add_talkcontent'),
(58, 'Can change Talk about content', 15, 'change_talkcontent'),
(59, 'Can delete Talk about content', 15, 'delete_talkcontent'),
(60, 'Can view Talk about content', 15, 'view_talkcontent'),
(61, 'Can add Menu Bar', 16, 'add_meanlist'),
(62, 'Can change Menu Bar', 16, 'change_meanlist'),
(63, 'Can delete Menu Bar', 16, 'delete_meanlist'),
(64, 'Can view Menu Bar', 16, 'view_meanlist'),
(65, 'Can add Website message', 17, 'add_messages'),
(66, 'Can change Website message', 17, 'change_messages'),
(67, 'Can delete Website message', 17, 'delete_messages'),
(68, 'Can view Website message', 17, 'view_messages'),
(69, 'Can add Like', 18, 'add_like'),
(70, 'Can change Like', 18, 'change_like'),
(71, 'Can delete Like', 18, 'delete_like'),
(72, 'Can view Like', 18, 'view_like'),
(73, 'Can add Add Job', 19, 'add_job'),
(74, 'Can change Add Job', 19, 'change_job'),
(75, 'Can delete Add Job', 19, 'delete_job'),
(76, 'Can view Add Job', 19, 'view_job'),
(77, 'Can add applicant details', 20, 'add_applicantdetails'),
(78, 'Can change applicant details', 20, 'change_applicantdetails'),
(79, 'Can delete applicant details', 20, 'delete_applicantdetails'),
(80, 'Can view applicant details', 20, 'view_applicantdetails'),
(81, 'Can add applicant', 21, 'add_applicant'),
(82, 'Can change applicant', 21, 'change_applicant'),
(83, 'Can delete applicant', 21, 'delete_applicant'),
(84, 'Can view applicant', 21, 'view_applicant'),
(85, 'Can add Job Category', 22, 'add_jobcategory'),
(86, 'Can change Job Category', 22, 'change_jobcategory'),
(87, 'Can delete Job Category', 22, 'delete_jobcategory'),
(88, 'Can view Job Category', 22, 'view_jobcategory'),
(89, 'Can add Job Location', 23, 'add_joblocation'),
(90, 'Can change Job Location', 23, 'change_joblocation'),
(91, 'Can delete Job Location', 23, 'delete_joblocation'),
(92, 'Can view Job Location', 23, 'view_joblocation'),
(93, 'Can add contact', 24, 'add_contact'),
(94, 'Can change contact', 24, 'change_contact'),
(95, 'Can delete contact', 24, 'delete_contact'),
(96, 'Can view contact', 24, 'view_contact'),
(97, 'Can add mail book', 25, 'add_mailbook'),
(98, 'Can change mail book', 25, 'change_mailbook'),
(99, 'Can delete mail book', 25, 'delete_mailbook'),
(100, 'Can view mail book', 25, 'view_mailbook'),
(101, 'Can add Add TeamExpert', 26, 'add_teamexpert'),
(102, 'Can change Add TeamExpert', 26, 'change_teamexpert'),
(103, 'Can delete Add TeamExpert', 26, 'delete_teamexpert'),
(104, 'Can view Add TeamExpert', 26, 'view_teamexpert'),
(105, 'Can add CompanyEmployer', 27, 'add_employer'),
(106, 'Can change CompanyEmployer', 27, 'change_employer'),
(107, 'Can delete CompanyEmployer', 27, 'delete_employer'),
(108, 'Can view CompanyEmployer', 27, 'view_employer'),
(109, 'Can add lead', 28, 'add_lead'),
(110, 'Can change lead', 28, 'change_lead'),
(111, 'Can delete lead', 28, 'delete_lead'),
(112, 'Can view lead', 28, 'view_lead'),
(113, 'Can add interaction', 29, 'add_interaction'),
(114, 'Can change interaction', 29, 'change_interaction'),
(115, 'Can delete interaction', 29, 'delete_interaction'),
(116, 'Can view interaction', 29, 'view_interaction'),
(117, 'Can add idea', 30, 'add_idea'),
(118, 'Can change idea', 30, 'change_idea'),
(119, 'Can delete idea', 30, 'delete_idea'),
(120, 'Can view idea', 30, 'view_idea'),
(121, 'Can add measure', 31, 'add_measure'),
(122, 'Can change measure', 31, 'change_measure'),
(123, 'Can delete measure', 31, 'delete_measure'),
(124, 'Can view measure', 31, 'view_measure'),
(125, 'Can add build', 32, 'add_build'),
(126, 'Can change build', 32, 'change_build'),
(127, 'Can delete build', 32, 'delete_build'),
(128, 'Can view build', 32, 'view_build'),
(129, 'Can add learning', 33, 'add_learning'),
(130, 'Can change learning', 33, 'change_learning'),
(131, 'Can delete learning', 33, 'delete_learning'),
(132, 'Can view learning', 33, 'view_learning'),
(133, 'Can add data point', 34, 'add_datapoint'),
(134, 'Can change data point', 34, 'change_datapoint'),
(135, 'Can delete data point', 34, 'delete_datapoint'),
(136, 'Can view data point', 34, 'view_datapoint'),
(137, 'Can add product', 35, 'add_product'),
(138, 'Can change product', 35, 'change_product'),
(139, 'Can delete product', 35, 'delete_product'),
(140, 'Can view product', 35, 'view_product'),
(141, 'Can add account', 36, 'add_account'),
(142, 'Can change account', 36, 'change_account'),
(143, 'Can delete account', 36, 'delete_account'),
(144, 'Can view account', 36, 'view_account'),
(145, 'Can add journal entry', 37, 'add_journalentry'),
(146, 'Can change journal entry', 37, 'change_journalentry'),
(147, 'Can delete journal entry', 37, 'delete_journalentry'),
(148, 'Can view journal entry', 37, 'view_journalentry'),
(149, 'Can add journal item', 38, 'add_journalitem'),
(150, 'Can change journal item', 38, 'change_journalitem'),
(151, 'Can delete journal item', 38, 'delete_journalitem'),
(152, 'Can view journal item', 38, 'view_journalitem'),
(153, 'Can add closing period', 39, 'add_closingperiod'),
(154, 'Can change closing period', 39, 'change_closingperiod'),
(155, 'Can delete closing period', 39, 'delete_closingperiod'),
(156, 'Can view closing period', 39, 'view_closingperiod'),
(157, 'Can add market', 40, 'add_market'),
(158, 'Can change market', 40, 'change_market'),
(159, 'Can delete market', 40, 'delete_market'),
(160, 'Can view market', 40, 'view_market'),
(161, 'Can add channel', 41, 'add_channel'),
(162, 'Can change channel', 41, 'change_channel'),
(163, 'Can delete channel', 41, 'delete_channel'),
(164, 'Can view channel', 41, 'view_channel'),
(165, 'Can add channel performance', 42, 'add_channelperformance'),
(166, 'Can change channel performance', 42, 'change_channelperformance'),
(167, 'Can delete channel performance', 42, 'delete_channelperformance'),
(168, 'Can view channel performance', 42, 'view_channelperformance'),
(169, 'Can add attachment', 43, 'add_attachment'),
(170, 'Can change attachment', 43, 'change_attachment'),
(171, 'Can delete attachment', 43, 'delete_attachment'),
(172, 'Can view attachment', 43, 'view_attachment'),
(173, 'Can add Website configuration', 44, 'add_blogsettings'),
(174, 'Can change Website configuration', 44, 'change_blogsettings'),
(175, 'Can delete Website configuration', 44, 'delete_blogsettings'),
(176, 'Can view Website configuration', 44, 'view_blogsettings'),
(177, 'Can add Links', 45, 'add_links'),
(178, 'Can change Links', 45, 'change_links'),
(179, 'Can delete Links', 45, 'delete_links'),
(180, 'Can view Links', 45, 'view_links'),
(181, 'Can add Sidebar', 46, 'add_sidebar'),
(182, 'Can change Sidebar', 46, 'change_sidebar'),
(183, 'Can delete Sidebar', 46, 'delete_sidebar'),
(184, 'Can view Sidebar', 46, 'view_sidebar'),
(185, 'Can add speech', 47, 'add_speech'),
(186, 'Can change speech', 47, 'change_speech'),
(187, 'Can delete speech', 47, 'delete_speech'),
(188, 'Can view speech', 47, 'view_speech'),
(189, 'Can add tags', 48, 'add_tag'),
(190, 'Can change tags', 48, 'change_tag'),
(191, 'Can delete tags', 48, 'delete_tag'),
(192, 'Can view tags', 48, 'view_tag'),
(193, 'Can add category', 49, 'add_category'),
(194, 'Can change category', 49, 'change_category'),
(195, 'Can delete category', 49, 'delete_category'),
(196, 'Can view category', 49, 'view_category'),
(197, 'Can add Article', 50, 'add_article'),
(198, 'Can change Article', 50, 'change_article'),
(199, 'Can delete Article', 50, 'delete_article'),
(200, 'Can view Article', 50, 'view_article'),
(201, 'Can add base model', 51, 'add_basemodel'),
(202, 'Can change base model', 51, 'change_basemodel'),
(203, 'Can delete base model', 51, 'delete_basemodel'),
(204, 'Can view base model', 51, 'view_basemodel'),
(205, 'Can add Add Portfolio', 52, 'add_portfolio'),
(206, 'Can change Add Portfolio', 52, 'change_portfolio'),
(207, 'Can delete Add Portfolio', 52, 'delete_portfolio'),
(208, 'Can view Add Portfolio', 52, 'view_portfolio'),
(209, 'Can add Commands', 53, 'add_commands'),
(210, 'Can change Commands', 53, 'change_commands'),
(211, 'Can delete Commands', 53, 'delete_commands'),
(212, 'Can view Commands', 53, 'view_commands'),
(213, 'Can add Email Sendlog', 54, 'add_emailsendlog'),
(214, 'Can change Email Sendlog', 54, 'change_emailsendlog'),
(215, 'Can delete Email Sendlog', 54, 'delete_emailsendlog'),
(216, 'Can view Email Sendlog', 54, 'view_emailsendlog'),
(217, 'Can add Cookie', 55, 'add_cookie'),
(218, 'Can change Cookie', 55, 'change_cookie'),
(219, 'Can delete Cookie', 55, 'delete_cookie'),
(220, 'Can view Cookie', 55, 'view_cookie'),
(221, 'Can add Cookie Group', 56, 'add_cookiegroup'),
(222, 'Can change Cookie Group', 56, 'change_cookiegroup'),
(223, 'Can delete Cookie Group', 56, 'delete_cookiegroup'),
(224, 'Can view Cookie Group', 56, 'view_cookiegroup'),
(225, 'Can add Log item', 57, 'add_logitem'),
(226, 'Can change Log item', 57, 'change_logitem'),
(227, 'Can delete Log item', 57, 'delete_logitem'),
(228, 'Can view Log item', 57, 'view_logitem'),
(229, 'Can add akun', 58, 'add_akun'),
(230, 'Can change akun', 58, 'change_akun'),
(231, 'Can delete akun', 58, 'delete_akun'),
(232, 'Can view akun', 58, 'view_akun'),
(233, 'Can add biaya', 59, 'add_biaya'),
(234, 'Can change biaya', 59, 'change_biaya'),
(235, 'Can delete biaya', 59, 'delete_biaya'),
(236, 'Can view biaya', 59, 'view_biaya'),
(237, 'Can add digital channel', 60, 'add_digitalchannel'),
(238, 'Can change digital channel', 60, 'change_digitalchannel'),
(239, 'Can delete digital channel', 60, 'delete_digitalchannel'),
(240, 'Can view digital channel', 60, 'view_digitalchannel'),
(241, 'Can add funnel stage', 61, 'add_funnelstage'),
(242, 'Can change funnel stage', 61, 'change_funnelstage'),
(243, 'Can delete funnel stage', 61, 'delete_funnelstage'),
(244, 'Can view funnel stage', 61, 'view_funnelstage');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user`
--

CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `auth_user`
--

INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
(1, 'pbkdf2_sha256$870000$6VhcgCA0i2M0eNlBAUCQxD$NT0ywPi1218cNL1utdztY5k/AMhNX+83rgK2SxE0UvM=', '2026-04-02 10:07:46.350194', 1, 'admin', '', '', '', 1, 1, '2025-11-15 09:27:00.089845');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_groups`
--

CREATE TABLE `auth_user_groups` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_user_permissions`
--

CREATE TABLE `auth_user_user_permissions` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `blog_article`
--

CREATE TABLE `blog_article` (
  `id` int(11) NOT NULL,
  `created_time` datetime(6) NOT NULL,
  `last_mod_time` datetime(6) NOT NULL,
  `is_removed` tinyint(1) NOT NULL,
  `title` varchar(200) NOT NULL,
  `body` longtext NOT NULL,
  `pub_time` datetime(6) NOT NULL,
  `status` varchar(1) NOT NULL,
  `comment_status` varchar(1) NOT NULL,
  `type` varchar(1) NOT NULL,
  `views` int(10) UNSIGNED NOT NULL CHECK (`views` >= 0),
  `article_order` int(11) NOT NULL,
  `audio` varchar(150) NOT NULL,
  `author_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `blog_article_tags`
--

CREATE TABLE `blog_article_tags` (
  `id` bigint(20) NOT NULL,
  `article_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `blog_blogsettings`
--

CREATE TABLE `blog_blogsettings` (
  `id` bigint(20) NOT NULL,
  `sitename` varchar(200) NOT NULL,
  `site_description` longtext NOT NULL,
  `site_seo_description` longtext NOT NULL,
  `site_keywords` longtext NOT NULL,
  `article_sub_length` int(11) NOT NULL,
  `sidebar_article_count` int(11) NOT NULL,
  `sidebar_comment_count` int(11) NOT NULL,
  `show_google_adsense` tinyint(1) NOT NULL,
  `google_adsense_codes` longtext DEFAULT NULL,
  `open_site_comment` tinyint(1) NOT NULL,
  `beiancode` varchar(2000) DEFAULT NULL,
  `analyticscode` longtext NOT NULL,
  `show_gongan_code` tinyint(1) NOT NULL,
  `gongan_beiancode` longtext DEFAULT NULL,
  `resource_path` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `blog_blogsettings`
--

INSERT INTO `blog_blogsettings` (`id`, `sitename`, `site_description`, `site_seo_description`, `site_keywords`, `article_sub_length`, `sidebar_article_count`, `sidebar_comment_count`, `show_google_adsense`, `google_adsense_codes`, `open_site_comment`, `beiancode`, `analyticscode`, `show_gongan_code`, `gongan_beiancode`, `resource_path`) VALUES
(1, 'teknusa', 'teknusa', 'teknusa', 'agrosite,farm,agriculture,agrohelp,farmer,vegetables,agroapp', 200, 10, 5, 0, '', 1, '', '', 0, '', '/var/www/resource/');

-- --------------------------------------------------------

--
-- Table structure for table `blog_category`
--

CREATE TABLE `blog_category` (
  `id` int(11) NOT NULL,
  `created_time` datetime(6) NOT NULL,
  `last_mod_time` datetime(6) NOT NULL,
  `is_removed` tinyint(1) NOT NULL,
  `name` varchar(30) NOT NULL,
  `slug` varchar(60) NOT NULL,
  `parent_category_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `blog_links`
--

CREATE TABLE `blog_links` (
  `id` bigint(20) NOT NULL,
  `name` varchar(30) NOT NULL,
  `link` varchar(200) NOT NULL,
  `sequence` int(11) NOT NULL,
  `is_enable` tinyint(1) NOT NULL,
  `show_type` varchar(1) NOT NULL,
  `created_time` datetime(6) NOT NULL,
  `last_mod_time` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `blog_sidebar`
--

CREATE TABLE `blog_sidebar` (
  `id` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `content` longtext NOT NULL,
  `sequence` int(11) NOT NULL,
  `is_enable` tinyint(1) NOT NULL,
  `created_time` datetime(6) NOT NULL,
  `last_mod_time` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `blog_speech`
--

CREATE TABLE `blog_speech` (
  `id` bigint(20) NOT NULL,
  `text` longtext NOT NULL,
  `language` longtext NOT NULL,
  `file_name` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `blog_tag`
--

CREATE TABLE `blog_tag` (
  `id` int(11) NOT NULL,
  `created_time` datetime(6) NOT NULL,
  `last_mod_time` datetime(6) NOT NULL,
  `is_removed` tinyint(1) NOT NULL,
  `name` varchar(30) NOT NULL,
  `slug` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `careers_applicant`
--

CREATE TABLE `careers_applicant` (
  `id` bigint(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `user_id` int(11) NOT NULL,
  `job_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `careers_applicantdetails`
--

CREATE TABLE `careers_applicantdetails` (
  `id` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `modified_at` datetime(6) NOT NULL,
  `fullname` varchar(100) NOT NULL,
  `cover` varchar(100) NOT NULL,
  `email` varchar(254) NOT NULL,
  `phone` varchar(17) NOT NULL,
  `tenth_percent` double NOT NULL,
  `puc_or_diploma` varchar(1) NOT NULL,
  `puc_or_diploma_marks` double NOT NULL,
  `board` varchar(60) NOT NULL,
  `degree_college` varchar(50) NOT NULL,
  `location` varchar(50) NOT NULL,
  `university` varchar(50) NOT NULL,
  `branch` varchar(50) NOT NULL,
  `grade_or_percent` varchar(1) NOT NULL,
  `degree_marks` double NOT NULL,
  `github` varchar(100) NOT NULL,
  `linkedin` varchar(100) NOT NULL,
  `resume` varchar(100) NOT NULL,
  `user_id` int(11) NOT NULL,
  `job_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `careers_job`
--

CREATE TABLE `careers_job` (
  `id` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `modified_at` datetime(6) NOT NULL,
  `title` varchar(300) NOT NULL,
  `cover` varchar(100) NOT NULL,
  `description` longtext NOT NULL,
  `jobtype` varchar(10) NOT NULL,
  `last_date` datetime(6) NOT NULL,
  `filled` tinyint(1) NOT NULL,
  `salary` int(11) NOT NULL,
  `views` int(10) UNSIGNED NOT NULL CHECK (`views` >= 0),
  `vacancies` int(10) UNSIGNED NOT NULL CHECK (`vacancies` >= 0),
  `status` varchar(1) NOT NULL,
  `stick` varchar(1) NOT NULL,
  `user_id` int(11) NOT NULL,
  `jobcategory_id` int(11) NOT NULL,
  `location_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `careers_jobcategory`
--

CREATE TABLE `careers_jobcategory` (
  `id` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `modified_at` datetime(6) NOT NULL,
  `name` varchar(100) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `careers_joblocation`
--

CREATE TABLE `careers_joblocation` (
  `id` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `modified_at` datetime(6) NOT NULL,
  `location` varchar(100) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `comment_comment`
--

CREATE TABLE `comment_comment` (
  `id` bigint(20) NOT NULL,
  `object_id` int(10) UNSIGNED NOT NULL CHECK (`object_id` >= 0),
  `text` longtext NOT NULL,
  `comment_time` datetime(6) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `reply_to_id` int(11) DEFAULT NULL,
  `root_id` bigint(20) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `contactus_contact`
--

CREATE TABLE `contactus_contact` (
  `id` bigint(20) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(254) NOT NULL,
  `subject` varchar(250) NOT NULL,
  `message` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `contactus_mailbook`
--

CREATE TABLE `contactus_mailbook` (
  `id` bigint(20) NOT NULL,
  `email` varchar(200) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cookie_consent_cookie`
--

CREATE TABLE `cookie_consent_cookie` (
  `id` int(11) NOT NULL,
  `name` varchar(250) NOT NULL,
  `description` longtext NOT NULL,
  `path` longtext NOT NULL,
  `domain` varchar(250) NOT NULL,
  `created` datetime(6) NOT NULL,
  `cookiegroup_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cookie_consent_cookiegroup`
--

CREATE TABLE `cookie_consent_cookiegroup` (
  `id` int(11) NOT NULL,
  `varname` varchar(32) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` longtext NOT NULL,
  `is_required` tinyint(1) NOT NULL,
  `is_deletable` tinyint(1) NOT NULL,
  `ordering` int(11) NOT NULL,
  `created` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cookie_consent_logitem`
--

CREATE TABLE `cookie_consent_logitem` (
  `id` int(11) NOT NULL,
  `action` int(11) NOT NULL,
  `version` varchar(32) NOT NULL,
  `created` datetime(6) NOT NULL,
  `cookiegroup_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `django_admin_log`
--

INSERT INTO `django_admin_log` (`id`, `action_time`, `object_id`, `object_repr`, `action_flag`, `change_message`, `content_type_id`, `user_id`) VALUES
(1, '2025-11-21 04:09:33.135651', '69', 'JournalEntry object (69)', 3, '', 37, 1),
(2, '2025-11-21 04:09:52.484478', '68', 'JournalEntry object (68)', 3, '', 37, 1),
(3, '2025-11-21 04:10:10.363783', '67', 'JournalEntry object (67)', 3, '', 37, 1),
(4, '2025-11-21 05:20:46.460236', '66', 'JournalEntry object (66)', 3, '', 37, 1),
(5, '2025-11-21 05:22:56.105659', '65', 'JournalEntry object (65)', 3, '', 37, 1),
(6, '2025-11-21 05:24:32.863262', '64', 'JournalEntry object (64)', 3, '', 37, 1),
(7, '2025-11-21 05:25:44.581044', '63', 'JournalEntry object (63)', 3, '', 37, 1),
(8, '2025-11-21 05:26:16.397963', '62', 'JournalEntry object (62)', 3, '', 37, 1),
(9, '2025-11-21 05:26:32.527484', '61', 'JournalEntry object (61)', 3, '', 37, 1),
(10, '2025-12-05 02:51:48.214542', '1', 'Nusa Sawit', 2, '[{\"changed\": {\"fields\": [\"Name\", \"Description\"]}}]', 40, 1),
(11, '2025-12-05 08:05:27.643768', '1', 'pribadi', 1, '[{\"added\": {}}]', 58, 1),
(12, '2025-12-05 08:05:44.103058', '2', 'teknusa', 1, '[{\"added\": {}}]', 58, 1),
(13, '2025-12-05 08:05:51.949711', '3', 'Nusa Sawit', 1, '[{\"added\": {}}]', 58, 1),
(14, '2025-12-05 08:06:04.989762', '4', 'SDMPortabel', 1, '[{\"added\": {}}]', 58, 1),
(15, '2025-12-05 08:06:21.322233', '1', 'free', 1, '[{\"added\": {}}]', 59, 1),
(16, '2025-12-05 08:06:48.456655', '2', 'paid', 1, '[{\"added\": {}}]', 59, 1),
(17, '2025-12-05 08:07:16.610759', '1', 'Instagram', 1, '[{\"added\": {}}]', 60, 1),
(18, '2025-12-05 08:07:22.222964', '2', 'facebook', 1, '[{\"added\": {}}]', 60, 1),
(19, '2025-12-05 08:07:27.750278', '3', 'thread', 1, '[{\"added\": {}}]', 60, 1),
(20, '2025-12-05 08:07:35.082963', '4', 'linkedin', 1, '[{\"added\": {}}]', 60, 1),
(21, '2025-12-05 08:07:49.619896', '5', 'Linkedin Company', 1, '[{\"added\": {}}]', 60, 1),
(22, '2025-12-05 08:08:01.293176', '4', 'Linkedin', 2, '[{\"changed\": {\"fields\": [\"Name\"]}}]', 60, 1),
(23, '2025-12-05 08:08:06.776026', '3', 'Threads', 2, '[{\"changed\": {\"fields\": [\"Name\"]}}]', 60, 1),
(24, '2025-12-05 08:08:12.750186', '2', 'Facebook', 2, '[{\"changed\": {\"fields\": [\"Name\"]}}]', 60, 1),
(25, '2025-12-05 08:08:22.629121', '6', 'Linekdin Newsletter', 1, '[{\"added\": {}}]', 60, 1),
(26, '2025-12-05 08:08:54.937732', '1', 'Awareness', 1, '[{\"added\": {}}]', 61, 1),
(27, '2025-12-05 08:09:00.075251', '2', 'Interest', 1, '[{\"added\": {}}]', 61, 1),
(28, '2025-12-05 08:09:08.798658', '3', 'Desire', 1, '[{\"added\": {}}]', 61, 1),
(29, '2025-12-05 08:09:24.463654', '4', 'Action', 1, '[{\"added\": {}}]', 61, 1),
(30, '2025-12-05 08:09:29.819410', '5', 'Retention', 1, '[{\"added\": {}}]', 61, 1),
(31, '2025-12-05 08:10:30.662486', '6', 'Linkedin Newsletter', 2, '[{\"changed\": {\"fields\": [\"Name\"]}}]', 60, 1),
(32, '2025-12-05 08:17:00.947069', '6', 'personal', 1, '[{\"added\": {}}]', 40, 1),
(33, '2025-12-05 08:23:48.229732', '7', 'Blog Post', 1, '[{\"added\": {}}]', 60, 1),
(34, '2025-12-05 08:44:44.977019', '6', 'Personal', 2, '[{\"changed\": {\"fields\": [\"Name\"]}}]', 40, 1),
(35, '2025-12-05 08:44:52.674898', '4', 'Spoonfull', 2, '[{\"changed\": {\"fields\": [\"Name\"]}}]', 40, 1),
(36, '2025-12-05 08:45:03.518744', '3', 'SDMPortabel', 2, '[{\"changed\": {\"fields\": [\"Name\"]}}]', 40, 1),
(37, '2025-12-05 08:45:10.944885', '2', 'Teknusa', 2, '[{\"changed\": {\"fields\": [\"Name\"]}}]', 40, 1);

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(26, 'about', 'teamexpert'),
(27, 'accounts', 'employer'),
(2, 'admin', 'logentry'),
(4, 'auth', 'group'),
(3, 'auth', 'permission'),
(5, 'auth', 'user'),
(50, 'blog', 'article'),
(44, 'blog', 'blogsettings'),
(49, 'blog', 'category'),
(45, 'blog', 'links'),
(46, 'blog', 'sidebar'),
(47, 'blog', 'speech'),
(48, 'blog', 'tag'),
(21, 'careers', 'applicant'),
(20, 'careers', 'applicantdetails'),
(19, 'careers', 'job'),
(22, 'careers', 'jobcategory'),
(23, 'careers', 'joblocation'),
(8, 'comment', 'comment'),
(24, 'contactus', 'contact'),
(25, 'contactus', 'mailbook'),
(6, 'contenttypes', 'contenttype'),
(55, 'cookie_consent', 'cookie'),
(56, 'cookie_consent', 'cookiegroup'),
(57, 'cookie_consent', 'logitem'),
(43, 'django_summernote', 'attachment'),
(16, 'home', 'meanlist'),
(17, 'home', 'messages'),
(29, 'leads', 'interaction'),
(28, 'leads', 'lead'),
(32, 'lean', 'build'),
(34, 'lean', 'datapoint'),
(30, 'lean', 'idea'),
(33, 'lean', 'learning'),
(31, 'lean', 'measure'),
(35, 'lean', 'product'),
(36, 'ledger', 'account'),
(39, 'ledger', 'closingperiod'),
(37, 'ledger', 'journalentry'),
(38, 'ledger', 'journalitem'),
(18, 'likeunlike', 'like'),
(15, 'myzone', 'talkcontent'),
(14, 'myzone', 'talktags'),
(51, 'portfolio', 'basemodel'),
(52, 'portfolio', 'portfolio'),
(58, 'post_media', 'akun'),
(59, 'post_media', 'biaya'),
(41, 'post_media', 'channel'),
(42, 'post_media', 'channelperformance'),
(60, 'post_media', 'digitalchannel'),
(61, 'post_media', 'funnelstage'),
(40, 'post_media', 'market'),
(53, 'servermanager', 'commands'),
(54, 'servermanager', 'emailsendlog'),
(7, 'sessions', 'session'),
(9, 'setting', 'customcode'),
(10, 'setting', 'friendlinks'),
(11, 'setting', 'seo'),
(12, 'setting', 'siteinfo'),
(13, 'setting', 'social'),
(1, 'sites', 'site');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'about', '0001_initial', '2025-11-15 08:57:21.023627'),
(2, 'contenttypes', '0001_initial', '2025-11-15 08:57:21.229770'),
(3, 'contenttypes', '0002_remove_content_type_name', '2025-11-15 08:57:21.415618'),
(4, 'auth', '0001_initial', '2025-11-15 08:57:23.258606'),
(5, 'auth', '0002_alter_permission_name_max_length', '2025-11-15 08:57:23.457810'),
(6, 'auth', '0003_alter_user_email_max_length', '2025-11-15 08:57:23.563640'),
(7, 'auth', '0004_alter_user_username_opts', '2025-11-15 08:57:23.577605'),
(8, 'auth', '0005_alter_user_last_login_null', '2025-11-15 08:57:23.676847'),
(9, 'auth', '0006_require_contenttypes_0002', '2025-11-15 08:57:23.684627'),
(10, 'auth', '0007_alter_validators_add_error_messages', '2025-11-15 08:57:23.699581'),
(11, 'auth', '0008_alter_user_username_max_length', '2025-11-15 08:57:23.896283'),
(12, 'auth', '0009_alter_user_last_name_max_length', '2025-11-15 08:57:23.965921'),
(13, 'auth', '0010_alter_group_name_max_length', '2025-11-15 08:57:24.059645'),
(14, 'auth', '0011_update_proxy_permissions', '2025-11-15 08:57:24.079094'),
(15, 'auth', '0012_alter_user_first_name_max_length', '2025-11-15 08:57:24.152413'),
(16, 'accounts', '0001_initial', '2025-11-15 08:57:24.938664'),
(17, 'admin', '0001_initial', '2025-11-15 08:57:25.266096'),
(18, 'admin', '0002_logentry_remove_auto_add', '2025-11-15 08:57:25.280722'),
(19, 'admin', '0003_logentry_add_action_flag_choices', '2025-11-15 08:57:25.293544'),
(20, 'blog', '0001_initial', '2025-11-15 08:57:26.711681'),
(21, 'careers', '0001_initial', '2025-11-15 08:57:28.121453'),
(22, 'comment', '0001_initial', '2025-11-15 08:57:28.760812'),
(23, 'contactus', '0001_initial', '2025-11-15 08:57:28.852509'),
(24, 'cookie_consent', '0001_initial', '2025-11-15 08:57:29.022169'),
(25, 'cookie_consent', '0002_auto__add_logitem', '2025-11-15 08:57:29.161173'),
(26, 'cookie_consent', '0003_alter_cookiegroup_varname', '2025-11-15 08:57:29.276789'),
(27, 'cookie_consent', '0004_cookie_natural_key', '2025-11-15 08:57:30.112214'),
(28, 'django_summernote', '0001_initial', '2025-11-15 08:57:30.185552'),
(29, 'django_summernote', '0002_update-help_text', '2025-11-15 08:57:30.193440'),
(30, 'django_summernote', '0003_alter_attachment_id', '2025-11-15 08:57:30.297355'),
(31, 'home', '0001_initial', '2025-11-15 08:57:30.565704'),
(32, 'leads', '0001_initial', '2025-11-15 08:57:30.779465'),
(33, 'lean', '0001_initial', '2025-11-15 08:57:31.954378'),
(34, 'ledger', '0001_initial', '2025-11-15 08:57:32.370955'),
(35, 'ledger', '0002_alter_journalitem_credit_alter_journalitem_debit', '2025-11-15 08:57:32.570451'),
(36, 'ledger', '0003_rename_name_account_account_name_remove_account_code_and_more', '2025-11-15 08:57:33.887029'),
(37, 'ledger', '0004_journalentry_is_posted', '2025-11-15 08:57:34.020896'),
(38, 'ledger', '0005_journalitem_note', '2025-11-15 08:57:34.092110'),
(39, 'ledger', '0006_closingperiod_journalentry_period', '2025-11-15 08:57:34.214933'),
(40, 'ledger', '0007_alter_journalentry_period', '2025-11-15 08:57:34.397463'),
(41, 'ledger', '0008_alter_journalentry_period', '2025-11-15 08:57:34.408253'),
(42, 'ledger', '0009_alter_closingperiod_options', '2025-11-15 08:57:34.415959'),
(43, 'ledger', '0010_alter_closingperiod_options', '2025-11-15 08:57:34.421593'),
(44, 'ledger', '0011_alter_journalentry_date_alter_journalentry_period', '2025-11-15 08:57:34.503043'),
(45, 'likeunlike', '0001_initial', '2025-11-15 08:57:34.887116'),
(46, 'myzone', '0001_initial', '2025-11-15 08:57:35.398087'),
(47, 'portfolio', '0001_initial', '2025-11-15 08:57:35.684065'),
(48, 'post_media', '0001_initial', '2025-11-15 08:57:35.745519'),
(49, 'post_media', '0002_linkedin_for_who', '2025-11-15 08:57:35.818645'),
(50, 'post_media', '0003_alter_linkedin_tanggal_posting', '2025-11-15 08:57:35.900471'),
(51, 'post_media', '0004_alter_linkedin_judul', '2025-11-15 08:57:35.911712'),
(52, 'post_media', '0005_blog_ig', '2025-11-15 08:57:36.001063'),
(53, 'post_media', '0006_rename_for_who_blog_for_market_and_more', '2025-11-15 08:57:36.203494'),
(54, 'post_media', '0007_market_alter_blog_for_market_alter_ig_for_market_and_more', '2025-11-15 08:57:38.333349'),
(55, 'post_media', '0008_remove_blog_metode_pengukuran_remove_blog_tujuan_and_more', '2025-11-15 08:57:38.917597'),
(56, 'post_media', '0009_blog_isi_konten_ig_isi_konten_linkedin_isi_konten_and_more', '2025-11-15 08:57:39.722374'),
(57, 'post_media', '0010_alter_blog_isi_konten_alter_ig_isi_konten_and_more', '2025-11-15 08:57:39.756839'),
(58, 'post_media', '0011_alter_blog_isi_konten_alter_ig_isi_konten_and_more', '2025-11-15 08:57:39.803937'),
(59, 'post_media', '0012_channel', '2025-11-15 08:57:40.022596'),
(60, 'post_media', '0013_remove_ig_for_market_remove_linkedin_for_market_and_more', '2025-11-15 08:57:43.955336'),
(61, 'post_media', '0014_channel_akun_alter_channel_channel', '2025-11-15 08:57:44.091013'),
(62, 'post_media', '0015_alter_channel_akun', '2025-11-15 08:57:44.104076'),
(63, 'post_media', '0016_alter_channel_akun', '2025-11-15 08:57:44.113503'),
(64, 'post_media', '0017_channelsimple_channelmetric', '2025-11-15 08:57:44.431707'),
(65, 'post_media', '0018_rename_channelsimple_channelmetric_channel_and_more', '2025-11-15 08:57:44.888592'),
(66, 'post_media', '0019_remove_channelmetric_lama_jam_and_more', '2025-11-15 08:57:45.119024'),
(67, 'post_media', '0020_remove_channelmetric_lama_jam', '2025-11-15 08:57:45.175705'),
(68, 'post_media', '0021_remove_channelmetric_created_at_and_more', '2025-11-15 08:57:45.315852'),
(69, 'post_media', '0022_rename_channelsimple_channelsimple_channel_type_and_more', '2025-11-15 08:57:45.607568'),
(70, 'post_media', '0023_remove_channelsimple_lama_jam_and_more', '2025-11-15 08:57:46.976925'),
(71, 'post_media', '0024_remove_channelmetric_lama_jam', '2025-11-15 08:57:47.060350'),
(72, 'post_media', '0025_remove_channelsimple_for_market_and_more', '2025-11-15 08:57:49.478643'),
(73, 'post_media', '0026_alter_channel_as_at_1minggu_comment_and_more', '2025-11-15 08:57:51.513125'),
(74, 'post_media', '0027_alter_channel_discovery_alter_channel_follower_and_more', '2025-11-15 08:57:51.789811'),
(75, 'post_media', '0028_channel_is_posted', '2025-11-15 08:57:51.929246'),
(76, 'post_media', '0029_alter_channel_akun', '2025-11-15 08:57:51.941745'),
(77, 'post_media', '0030_alter_channel_tanggal_posting', '2025-11-15 08:57:51.951925'),
(78, 'post_media', '0031_remove_channel_as_at_1minggu_comment_and_more', '2025-11-15 08:57:53.931093'),
(79, 'post_media', '0032_alter_channel_channel', '2025-11-15 08:57:53.946217'),
(80, 'servermanager', '0001_initial', '2025-11-15 08:57:54.056524'),
(81, 'sessions', '0001_initial', '2025-11-15 08:57:54.185436'),
(82, 'setting', '0001_initial', '2025-11-15 08:57:54.518578'),
(83, 'sites', '0001_initial', '2025-11-15 08:57:54.559556'),
(84, 'sites', '0002_alter_domain_unique', '2025-11-15 08:57:54.632271'),
(85, 'leads', '0002_lead_assigned_to_lead_estimated_value_and_more', '2025-11-17 03:08:42.047100'),
(86, 'leads', '0003_remove_lead_general_notes', '2025-11-17 04:24:03.009256'),
(87, 'leads', '0004_lead_account_medsos', '2025-11-17 04:24:03.128346'),
(88, 'leads', '0005_alter_lead_account_medsos_alter_lead_lead_source', '2025-11-17 04:24:03.176766'),
(89, 'post_media', '0033_akun_biaya_digitalchannel_funnelstage_channel_amount_and_more', '2025-12-05 06:16:16.022998'),
(90, 'post_media', '0034_fix_foreign_key_data', '2025-12-05 06:16:16.060074'),
(91, 'post_media', '0035_make_foreign_keys_nullable', '2025-12-05 06:16:16.090085'),
(92, 'post_media', '0036_create_initial_data', '2025-12-05 06:16:16.111520');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('0b5xiy2zjk2ijz45xqnczagvdqheoefa', '.eJxVjEEOwiAQRe_C2pCBUigu3XsGMsNMpWpoUtqV8e7apAvd_vfef6mE21rS1mRJE6uzMur0uxHmh9Qd8B3rbdZ5rusykd4VfdCmrzPL83K4fwcFW_nWNlIY0BkOAXL2nYmRvc8QhKwTMY4JBumtAbadSMDoAGC06OJI0ffq_QHSPzdu:1vtcoi:AjpmPJ-rQ8sW0SJjbijDFOPOq4Q92tzbfBIPl39CZjo', '2026-03-07 02:34:00.845597'),
('8njimke1terazyhvnduzmcgnkz6z1fhe', '.eJxVjEEOwiAQRe_C2pCBUigu3XsGMsNMpWpoUtqV8e7apAvd_vfef6mE21rS1mRJE6uzMur0uxHmh9Qd8B3rbdZ5rusykd4VfdCmrzPL83K4fwcFW_nWNlIY0BkOAXL2nYmRvc8QhKwTMY4JBumtAbadSMDoAGC06OJI0ffq_QHSPzdu:1vRPFe:iBQRDsgmIr9B4ZK0iHS0LbsAuf1IcH_Ba_YZQFMxjA8', '2025-12-19 06:25:10.882913'),
('d5g3xpr67t25k7gp99e9pucu8txoyw6s', '.eJxVjEEOwiAQRe_C2pCBUigu3XsGMsNMpWpoUtqV8e7apAvd_vfef6mE21rS1mRJE6uzMur0uxHmh9Qd8B3rbdZ5rusykd4VfdCmrzPL83K4fwcFW_nWNlIY0BkOAXL2nYmRvc8QhKwTMY4JBumtAbadSMDoAGC06OJI0ffq_QHSPzdu:1vtH9L:dK2-8cwTF2WppcRIBa37yHjCFIGfkUvQ6Q8PyuO4B1A', '2026-03-06 03:25:51.621345'),
('erz68bt3zju78ve2dn49obf9hl87fla5', '.eJxVjEEOwiAQRe_C2pCBUigu3XsGMsNMpWpoUtqV8e7apAvd_vfef6mE21rS1mRJE6uzMur0uxHmh9Qd8B3rbdZ5rusykd4VfdCmrzPL83K4fwcFW_nWNlIY0BkOAXL2nYmRvc8QhKwTMY4JBumtAbadSMDoAGC06OJI0ffq_QHSPzdu:1w8Exm:TVQ5g52uUT-FJ_jPtBW636LPAKccU8XJtB-s-H74ZVw', '2026-04-16 10:07:46.398933'),
('f8exrpt5hosznq7bpura4isavduyojkd', '.eJxVjEEOwiAQRe_C2pCBUigu3XsGMsNMpWpoUtqV8e7apAvd_vfef6mE21rS1mRJE6uzMur0uxHmh9Qd8B3rbdZ5rusykd4VfdCmrzPL83K4fwcFW_nWNlIY0BkOAXL2nYmRvc8QhKwTMY4JBumtAbadSMDoAGC06OJI0ffq_QHSPzdu:1vKuQH:D2gdSFaA-W9v28bMNJB729E0Kr4EYdoE_DAJY0g1xTA', '2025-12-01 08:17:17.006580'),
('hnfco2g27a2sgte9q9vzji3ttrr4ty4z', '.eJxVjEEOwiAQRe_C2pCBUigu3XsGMsNMpWpoUtqV8e7apAvd_vfef6mE21rS1mRJE6uzMur0uxHmh9Qd8B3rbdZ5rusykd4VfdCmrzPL83K4fwcFW_nWNlIY0BkOAXL2nYmRvc8QhKwTMY4JBumtAbadSMDoAGC06OJI0ffq_QHSPzdu:1vKpKz:uvSxUXuJRxj_he7d1omicne01dvf10EkrEe5a5Oh5YM', '2025-12-01 02:51:29.857533'),
('hpu1y8pchi5jnwcsghrsmkybairdl12h', '.eJxVjEEOwiAQRe_C2pCBUigu3XsGMsNMpWpoUtqV8e7apAvd_vfef6mE21rS1mRJE6uzMur0uxHmh9Qd8B3rbdZ5rusykd4VfdCmrzPL83K4fwcFW_nWNlIY0BkOAXL2nYmRvc8QhKwTMY4JBumtAbadSMDoAGC06OJI0ffq_QHSPzdu:1w7kVx:MDtVX8Vky3RTcl98tdcZ0n6UVY9Iv_W1b6z8MvwigcQ', '2026-04-15 01:37:01.667388'),
('k3mnn0m806hap56i4zpcoop499bfph5j', '.eJxVjEEOwiAQRe_C2pCBUigu3XsGMsNMpWpoUtqV8e7apAvd_vfef6mE21rS1mRJE6uzMur0uxHmh9Qd8B3rbdZ5rusykd4VfdCmrzPL83K4fwcFW_nWNlIY0BkOAXL2nYmRvc8QhKwTMY4JBumtAbadSMDoAGC06OJI0ffq_QHSPzdu:1vcfhZ:Vuta7LAXTje2w3LbaqasMJCi49ZWh7pwJh8r5RfP8YY', '2026-01-19 08:12:33.927097'),
('kd24ts8c501l2cm4obyqgdjnop4hftc9', '.eJxVjEEOwiAQRe_C2pCBUigu3XsGMsNMpWpoUtqV8e7apAvd_vfef6mE21rS1mRJE6uzMur0uxHmh9Qd8B3rbdZ5rusykd4VfdCmrzPL83K4fwcFW_nWNlIY0BkOAXL2nYmRvc8QhKwTMY4JBumtAbadSMDoAGC06OJI0ffq_QHSPzdu:1vu1LH:mxWtAnW34IU2_qQ_dgmmKRGY3b0msk3FTj4mtSXr0I8', '2026-03-08 04:45:15.853208'),
('klxdmre7yq8xzku5329ozwflfbkmjrfe', '.eJxVjEEOwiAQRe_C2pCBUigu3XsGMsNMpWpoUtqV8e7apAvd_vfef6mE21rS1mRJE6uzMur0uxHmh9Qd8B3rbdZ5rusykd4VfdCmrzPL83K4fwcFW_nWNlIY0BkOAXL2nYmRvc8QhKwTMY4JBumtAbadSMDoAGC06OJI0ffq_QHSPzdu:1vr3Rr:b85vVapObcf-YZTCpiZjdqCGBvE-RGH2T3SATN1kD6M', '2026-02-28 00:23:47.315266'),
('kzxeaght8qmqabejxv444lg9igmn2x8f', '.eJxVjEEOwiAQRe_C2pCBUigu3XsGMsNMpWpoUtqV8e7apAvd_vfef6mE21rS1mRJE6uzMur0uxHmh9Qd8B3rbdZ5rusykd4VfdCmrzPL83K4fwcFW_nWNlIY0BkOAXL2nYmRvc8QhKwTMY4JBumtAbadSMDoAGC06OJI0ffq_QHSPzdu:1vSoBi:Qym3MXxZSLcupASHYJRMUtkJYtaF_OC-Z28ZoKtkC3Q', '2025-12-23 03:14:54.625397'),
('m1ya0b5vnf7g7v9r83pm6dmal0sl2w0c', '.eJxVjEEOwiAQRe_C2pCBUigu3XsGMsNMpWpoUtqV8e7apAvd_vfef6mE21rS1mRJE6uzMur0uxHmh9Qd8B3rbdZ5rusykd4VfdCmrzPL83K4fwcFW_nWNlIY0BkOAXL2nYmRvc8QhKwTMY4JBumtAbadSMDoAGC06OJI0ffq_QHSPzdu:1w7jsH:vfPNFGifYwIBkkWltJWjm3mFGtVdDzMM3YoWIM9gsOw', '2026-04-15 00:56:01.469302'),
('myfhtx9xiypn2vg26f7t2fkn3lnnyl8b', '.eJxVjEEOwiAQRe_C2pCBUigu3XsGMsNMpWpoUtqV8e7apAvd_vfef6mE21rS1mRJE6uzMur0uxHmh9Qd8B3rbdZ5rusykd4VfdCmrzPL83K4fwcFW_nWNlIY0BkOAXL2nYmRvc8QhKwTMY4JBumtAbadSMDoAGC06OJI0ffq_QHSPzdu:1vdeuq:5_YPtLltpCoQsQ0_lWoKisnoUvYfQjcqkr6xeowpAn0', '2026-01-22 01:34:20.745050'),
('pf4jfgjdbpxnidmnzu9ie84e4ytfmr7u', '.eJxVjEEOwiAQRe_C2pCBUigu3XsGMsNMpWpoUtqV8e7apAvd_vfef6mE21rS1mRJE6uzMur0uxHmh9Qd8B3rbdZ5rusykd4VfdCmrzPL83K4fwcFW_nWNlIY0BkOAXL2nYmRvc8QhKwTMY4JBumtAbadSMDoAGC06OJI0ffq_QHSPzdu:1w7lYs:P0saqfq1ZyvBeEzwuzc-vwyW793OjZN0wJ85MHkjV3k', '2026-04-15 02:44:06.552018'),
('qafb8ir4v6t0xpzsmikqma533fmvy6th', '.eJxVjEEOwiAQRe_C2pCBUigu3XsGMsNMpWpoUtqV8e7apAvd_vfef6mE21rS1mRJE6uzMur0uxHmh9Qd8B3rbdZ5rusykd4VfdCmrzPL83K4fwcFW_nWNlIY0BkOAXL2nYmRvc8QhKwTMY4JBumtAbadSMDoAGC06OJI0ffq_QHSPzdu:1vSqUM:lnOPMdnIVvQPNHWcqfCuzCgJUUFa7DKDYwRVy30nuH0', '2025-12-23 05:42:18.860997'),
('qyfi55vlzof46dsq1aw3vnktxf6o1y2o', '.eJxVjEEOwiAQRe_C2pCBUigu3XsGMsNMpWpoUtqV8e7apAvd_vfef6mE21rS1mRJE6uzMur0uxHmh9Qd8B3rbdZ5rusykd4VfdCmrzPL83K4fwcFW_nWNlIY0BkOAXL2nYmRvc8QhKwTMY4JBumtAbadSMDoAGC06OJI0ffq_QHSPzdu:1w7pZn:prFXrg3aN_1rodyVsOkHCwZ9ZR5100l9QinYSHuNQ2c', '2026-04-15 07:01:19.974153'),
('r75zoja95a22d1bwqh4fy37xwz5xa8yp', '.eJxVjEEOwiAQRe_C2pCBUigu3XsGMsNMpWpoUtqV8e7apAvd_vfef6mE21rS1mRJE6uzMur0uxHmh9Qd8B3rbdZ5rusykd4VfdCmrzPL83K4fwcFW_nWNlIY0BkOAXL2nYmRvc8QhKwTMY4JBumtAbadSMDoAGC06OJI0ffq_QHSPzdu:1vKplA:ErfjSBGgrT5BKYmkNncf_mtHxu86VgxZRNvzgHdaam4', '2025-12-01 03:18:32.903837'),
('s129hpbzlztji2p786j9mnwfognireb8', '.eJxVjEEOwiAQRe_C2pCBUigu3XsGMsNMpWpoUtqV8e7apAvd_vfef6mE21rS1mRJE6uzMur0uxHmh9Qd8B3rbdZ5rusykd4VfdCmrzPL83K4fwcFW_nWNlIY0BkOAXL2nYmRvc8QhKwTMY4JBumtAbadSMDoAGC06OJI0ffq_QHSPzdu:1vTWpg:VVe9Xq4kxfTIPEnMnTgrOLS15YvQKll0nScXPwtyK-s', '2025-12-25 02:55:08.968273'),
('sh8h7ykuvvw1d0pv6rnn00uqfe289bsh', '.eJxVjEEOwiAQRe_C2pCBUigu3XsGMsNMpWpoUtqV8e7apAvd_vfef6mE21rS1mRJE6uzMur0uxHmh9Qd8B3rbdZ5rusykd4VfdCmrzPL83K4fwcFW_nWNlIY0BkOAXL2nYmRvc8QhKwTMY4JBumtAbadSMDoAGC06OJI0ffq_QHSPzdu:1vPtOI:-iwKaxL7Ydgc8Ukkx2sJke98u1WQ5PcbTMmWG9utOmM', '2025-12-15 02:11:50.291632'),
('tl16y1zft7t1bhusf6zgl6v2a761airw', '.eJxVjEEOwiAQRe_C2pCBUigu3XsGMsNMpWpoUtqV8e7apAvd_vfef6mE21rS1mRJE6uzMur0uxHmh9Qd8B3rbdZ5rusykd4VfdCmrzPL83K4fwcFW_nWNlIY0BkOAXL2nYmRvc8QhKwTMY4JBumtAbadSMDoAGC06OJI0ffq_QHSPzdu:1vMDqd:pM0x2c8niQlbVKOMhPK58znLOEL6PbAJsOV0egkJ9zY', '2025-12-04 23:13:55.102152'),
('yvwtwi2rt9g4gzxwt8ookxfpg9btaqiw', '.eJxVjEEOwiAQRe_C2pCBUigu3XsGMsNMpWpoUtqV8e7apAvd_vfef6mE21rS1mRJE6uzMur0uxHmh9Qd8B3rbdZ5rusykd4VfdCmrzPL83K4fwcFW_nWNlIY0BkOAXL2nYmRvc8QhKwTMY4JBumtAbadSMDoAGC06OJI0ffq_QHSPzdu:1vMFr7:vliqxYla2GIaYM-f2askBaJwglL54IPdvrn4ZqIWi2o', '2025-12-05 01:22:33.624206');

-- --------------------------------------------------------

--
-- Table structure for table `django_site`
--

CREATE TABLE `django_site` (
  `id` int(11) NOT NULL,
  `domain` varchar(100) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `django_site`
--

INSERT INTO `django_site` (`id`, `domain`, `name`) VALUES
(1, 'example.com', 'example.com');

-- --------------------------------------------------------

--
-- Table structure for table `django_summernote_attachment`
--

CREATE TABLE `django_summernote_attachment` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `file` varchar(100) NOT NULL,
  `uploaded` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `home_meanlist`
--

CREATE TABLE `home_meanlist` (
  `id` bigint(20) NOT NULL,
  `title` varchar(100) NOT NULL,
  `link` varchar(100) DEFAULT NULL,
  `icon` varchar(100) DEFAULT NULL,
  `status` varchar(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `home_messages`
--

CREATE TABLE `home_messages` (
  `id` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `admin_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `leads_interaction`
--

CREATE TABLE `leads_interaction` (
  `id` bigint(20) NOT NULL,
  `note` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `lead_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `leads_interaction`
--

INSERT INTO `leads_interaction` (`id`, `note`, `created_at`, `lead_id`) VALUES
(3, '1. diskusi mengenai marketing digital\r\n2. tertarik dengan landing page', '2025-06-20 15:37:35.139371', 3),
(4, '1. perlu bertemu dan diskusi,\r\n2. bisa untuk training di universitas NU\r\n3. perlu buat Company Profile', '2025-06-20 15:39:55.723060', 4),
(5, '1. konsultan untuk sawit', '2025-06-20 15:40:17.850469', 5),
(6, 'ada di dalam list sdm portabel', '2025-06-20 15:41:17.514114', 7),
(7, 'terkoneksi via linkedin, sudah dihubungi dengan add note', '2025-07-13 20:27:00.567802', 8),
(8, 'sudah dihuubngi via linkedin untuk potensi kerja sama HRIS perekrutan tenaga sawit', '2025-07-13 20:36:28.918290', 9),
(9, 'cek app perpuskite', '2025-08-27 13:01:13.792158', 10),
(10, 'buatkan marketplace untuk sablon', '2025-08-27 13:01:31.794253', 3),
(11, 'buat aplikasi untuk survey data dari rt sampai ke desa', '2025-08-27 13:02:13.956919', 11),
(12, 'tambahkan dashboard juga', '2025-08-27 13:02:22.598562', 11),
(14, '* coba untuk ajak acara sawit di qubu resort 24-26 Septmber 2025 * buatkan aplikasi untuk pengaturan tenaga outsource\r\n\r\nTambah Interaksi\r\n\r\nNote:', '2025-08-27 13:03:55.529657', 9),
(15, 'ikut pelatihan mereka kunjungi web nya', '2025-08-27 13:04:56.114063', 13),
(16, 'closed sepertinya gagal', '2025-08-29 09:49:41.229197', 8),
(17, 'gieta amali marketer sebagai product testes', '2025-08-31 18:20:21.026947', 10),
(18, 'tawarkan mengenai sdm portabel', '2025-08-31 18:20:59.158484', 17),
(19, 'ada yang masuk dari pontiprenerur tapi setelah itu tidak hubungi lagi', '2025-10-07 15:19:02.076104', 18),
(20, 'konvert ke pak Hendra', '2025-10-07 15:19:50.221931', 14),
(21, 'ada kirim 2 email di Jumat 3 Oktober 2025', '2025-10-07 15:42:30.759482', 20),
(22, 'setuju untuk membuat rak nusantara', '2025-10-07 15:43:14.274596', 4),
(23, 'https://www.instagram.com/p3sm_eradayadigital/\r\n\r\ndikontak via ig sdmportabel , sepertinya cukup terbuka', '2025-10-07 15:45:27.666655', 21),
(24, 'ada diskusi mengenai akuntasi untuk TKD dan BUMDES', '2025-10-09 09:38:05.777690', 19),
(25, 'lokasi di kebun', '2025-10-09 09:38:23.631790', 16),
(26, 'sudah di info mengenai app untuk KK', '2025-10-20 14:43:08.916298', 22),
(27, 'ditambah info mengenai akuntasi untuk bumdes', '2025-10-20 14:43:53.325172', 11),
(28, 'update app pada tanah masih kurang pada survey', '2025-11-04 08:03:24.063679', 22),
(29, 'perlu ditawarkan program', '2025-11-17 04:30:52.759137', 25),
(30, 'karena company profile kurang baik', '2025-11-17 08:36:02.640013', 18),
(31, 'kalau nusasawit sudah jadi baru hubungi', '2025-11-17 08:38:56.069500', 20),
(32, 'masuk tanya mengenai ai untuk HR', '2025-12-09 05:52:59.832482', 27),
(33, 'pada jumat 9 jan 26 ada live IG bersama', '2026-01-15 05:17:58.006796', 28),
(34, 'rencana untuk halal bihalal', '2026-04-01 07:10:09.761704', 24);

-- --------------------------------------------------------

--
-- Table structure for table `leads_lead`
--

CREATE TABLE `leads_lead` (
  `id` bigint(20) NOT NULL,
  `name` varchar(200) NOT NULL,
  `email` varchar(254) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `company` varchar(200) DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `assigned_to_id` int(11) DEFAULT NULL,
  `estimated_value` decimal(12,2) DEFAULT NULL,
  `lead_source` varchar(50) DEFAULT NULL,
  `next_follow_up` date DEFAULT NULL,
  `priority` varchar(10) NOT NULL,
  `account_medsos` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `leads_lead`
--

INSERT INTO `leads_lead` (`id`, `name`, `email`, `phone`, `company`, `status`, `created_at`, `assigned_to_id`, `estimated_value`, `lead_source`, `next_follow_up`, `priority`, `account_medsos`) VALUES
(3, 'reza', '', '', 'sablon kita', 'qualified', '2025-06-20 15:36:59.879764', NULL, NULL, 'Self', '2025-11-19', 'cold', NULL),
(4, 'adit', 'NULL', 'NULL', 'universitas NU', 'contacted', '2025-06-20 15:38:25.687307', NULL, NULL, NULL, NULL, 'warm', NULL),
(5, 'yansyah', 'NULL', 'NULL', 'NULL', 'lost', '2025-06-20 15:40:08.371867', NULL, NULL, NULL, NULL, 'warm', NULL),
(6, 'gina', 'NULL', 'NULL', 'parto id', 'qualified', '2025-06-20 15:40:41.702485', NULL, NULL, NULL, NULL, 'warm', NULL),
(7, 'andi', 'NULL', 'NULL', 'NULL', 'new', '2025-06-20 15:41:07.738943', NULL, NULL, NULL, NULL, 'warm', NULL),
(8, 'Sri Dimas Yudha', 'NULL', 'NULL', 'pindo deli', 'lost', '2025-07-13 20:26:36.328224', NULL, NULL, NULL, NULL, 'warm', NULL),
(9, 'alan hendrawa', 'NULL', 'NULL', 'dananjaya borneo', 'lost', '2025-07-13 20:36:03.878744', NULL, NULL, NULL, NULL, 'warm', NULL),
(10, 'perpustakaan rumah bersama', 'NULL', 'NULL', 'NULL', 'new', '2025-08-27 13:00:46.861104', NULL, NULL, NULL, NULL, 'warm', NULL),
(11, 'gaguk', 'NULL', 'NULL', 'NULL', 'new', '2025-08-27 13:01:47.012132', NULL, NULL, NULL, NULL, 'warm', NULL),
(13, 'dinas kop dan umkm', 'NULL', 'NULL', 'NULL', 'new', '2025-08-27 13:04:41.719322', NULL, NULL, NULL, NULL, 'warm', NULL),
(14, 'IPOSC', 'NULL', 'NULL', 'NULL', 'won', '2025-08-29 09:50:43.924631', NULL, NULL, NULL, NULL, 'warm', NULL),
(15, 'ilham pacific agro', 'NULL', 'NULL', 'NULL', 'new', '2025-08-29 10:18:47.416442', NULL, NULL, NULL, NULL, 'warm', NULL),
(16, 'hamdan siadari', 'NULL', 'NULL', 'charon pokphand', 'new', '2025-08-29 10:21:47.680183', NULL, NULL, NULL, NULL, 'warm', NULL),
(17, 'sawal', 'NULL', 'NULL', 'fintera', 'new', '2025-08-31 18:20:51.098566', NULL, NULL, NULL, NULL, 'warm', NULL),
(18, 'konsultan sawit', '', '', NULL, 'lost', '2025-08-31 18:25:58.980385', 1, NULL, 'referral', NULL, 'warm', NULL),
(19, 'sigit', 'NULL', 'NULL', 'asosiasi petani', 'new', '2025-09-02 08:53:38.025418', NULL, NULL, NULL, NULL, 'warm', NULL),
(20, 'hendra purba', 'media_perkebunan@yahoo.co.id', 'NULL', 'media perkebunan', 'qualified', '2025-09-12 17:15:02.000000', NULL, NULL, 'Self', '2025-12-01', 'warm', NULL),
(21, 'era daya digital', '', '', 'NULL', 'contacted', '2025-10-07 15:45:02.739632', 1, NULL, 'instagram', '2025-11-20', 'cold', 'p3sm_eradayadigital'),
(22, 'hardi', '', '', 'desa sumberoto', 'contacted', '2025-10-20 14:39:13.497699', 1, NULL, 'Self', '2025-11-24', 'warm', NULL),
(23, 'sumarjono saragih', '', '', 'gapki', 'new', '2025-10-20 14:54:17.036612', NULL, NULL, 'Self', NULL, 'warm', NULL),
(24, 'hrd pontianak', '', '', 'NULL', 'qualified', '2025-11-04 08:02:35.986521', NULL, NULL, 'Self', NULL, 'warm', NULL),
(25, 'koko mbpru', '', '', 'mbpru', 'new', '2025-11-04 08:11:37.702609', NULL, NULL, 'referral', NULL, 'warm', NULL),
(27, 'yuk bersyukur', '', '', NULL, 'new', '2025-12-09 05:52:59.813406', 1, NULL, 'threads', '2025-12-19', 'warm', 'https://www.threads.com/@yuk.bersyukur'),
(28, 'deti nuriska', '', '', 'my republic', 'new', '2026-01-15 05:17:57.900786', NULL, NULL, NULL, '2026-01-15', 'warm', 'https://www.instagram.com/detinuriska_/');

-- --------------------------------------------------------

--
-- Table structure for table `lean_build`
--

CREATE TABLE `lean_build` (
  `id` bigint(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` longtext NOT NULL,
  `link` varchar(200) NOT NULL,
  `status` varchar(20) NOT NULL,
  `idea_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lean_datapoint`
--

CREATE TABLE `lean_datapoint` (
  `id` bigint(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `value` double NOT NULL,
  `measured_at` datetime(6) NOT NULL,
  `note` longtext NOT NULL,
  `measure_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lean_idea`
--

CREATE TABLE `lean_idea` (
  `id` bigint(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` longtext NOT NULL,
  `assumptions` longtext NOT NULL,
  `priority` int(11) NOT NULL,
  `status` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lean_learning`
--

CREATE TABLE `lean_learning` (
  `id` bigint(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `summary` longtext NOT NULL,
  `action` longtext NOT NULL,
  `idea_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lean_measure`
--

CREATE TABLE `lean_measure` (
  `id` bigint(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `metric` varchar(200) NOT NULL,
  `target` double DEFAULT NULL,
  `current` double DEFAULT NULL,
  `notes` longtext NOT NULL,
  `product_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lean_product`
--

CREATE TABLE `lean_product` (
  `id` bigint(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `name` varchar(200) NOT NULL,
  `description` longtext NOT NULL,
  `public` tinyint(1) NOT NULL,
  `build_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ledger_account`
--

CREATE TABLE `ledger_account` (
  `id` bigint(20) NOT NULL,
  `account_name` varchar(100) NOT NULL,
  `account_type` varchar(50) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `balance_type` varchar(10) NOT NULL,
  `coa` varchar(100) NOT NULL,
  `coa_role_default` varchar(100) DEFAULT NULL,
  `locked` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `ledger_account`
--

INSERT INTO `ledger_account` (`id`, `account_name`, `account_type`, `active`, `balance_type`, `coa`, `coa_role_default`, `locked`) VALUES
(1, '1010: Cash', 'ASSET', 1, 'Debit', 'Default CoA', NULL, 0),
(2, '1050: Short Term Investments', 'ASSET', 1, 'Debit', 'Default CoA', NULL, 0),
(3, '1100: Accounts Receivable', 'ASSET', 1, 'Debit', 'Default CoA', NULL, 0),
(4, '1200: Inventory', 'ASSET', 1, 'Debit', 'Default CoA', NULL, 0),
(5, '1110: Uncollectibles', 'ASSET', 1, 'Credit', 'Default CoA', NULL, 0),
(6, '1300: Prepaid Expenses', 'ASSET', 1, 'Debit', 'Default CoA', NULL, 0),
(7, '1510: Notes Receivable', 'ASSET', 1, 'Debit', 'Default CoA', NULL, 0),
(8, '1520: Land', 'ASSET', 1, 'Debit', 'Default CoA', NULL, 0),
(9, '1530: Securities', 'ASSET', 1, 'Debit', 'Default CoA', NULL, 0),
(10, '1610: Buildings', 'ASSET', 1, 'Debit', 'Default CoA', NULL, 0),
(11, '1611: Less: Buildings Accumulated Depreciation', 'ASSET', 1, 'Credit', 'Default CoA', NULL, 0),
(12, '1620: Plant', 'ASSET', 1, 'Debit', 'Default CoA', NULL, 0),
(13, '1640: Vehicles', 'ASSET', 1, 'Debit', 'Default CoA', NULL, 0),
(14, '1650: Furniture & Fixtures', 'ASSET', 1, 'Debit', 'Default CoA', NULL, 0),
(15, '1621: Less: Plant Accumulated Depreciation', 'ASSET', 1, 'Credit', 'Default CoA', NULL, 0),
(16, '1641: Less: Vehicles Accumulated Depreciation', 'ASSET', 1, 'Credit', 'Default CoA', NULL, 0),
(17, '1651: Less: Furniture & Fixtures Accumulated Depreciation', 'ASSET', 1, 'Credit', 'Default CoA', NULL, 0),
(18, '1630: Equipment', 'ASSET', 1, 'Debit', 'Default CoA', NULL, 0),
(19, '1631: Less: Equipment Accumulated Depreciation', 'ASSET', 1, 'Credit', 'Default CoA', NULL, 0),
(20, '1810: Goodwill', 'ASSET', 1, 'Debit', 'Default CoA', NULL, 0),
(21, '1820: Intellectual Property', 'ASSET', 1, 'Debit', 'Default CoA', NULL, 0),
(22, '1830: Less: Intangible Assets Accumulated Amortization', 'ASSET', 1, 'Credit', 'Default CoA', NULL, 0),
(23, '1910: Securities Unrealized Gains/Losses', 'ASSET', 1, 'Debit', 'Default CoA', NULL, 0),
(24, '1920: PPE Unrealized Gains/Losses', 'ASSET', 1, 'Debit', 'Default CoA', NULL, 0),
(25, '5010: Cost of Goods Sold', 'COGS', 1, 'Debit', 'Default CoA', NULL, 0),
(26, '3010: Capital Account 1', 'CAPITAL', 1, 'Credit', 'Default CoA', NULL, 0),
(27, '3020: Capital Account 2', 'CAPITAL', 1, 'Credit', 'Default CoA', NULL, 0),
(28, '3030: Capital Account 3', 'CAPITAL', 1, 'Credit', 'Default CoA', NULL, 0),
(29, '3110: Common Stock', 'CAPITAL', 1, 'Credit', 'Default CoA', NULL, 0),
(30, '3120: Preferred Stock', 'CAPITAL', 1, 'Credit', 'Default CoA', NULL, 0),
(31, '3910: Available for Sale', 'CAPITAL', 1, 'Credit', 'Default CoA', NULL, 0),
(32, '3920: PPE Unrealized Gains/Losses', 'CAPITAL', 1, 'Credit', 'Default CoA', NULL, 0),
(33, '3930: Dividends & Distributions', 'CAPITAL', 1, 'Debit', 'Default CoA', NULL, 0),
(34, '6010: Advertising', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(35, '6020: Amortization', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(36, '6030: Auto Expense', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(37, '6040: Bad Debt', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(38, '6050: Bank Charges', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(39, '6060: Commission Expense', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(40, '6080: Employee Benefits', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(41, '6081: Employee Wages', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(42, '6090: Freight', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(43, '6110: Gifts', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(44, '6120: Insurance', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(45, '6140: Professional Fees', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(46, '6150: License Expense', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(47, '6170: Maintenance Expense', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(48, '6180: Meals & Entertainment', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(49, '6190: Office Expense', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(50, '6220: Printing', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(51, '6230: Postage', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(52, '6240: Rent', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(53, '6250: Maintenance & Repairs', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(54, '6251: Maintenance', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(55, '6252: Repairs', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(56, '6253: HOA', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(57, '6254: Snow Removal', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(58, '6255: Lawn Care', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(59, '6260: Salaries', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(60, '6270: Supplies', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(61, '6290: Utilities', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(62, '6292: Sewer', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(63, '6293: Gas', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(64, '6294: Garbage', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(65, '6295: Electricity', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(66, '6300: Property Management', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(67, '6400: Vacancy', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(68, '6130: Interest Expense on Short Term Debt', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(69, '6131: Interest Expense on Long Term Debt', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(70, '6210: Payroll Taxes', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(71, '6280: Taxes', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(72, '6070: Depreciation Expense', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(73, '6075: Amortization Expense', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(74, '6500: Misc. Expense', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(75, '4010: Sales Income', 'INCOME', 1, 'Credit', 'Default CoA', NULL, 0),
(76, '4020: Investing Income', 'INCOME', 1, 'Credit', 'Default CoA', NULL, 0),
(77, '4030: Interest Income', 'INCOME', 1, 'Credit', 'Default CoA', NULL, 0),
(78, '4040: Capital Gain/Loss Income', 'INCOME', 1, 'Credit', 'Default CoA', NULL, 0),
(79, '4050: Other Income', 'INCOME', 1, 'Credit', 'Default CoA', NULL, 0),
(80, '2010: Accounts Payable', 'LIABILITY', 1, 'Credit', 'Default CoA', NULL, 0),
(81, '2020: Wages Payable', 'LIABILITY', 1, 'Credit', 'Default CoA', NULL, 0),
(82, '2030: Interest Payable', 'LIABILITY', 1, 'Credit', 'Default CoA', NULL, 0),
(83, '2040: Short-Term Notes Payable', 'LIABILITY', 1, 'Credit', 'Default CoA', NULL, 0),
(84, '2050: Current Maturities LT Debt', 'LIABILITY', 1, 'Credit', 'Default CoA', NULL, 0),
(85, '2060: Deferred Revenues', 'LIABILITY', 1, 'Credit', 'Default CoA', NULL, 0),
(86, '2070: Other Payables', 'LIABILITY', 1, 'Credit', 'Default CoA', NULL, 0),
(87, '2110: Long Term Notes Payable', 'LIABILITY', 1, 'Credit', 'Default CoA', NULL, 0),
(88, '2120: Bonds Payable', 'LIABILITY', 1, 'Credit', 'Default CoA', NULL, 0),
(89, '2130: Mortgage Payable', 'LIABILITY', 1, 'Credit', 'Default CoA', NULL, 0),
(90, '4051: income pelatihan', 'INCOME', 1, 'Credit', 'Default CoA', NULL, 0),
(91, '6051: Transfer Fee', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(92, '6082: Part time fee', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(93, '6181: Airfare expenses', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(94, '2061: Credit Card Payable', 'LIABILITY', 1, 'Credit', 'Default CoA', NULL, 0),
(95, '6182: Land Transportation Expense', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(96, '6600: loss on bad decision', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(97, '6183: Training Staff', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(98, '4052: income konsultan sdm', 'INCOME', 1, 'Credit', 'Default CoA', NULL, 0),
(99, '6191: Internet Expense', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(100, '1011: Bank Mandiri', 'ASSET', 1, 'Debit', 'Default CoA', NULL, 0),
(101, '1012: Britama', 'ASSET', 1, 'Debit', 'Default CoA', NULL, 0),
(102, '6192: Hosting and Domain Expenses', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(103, '6296: Telephone Expenses', 'EXPENSES', 1, 'Debit', 'Default CoA', NULL, 0),
(104, '3999: retained earnings', 'CAPITAL', 1, 'Credit', 'Default CoA', NULL, 0),
(105, '1030: PPN Masukan', 'ASSET', 1, 'Debit', 'Default CoA', NULL, 0),
(106, '2080: PPN Keluaran', 'LIABILITY', 1, 'Credit', 'Default CoA', NULL, 0),
(107, '2081: Hutang PPN', 'LIABILITY', 1, 'Credit', 'Default CoA', NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `ledger_closingperiod`
--

CREATE TABLE `ledger_closingperiod` (
  `id` bigint(20) NOT NULL,
  `period` varchar(7) NOT NULL,
  `is_closed` tinyint(1) NOT NULL,
  `closed_at` datetime(6) DEFAULT NULL,
  `closed_by` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `ledger_closingperiod`
--

INSERT INTO `ledger_closingperiod` (`id`, `period`, `is_closed`, `closed_at`, `closed_by`) VALUES
(5, '2025-10', 1, '2025-10-19 07:54:22.293783', 'admin'),
(6, '2025-11', 1, '2025-12-01 02:16:34.191829', 'admin'),
(7, '2025-12', 1, '2026-01-12 04:48:52.718211', 'admin'),
(8, '2026-01', 1, '2026-02-19 07:11:59.801847', 'admin'),
(9, '2026-02', 1, '2026-04-01 01:42:47.151690', 'admin'),
(10, '2026-03', 1, '2026-04-01 07:03:12.972363', 'admin'),
(11, '2026-04', 0, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `ledger_journalentry`
--

CREATE TABLE `ledger_journalentry` (
  `id` bigint(20) NOT NULL,
  `date` date NOT NULL,
  `description` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `is_posted` tinyint(1) NOT NULL,
  `period` varchar(7) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `ledger_journalentry`
--

INSERT INTO `ledger_journalentry` (`id`, `date`, `description`, `created_at`, `is_posted`, `period`) VALUES
(7, '2025-06-20', 'biaya sdmportabel', '2025-06-20 20:15:55.678694', 1, '2025-10'),
(8, '2025-06-20', 'salah transfer', '2025-06-20 20:17:08.639731', 1, '2025-10'),
(9, '2025-06-19', 'pengembalian salah trf dari loker media', '2025-06-20 20:18:54.752244', 1, '2025-10'),
(10, '2025-05-30', 'pemasukan pertama', '2025-06-20 20:56:57.306908', 1, '2025-10'),
(11, '2025-06-29', 'penyesuaian jurnal salah', '2025-06-29 08:34:58.637950', 1, '2025-10'),
(12, '2025-07-02', 'fee CTO June 25', '2025-07-02 10:04:40.212396', 1, '2025-10'),
(13, '2025-07-01', 'travel ke jakarta', '2025-07-02 10:19:14.512033', 1, '2025-10'),
(14, '2025-06-05', 'transport ke riau', '2025-07-13 14:43:34.675095', 1, '2025-10'),
(15, '2025-05-05', 'transport ke riau', '2025-07-13 14:45:22.319398', 1, '2025-10'),
(16, '2025-05-30', 'transport ke padang ketemu ceo parto', '2025-07-13 14:50:30.411130', 1, '2025-10'),
(17, '2025-05-30', 'inventory', '2025-07-13 14:52:59.537052', 1, '2025-10'),
(18, '2025-07-30', 'inventory', '2025-07-13 14:55:09.755131', 1, '2025-10'),
(19, '2025-05-30', 'jurnal awal kebanyaan untuk meals dan entertain', '2025-07-13 15:20:45.420244', 1, '2025-10'),
(20, '2025-06-02', 'meals and entertain', '2025-07-13 15:22:45.341178', 1, '2025-10'),
(21, '2025-06-04', 'piutang ke prayugo', '2025-07-13 15:23:30.865497', 1, '2025-10'),
(22, '2025-06-05', 'transfer dari jurnal lama ke baru', '2025-07-13 15:32:37.218242', 1, '2025-10'),
(23, '2025-06-05', 'transfer dari jurnal lama ke baru', '2025-07-13 15:35:16.294571', 1, '2025-10'),
(24, '2025-07-02', 'gaji CTO June 25', '2025-07-13 15:39:28.898612', 1, '2025-10'),
(25, '2025-07-02', 'reverse double jurnal fee CTO June 25', '2025-07-13 21:48:19.197740', 1, '2025-10'),
(26, '2025-07-03', 'pembayaran sebagai narasumber hipkasi di jakarta ttg AI', '2025-07-13 21:58:31.307276', 1, '2025-10'),
(27, '2025-08-05', 'fee ke 2 konsultan sdm pt plp lampung', '2025-08-26 18:42:24.311788', 1, '2025-10'),
(28, '2025-07-26', 'fee ke 1 konsultan sdm pt plp lampung', '2025-08-26 18:45:01.159577', 1, '2025-10'),
(29, '2025-08-26', 'Internet Agustus 25', '2025-08-26 19:57:57.754315', 1, '2025-10'),
(30, '2025-08-27', 'perbaikan charger fee konsultan', '2025-08-27 08:38:25.902968', 1, '2025-10'),
(31, '2025-08-27', 'perbaikan untuk pembayaran internet', '2025-08-27 08:42:29.802613', 1, '2025-10'),
(32, '2025-08-23', 'pembelian hosting teknusa.com 3 bulan (Ag, sep, okt 25)', '2025-08-27 09:26:24.686304', 1, '2025-10'),
(33, '2025-08-23', 'pembelian domain teknusa 1 tahun ag25-jul26', '2025-08-27 09:29:37.848879', 1, '2025-10'),
(34, '2025-08-25', 'pembelian hosting sdmportabel di domainesia', '2025-08-27 09:31:20.937652', 1, '2025-10'),
(35, '2025-08-29', 'promosi di acara remote workers pontianak agustus 25', '2025-08-29 09:47:23.495715', 1, '2025-10'),
(36, '2025-08-30', 'meals koordinasi', '2025-08-31 18:22:58.957958', 1, '2025-10'),
(37, '2025-09-01', 'telephone Agustus 25', '2025-09-01 09:30:32.247279', 1, '2025-10'),
(38, '2025-09-01', 'gaji CTO Agustus 25', '2025-09-01 09:38:19.747387', 1, '2025-10'),
(39, '2025-09-01', 'asuransi BPJS BPU Eva September 25', '2025-09-01 10:03:03.063601', 1, '2025-10'),
(40, '2025-09-14', 'claim konsultang plp di lampung', '2025-09-01 10:05:47.967562', 1, '2025-10'),
(41, '2025-08-01', 'gaji CTO Juli 25', '2025-09-01 10:11:26.062790', 1, '2025-10'),
(42, '2025-08-27', 'fee ke 3 konsultan sdm pt plp lampung', '2025-09-01 10:15:51.749160', 1, '2025-10'),
(43, '2025-09-05', 'internet mifi 80 gb', '2025-09-05 09:57:13.068655', 1, '2025-10'),
(44, '2025-09-19', 'minum di surya coffe', '2025-09-19 16:29:36.755544', 1, '2025-10'),
(45, '2025-09-25', 'ikut acara remote worker', '2025-09-26 11:17:57.018163', 1, '2025-10'),
(46, '2025-09-30', 'di cafe arunika', '2025-09-30 14:59:37.447246', 1, '2025-10'),
(47, '2025-09-26', 'internet September 2025', '2025-09-30 15:01:24.930831', 1, '2025-10'),
(48, '2025-10-01', 'fee CTO Sept 25', '2025-10-01 09:09:37.651795', 1, '2025-10'),
(49, '2025-10-02', 'sewa kantor Oktober 25', '2025-10-02 12:17:36.572674', 1, '2025-10'),
(50, '2025-10-19', 'Automatic Retained Earnings Adjustment for 2025-10', '2025-10-19 07:54:22.323711', 1, '2025-10'),
(51, '2025-10-20', 'fee ke 4 konsultan sdm pt plp lampung (final project inventarisasi HR', '2025-10-23 08:14:32.663903', 1, '2025-11'),
(52, '2025-10-21', 'service hp untuk hp kerja dari bekas usaha lama', '2025-10-23 08:21:37.742590', 1, '2025-11'),
(53, '2025-10-20', 'minum dengan cto di satu watt', '2025-10-23 13:38:17.408083', 1, '2025-11'),
(54, '2025-10-23', 'pulsa untuk hidupkan no mifi', '2025-10-23 13:39:19.417091', 1, '2025-11'),
(55, '2025-10-27', 'internet oktober 25', '2025-10-30 07:47:30.400832', 1, '2025-11'),
(56, '2025-11-01', 'fee cto Oktober 25', '2025-11-04 08:07:57.275179', 1, '2025-11'),
(57, '2025-11-04', 'pulsa untuk HP', '2025-11-04 08:10:51.420345', 1, '2025-11'),
(58, '2025-11-04', 'BPJSTK BPU Okt 25', '2025-11-04 08:21:52.706007', 1, '2025-11'),
(59, '2025-11-21', 'biaya server Dec25, Jan25, Feb 26', '2025-11-21 02:41:22.400285', 1, '2025-11'),
(60, '2025-11-21', 'pembelian hosting teknusa.com 3 bulan (Ag, sep, okt 25)', '2025-11-21 03:34:47.409842', 1, '2025-11'),
(70, '2025-11-30', 'diskusi mingguan', '2025-12-01 02:13:33.672217', 1, '2025-11'),
(71, '2025-12-01', 'fee cto Nov 25', '2025-12-01 02:16:08.290287', 1, '2025-11'),
(72, '2025-12-01', 'Automatic Retained Earnings Adjustment for 2025-11', '2025-12-01 02:16:34.206815', 1, '2025-11'),
(73, '2025-12-09', 'pembelian cloud vps bulanan di biznet', '2025-12-09 07:26:52.537693', 1, '2025-12'),
(74, '2025-12-12', 'pembelian domain nusasawit.com dan nusasawit.web.id', '2025-12-12 02:42:22.672031', 1, '2025-12'),
(75, '2026-01-01', 'fee cto Dec 25', '2026-01-12 04:48:21.158184', 1, '2025-12'),
(76, '2026-01-12', 'Automatic Retained Earnings Adjustment for 2025-12', '2026-01-12 04:48:52.740003', 1, '2025-12'),
(77, '2026-01-15', 'promosi di acara remote workers pontianak 18 Jan 26', '2026-01-15 05:36:39.999767', 1, '2026-01'),
(78, '2026-01-13', 'ketemu CTO', '2026-01-15 05:37:36.609401', 1, '2026-01'),
(79, '2026-01-08', 'ikut pelatihan wirausaha di NEO hotel oleh EU', '2026-01-16 02:33:54.781531', 1, '2026-01'),
(80, '2026-02-01', 'fee cto Jan 26', '2026-02-19 07:06:02.793405', 1, '2026-01'),
(81, '2026-01-09', 'cloud vps bulanan di biznetgio Jan 26', '2026-02-19 07:09:36.937370', 1, '2026-01'),
(82, '2026-02-19', 'Automatic Retained Earnings Adjustment for 2026-01', '2026-02-19 07:11:59.825292', 1, '2026-01'),
(83, '2026-02-19', 'hosting teknusa Feb, Mar, Aprl 26', '2026-02-19 07:37:35.857135', 1, '2026-02'),
(84, '2026-02-20', 'perpanjangan domain sdmportabel.com 2026', '2026-02-20 02:18:28.381197', 1, '2026-02'),
(85, '2026-03-01', 'fee CTO Feb 26', '2026-04-01 01:42:17.672575', 1, '2026-02'),
(86, '2026-04-01', 'Automatic Retained Earnings Adjustment for 2026-02', '2026-04-01 01:42:47.300532', 1, '2026-02'),
(87, '2026-03-06', 'vps untuk odoo software house project', '2026-04-01 01:45:51.993960', 1, '2026-03'),
(88, '2026-03-06', 'vps untuk sdmportabel', '2026-04-01 01:46:50.652788', 1, '2026-03'),
(89, '2026-04-01', 'fee cto mar 26', '2026-04-01 07:02:26.659127', 1, '2026-03'),
(90, '2026-04-01', 'Automatic Retained Earnings Adjustment for 2026-03', '2026-04-01 07:03:12.989767', 1, '2026-03'),
(91, '2026-04-06', 'vps biznet odoo teknusa April 26', '2026-04-06 07:19:27.535412', 0, '2026-04'),
(92, '2026-04-06', 'vps biznet sdmportabel April 2026', '2026-04-06 07:21:31.630540', 0, '2026-04');

-- --------------------------------------------------------

--
-- Table structure for table `ledger_journalitem`
--

CREATE TABLE `ledger_journalitem` (
  `id` bigint(20) NOT NULL,
  `debit` int(11) NOT NULL,
  `credit` int(11) NOT NULL,
  `account_id` bigint(20) NOT NULL,
  `journal_entry_id` bigint(20) NOT NULL,
  `note` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `ledger_journalitem`
--

INSERT INTO `ledger_journalitem` (`id`, `debit`, `credit`, `account_id`, `journal_entry_id`, `note`) VALUES
(18, 684000, 0, 1, 8, 'salah transfer'),
(19, 0, 684000, 80, 8, ''),
(20, 25000, 0, 48, 7, 'minum di lumen'),
(21, 20000, 0, 49, 7, 'perbaikan hp asus'),
(22, 50000, 0, 45, 7, 'biaya voucher pendirian pt di ahu'),
(23, 70000, 0, 49, 7, 'pembelian keyboard laptop toshiba'),
(24, 250000, 0, 49, 7, ''),
(25, 0, 415000, 1, 7, 'total pengeluaran kas'),
(26, 0, 0, 1, 7, ''),
(27, 684000, 0, 80, 9, 'pengembalian salah trf dari loker media'),
(28, 0, 684000, 1, 9, 'pengembalian salah transfer'),
(31, 0, 13000000, 90, 10, ''),
(32, 13000000, 0, 1, 10, ''),
(37, 13000000, 0, 90, 11, 'penyesuaian jurnal salah'),
(38, 0, 13000000, 1, 11, 'penyesuaian jurnal salah'),
(39, 13000000, 0, 1, 11, ''),
(40, 0, 13000000, 26, 11, ''),
(44, 500000, 0, 92, 12, 'fee CTO June 25'),
(45, 6500, 0, 91, 12, 'trans fee CTO June 25'),
(46, 0, 506500, 1, 12, 'fee CTO june 25'),
(49, 1052100, 0, 93, 13, 'CEO jkt 2/7/25 seminar'),
(50, 0, 1052100, 94, 13, 'CEO jkt 2/7/25 seminar'),
(102, 0, 182000, 1, 18, 'inventory'),
(103, 182000, 0, 4, 18, 'inventory'),
(104, 500000, 0, 59, 24, 'gaji CTO june 25'),
(105, 6500, 0, 38, 24, 'bea transfer bank gaji cto June 25'),
(106, 0, 506500, 1, 24, 'gaji CTO June 25'),
(107, 6000000, 0, 97, 23, 'pembayaran ke foundry'),
(108, 0, 6000000, 80, 23, 'pembayaran ke foundry'),
(109, 352000, 0, 4, 23, 'inventory'),
(110, 0, 352000, 1, 23, 'inventory'),
(111, 1000000, 0, 41, 23, 'gaji Feb 25 CTO'),
(112, 0, 1000000, 1, 23, 'gaji Feb 25 CTO'),
(113, 0, 0, 1, 23, ''),
(114, 531470, 0, 96, 22, 'sewa hostinger tidak bisa dipakai'),
(115, 0, 531470, 1, 22, 'sewa hostinger tidak bisa dipakai'),
(116, 531470, 0, 48, 22, 'entertain'),
(117, 0, 531470, 1, 22, 'entertain'),
(118, 50000, 0, 48, 22, 'meals'),
(119, 0, 50000, 1, 22, 'meals'),
(120, 325000, 0, 47, 22, 'maintenance laptop'),
(121, 0, 325000, 1, 22, 'maintenance laptop'),
(122, 465000, 0, 4, 22, 'inventory'),
(123, 0, 465000, 1, 22, 'inventory'),
(124, 155000, 0, 4, 22, 'inventory'),
(125, 0, 155000, 1, 22, 'inventory'),
(126, 100000, 0, 34, 22, 'sponsor acara remote worker'),
(127, 0, 100000, 1, 22, ''),
(128, 0, 0, 95, 22, ''),
(129, 0, 1020300, 1, 14, 'transport ke riau'),
(130, 1020300, 0, 93, 14, 'transport ke riau'),
(131, 3000000, 0, 7, 21, 'piutang ke prayugo'),
(132, 0, 3000000, 1, 21, 'piutang ke prayugo'),
(133, 75999, 0, 7, 20, 'meals'),
(134, 0, 75999, 1, 20, 'meals'),
(135, 60000, 0, 4, 19, 'inventory'),
(136, 0, 60000, 1, 19, 'inventory'),
(137, 190000, 0, 4, 19, 'inventory'),
(138, 0, 190000, 1, 19, 'inventory'),
(139, 28000, 0, 4, 19, 'inventory'),
(140, 0, 28000, 1, 19, 'inventory'),
(141, 111000, 0, 48, 19, 'meals'),
(142, 0, 111000, 1, 19, 'meals'),
(143, 100000, 0, 48, 19, 'meals'),
(144, 0, 100000, 1, 19, 'meals'),
(145, 194000, 0, 48, 19, 'meals'),
(146, 0, 194000, 1, 19, 'meals'),
(147, 0, 60000, 1, 17, 'inventory'),
(148, 60000, 0, 4, 17, 'inventory'),
(149, 0, 271700, 1, 16, 'transport ke padang ketemu ceo parto'),
(150, 271700, 0, 95, 16, 'transport ke padang ketemu ceo parto'),
(151, 0, 1087800, 1, 15, 'transport ke riau'),
(152, 1087800, 0, 93, 15, 'transport ke riau'),
(156, 506500, 0, 1, 25, ''),
(157, 0, 6500, 91, 25, ''),
(158, 0, 500000, 92, 25, ''),
(161, 0, 1500000, 79, 26, ''),
(162, 1500000, 0, 1, 26, ''),
(163, 2250000, 0, 1, 27, ''),
(164, 0, 2250000, 98, 27, ''),
(165, 1500000, 0, 1, 28, ''),
(166, 0, 1500000, 98, 28, ''),
(167, 0, 194250, 1, 29, ''),
(168, 194250, 0, 99, 29, ''),
(173, 0, 194250, 99, 31, ''),
(174, 194250, 0, 1, 31, ''),
(175, 0, 194250, 100, 31, ''),
(176, 194250, 0, 99, 31, ''),
(181, 0, 86580, 100, 32, ''),
(182, 86580, 0, 102, 32, ''),
(183, 0, 130980, 100, 33, ''),
(184, 130980, 0, 102, 33, ''),
(185, 0, 841174, 101, 34, ''),
(186, 841174, 0, 102, 34, ''),
(187, 0, 1500000, 1, 30, ''),
(188, 1500000, 0, 100, 30, 'fee pertama'),
(189, 0, 2250000, 1, 30, ''),
(190, 2250000, 0, 100, 30, 'fee kedua'),
(191, 0, 52500, 100, 35, ''),
(192, 50000, 0, 34, 35, ''),
(193, 2500, 0, 38, 35, ''),
(194, 0, 25000, 100, 36, ''),
(195, 25000, 0, 48, 36, ''),
(196, 0, 108743, 100, 37, ''),
(197, 108743, 0, 103, 37, ''),
(198, 0, 2800, 100, 37, ''),
(199, 2800, 0, 1, 37, ''),
(200, 0, 500000, 100, 38, ''),
(201, 500000, 0, 59, 38, ''),
(202, 0, 2500, 100, 38, ''),
(203, 2500, 0, 38, 38, ''),
(204, 0, 36800, 100, 39, ''),
(205, 36800, 0, 44, 39, ''),
(206, 0, 261000, 101, 40, ''),
(207, 261000, 0, 100, 40, ''),
(208, 0, 1000000, 100, 41, ''),
(209, 1000000, 0, 59, 41, ''),
(210, 0, 2500, 100, 41, ''),
(211, 2500, 0, 38, 41, ''),
(212, 0, 3000000, 98, 42, ''),
(213, 3000000, 0, 100, 42, ''),
(214, 0, 100000, 100, 43, ''),
(215, 100000, 0, 99, 43, ''),
(216, 0, 12000, 100, 44, ''),
(217, 12000, 0, 48, 44, ''),
(218, 0, 30000, 100, 45, ''),
(219, 30000, 0, 34, 45, ''),
(220, 0, 7000, 1, 46, ''),
(221, 7000, 0, 48, 46, ''),
(222, 0, 194250, 100, 47, ''),
(223, 194250, 0, 99, 47, ''),
(224, 0, 500000, 101, 48, ''),
(225, 500000, 0, 59, 48, ''),
(226, 0, 650000, 101, 49, ''),
(227, 650000, 0, 49, 49, ''),
(228, 9520617, 0, 104, 50, 'Transfer Loss to Retained Earnings'),
(233, 0, 7300000, 98, 51, ''),
(234, 7300000, 0, 100, 51, ''),
(237, 0, 230000, 100, 52, ''),
(238, 230000, 0, 18, 52, ''),
(277, 0, 5745190, 104, 72, 'Transfer Profit to Retained Earnings'),
(282, 0, 500000, 100, 71, ''),
(283, 500000, 0, 59, 71, ''),
(284, 0, 28000, 1, 70, ''),
(285, 28000, 0, 48, 70, ''),
(286, 0, 86580, 100, 60, ''),
(287, 86580, 0, 102, 60, ''),
(288, 0, 86580, 100, 59, ''),
(289, 86580, 0, 102, 59, ''),
(290, 0, 36800, 100, 58, ''),
(291, 36800, 0, 44, 58, ''),
(292, 0, 91600, 100, 57, ''),
(293, 91600, 0, 103, 57, ''),
(294, 0, 500000, 100, 56, ''),
(295, 500000, 0, 59, 56, ''),
(296, 0, 194250, 100, 55, ''),
(297, 194250, 0, 99, 55, ''),
(298, 0, 15000, 100, 54, ''),
(299, 15000, 0, 99, 54, ''),
(300, 0, 16000, 100, 53, ''),
(301, 16000, 0, 48, 53, ''),
(304, 0, 500000, 100, 75, ''),
(305, 500000, 0, 59, 75, ''),
(306, 0, 146203, 100, 74, ''),
(307, 146203, 0, 102, 74, ''),
(308, 0, 55000, 100, 73, ''),
(309, 55000, 0, 102, 73, ''),
(310, 701203, 0, 104, 76, 'Transfer Loss to Retained Earnings'),
(321, 0, 500000, 100, 80, ''),
(322, 500000, 0, 59, 80, ''),
(323, 0, 150000, 100, 77, ''),
(324, 150000, 0, 34, 77, ''),
(325, 0, 20000, 100, 78, ''),
(326, 20000, 0, 48, 78, ''),
(327, 0, 65400, 100, 81, ''),
(328, 65400, 0, 102, 81, ''),
(329, 0, 150000, 100, 79, ''),
(330, 150000, 0, 97, 79, ''),
(331, 885400, 0, 104, 82, 'Transfer Loss to Retained Earnings'),
(341, 0, 500000, 1, 85, ''),
(342, 500000, 0, 59, 85, ''),
(343, 0, 227550, 100, 84, ''),
(344, 205000, 0, 102, 84, ''),
(345, 22550, 0, 1, 84, ''),
(346, 0, 86580, 100, 83, ''),
(347, 75000, 0, 102, 83, ''),
(348, 3000, 0, 91, 83, ''),
(349, 8580, 0, 105, 83, ''),
(350, 783000, 0, 104, 86, 'Transfer Loss to Retained Earnings'),
(357, 0, 500000, 100, 89, ''),
(358, 500000, 0, 59, 89, ''),
(359, 0, 65490, 100, 88, ''),
(360, 65490, 0, 102, 88, ''),
(361, 0, 65490, 100, 87, ''),
(362, 65490, 0, 102, 87, ''),
(363, 630980, 0, 104, 90, 'Transfer Loss to Retained Earnings'),
(366, 0, 65490, 100, 91, ''),
(367, 65490, 0, 102, 91, ''),
(370, 0, 65490, 100, 92, ''),
(371, 65490, 0, 102, 92, '');

-- --------------------------------------------------------

--
-- Table structure for table `likeunlike_like`
--

CREATE TABLE `likeunlike_like` (
  `id` bigint(20) NOT NULL,
  `object_id` varchar(50) NOT NULL,
  `timestamp` datetime(6) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `myzone_talkcontent`
--

CREATE TABLE `myzone_talkcontent` (
  `id` bigint(20) NOT NULL,
  `body` longtext NOT NULL,
  `created_time` datetime(6) NOT NULL,
  `status` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `myzone_talkcontent_tag`
--

CREATE TABLE `myzone_talkcontent_tag` (
  `id` bigint(20) NOT NULL,
  `talkcontent_id` bigint(20) NOT NULL,
  `talktags_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `myzone_talktags`
--

CREATE TABLE `myzone_talktags` (
  `id` bigint(20) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `portfolio_basemodel`
--

CREATE TABLE `portfolio_basemodel` (
  `id` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `modified_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `portfolio_portfolio`
--

CREATE TABLE `portfolio_portfolio` (
  `basemodel_ptr_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `about` longtext NOT NULL,
  `cover` varchar(100) NOT NULL,
  `views` int(10) UNSIGNED NOT NULL CHECK (`views` >= 0),
  `words` int(10) UNSIGNED NOT NULL CHECK (`words` >= 0),
  `status` varchar(1) NOT NULL,
  `author_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `post_media_akun`
--

CREATE TABLE `post_media_akun` (
  `id` bigint(20) NOT NULL,
  `name` varchar(20) DEFAULT NULL,
  `description` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `post_media_akun`
--

INSERT INTO `post_media_akun` (`id`, `name`, `description`) VALUES
(1, 'pribadi', ''),
(2, 'teknusa', ''),
(3, 'Nusa Sawit', ''),
(4, 'SDMPortabel', '');

-- --------------------------------------------------------

--
-- Table structure for table `post_media_biaya`
--

CREATE TABLE `post_media_biaya` (
  `id` bigint(20) NOT NULL,
  `name` varchar(20) DEFAULT NULL,
  `description` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `post_media_biaya`
--

INSERT INTO `post_media_biaya` (`id`, `name`, `description`) VALUES
(1, 'free', ''),
(2, 'paid', '');

-- --------------------------------------------------------

--
-- Table structure for table `post_media_channel`
--

CREATE TABLE `post_media_channel` (
  `id` bigint(20) NOT NULL,
  `channel_old` varchar(20) DEFAULT NULL,
  `funnel_stage` varchar(20) NOT NULL,
  `kategori_biaya` varchar(100) NOT NULL,
  `tanggal_posting` datetime(6) DEFAULT NULL,
  `rencana_tanggal_posting` date DEFAULT NULL,
  `jenis_konten` varchar(100) NOT NULL,
  `judul` varchar(200) NOT NULL,
  `isi_konten` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `for_market_id` bigint(20) NOT NULL,
  `channel_id` bigint(20) DEFAULT NULL,
  `akun_id` bigint(20) NOT NULL,
  `is_posted` tinyint(1) NOT NULL,
  `amount` decimal(12,2) DEFAULT NULL,
  `funnel_stage_id` bigint(20) DEFAULT NULL,
  `kategori_biaya_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `post_media_channel`
--

INSERT INTO `post_media_channel` (`id`, `channel_old`, `funnel_stage`, `kategori_biaya`, `tanggal_posting`, `rencana_tanggal_posting`, `jenis_konten`, `judul`, `isi_konten`, `created_at`, `updated_at`, `for_market_id`, `channel_id`, `akun_id`, `is_posted`, `amount`, `funnel_stage_id`, `kategori_biaya_id`) VALUES
(1, 'blog', 'awareness', 'free', '2025-05-10 14:36:00.000000', NULL, 'blog', 'Manfaat Big 5 Personality dalam Rekrutmen Karyawan', '<p><a href=\"https://sdmportabel.com/blog/manfaat-big-5-personality-dalam-rekrutmen-karyawan/\">https://sdmportabel.com/blog/manfaat-big-5-personality-dalam-rekrutmen-karyawan/</a></p>', '2025-06-12 14:37:27.177153', '2025-12-05 08:24:52.501625', 3, 7, 4, 1, NULL, 1, 1),
(2, 'blog', 'awareness', 'free', '2025-05-10 14:44:00.000000', NULL, 'blog', 'Manfaat DOPE Analysis dalam Organisasi UMKM dan Startup', '<p><a href=\"https://sdmportabel.com/blog/manfaat-dope-analysis-dalam-organisasi-umkm-dan-st/\">https://sdmportabel.com/blog/manfaat-dope-analysis-dalam-organisasi-umkm-dan-st/</a></p>', '2025-06-12 14:46:03.116118', '2025-12-05 08:24:31.631803', 3, 7, 4, 1, NULL, 1, 1),
(3, 'ig', 'awareness', 'free', '2024-12-14 14:55:00.000000', NULL, 'post', 'implementasi lean HR untuk umkm dan startup', '<p><a href=\"https://www.instagram.com/p/DDjETj7z8Ki/?igsh=OG9ucjM3amNveGtu\">https://www.instagram.com/p/DDjETj7z8Ki/?igsh=OG9ucjM3amNveGtu</a></p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>&nbsp;</p>', '2025-06-12 14:57:36.802141', '2025-12-05 08:19:49.028797', 3, 1, 4, 1, NULL, 1, 1),
(4, 'ig', 'awareness', 'free', '2024-12-14 15:04:00.000000', NULL, 'post', 'proses sumber daya manusia', '<p><a href=\"https://www.instagram.com/p/DDjEVJGTiY8/?igsh=MWM1dnVvd3dnOHZxcA%3D%3D\">https://www.instagram.com/p/DDjEVJGTiY8/?igsh=MWM1dnVvd3dnOHZxcA%3D%3D</a></p>', '2025-06-12 15:07:41.368106', '2025-12-05 08:20:26.982466', 3, 1, 4, 1, NULL, 1, 1),
(6, 'ig', 'awareness', 'free', '2025-03-03 15:29:00.000000', NULL, 'post', 'konflik', '<p><a href=\"https://www.instagram.com/p/DGu3uKfz0Ih/?igsh=MTI3cDJkcjF2amE1Yg%3D%3D\">https://www.instagram.com/p/DGu3uKfz0Ih/?igsh=MTI3cDJkcjF2amE1Yg%3D%3D</a></p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<ul>\r\n	<li>\r\n	<p>? Ketika komunikasi tidak berjalan, konflik jadi tak terhindarkan&hellip; ?<br />\r\n	<br />\r\n	Pernah mengalami situasi seperti ini di tempat kerja? Salah paham, miskomunikasi, dan kurangnya koordinasi bisa menghambat produktivitas tim. ?<br />\r\n	<br />\r\n	<a href=\"https://www.instagram.com/sdmportabel/\" tabindex=\"0\">@sdmportabel</a>&nbsp;hadir untuk membantu membangun strategi komunikasi yang lebih efektif agar tim lebih solid dan bisnis semakin berkembang. ?<br />\r\n	<br />\r\n	? Solusi dimulai dari komunikasi yang lebih baik. Siap memperbaiki tim Anda?<br />\r\n	<br />\r\n	<a href=\"https://www.instagram.com/explore/tags/sdmportabel/\" tabindex=\"0\">#SDMPortabel</a>&nbsp;<a href=\"https://www.instagram.com/explore/tags/komunikasiefektif/\" tabindex=\"0\">#KomunikasiEfektif</a>&nbsp;<a href=\"https://www.instagram.com/explore/tags/bisnissukses/\" tabindex=\"0\">#BisnisSukses</a>&nbsp;<a href=\"https://www.instagram.com/explore/tags/timsolid/\" tabindex=\"0\">#TimSolid</a>&nbsp;<a href=\"https://www.instagram.com/explore/tags/hrconsulting/\" tabindex=\"0\">#HRConsulting</a>&nbsp;<a href=\"https://www.instagram.com/explore/tags/hc/\" tabindex=\"0\">#HC</a>&nbsp;<a href=\"https://www.instagram.com/explore/tags/hr/\" tabindex=\"0\">#HR</a>&nbsp;<a href=\"https://www.instagram.com/explore/tags/umkm/\" tabindex=\"0\">#UMKM</a>&nbsp;<a href=\"https://www.instagram.com/explore/tags/startup/\" tabindex=\"0\">#Startup</a></p>\r\n\r\n	<p>14w</p>\r\n	</li>\r\n</ul>\r\n\r\n<ul>\r\n</ul>', '2025-06-12 15:32:52.267181', '2025-12-05 08:31:51.156352', 3, 1, 4, 1, NULL, 1, 1),
(7, 'ig', 'awareness', 'free', '2025-05-09 15:33:00.000000', NULL, 'post', 'kinerja karyawan', '<p><a href=\"https://www.instagram.com/p/DJbpr9AzUTe/?igsh=bGYxdzRjam1oaHdi\">https://www.instagram.com/p/DJbpr9AzUTe/?igsh=bGYxdzRjam1oaHdi</a></p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<ul>\r\n	<li>\r\n	<p>? Kenapa Evaluasi Kinerja Karyawan Itu Penting?<br />\r\n	<br />\r\n	Evaluasi kinerja bukan sekadar formalitas tahunan &mdash; ini adalah alat strategis untuk membantu karyawan dan perusahaan tumbuh bersama.<br />\r\n	<br />\r\n	? Mengukur pencapaian terhadap target &amp; KPI<br />\r\n	? Mengidentifikasi kekuatan dan area pengembangan<br />\r\n	? Memberikan umpan balik konstruktif<br />\r\n	? Menjadi dasar pengambilan keputusan HR: promosi, pelatihan, hingga kompensasi<br />\r\n	<br />\r\n	Tanpa evaluasi yang jelas, perusahaan bisa kehilangan arah dan potensi besar dari timnya.<br />\r\n	<br />\r\n	? Di SDM Portabel, kami bantu UMKM dan startup membangun sistem evaluasi kinerja yang terstruktur, objektif, dan berbasis data.<br />\r\n	<br />\r\n	? Sudah punya sistem penilaian kinerja di tempatmu? Ceritakan di kolom komentar!<br />\r\n	<br />\r\n	<a href=\"https://www.instagram.com/explore/tags/sdmportabel/\" tabindex=\"0\">#SDMPortabel</a>&nbsp;<a href=\"https://www.instagram.com/explore/tags/evaluasikinerja/\" tabindex=\"0\">#EvaluasiKinerja</a>&nbsp;<a href=\"https://www.instagram.com/explore/tags/hrforstartup/\" tabindex=\"0\">#HRforStartup</a>&nbsp;<a href=\"https://www.instagram.com/explore/tags/hrumkm/\" tabindex=\"0\">#HRUMKM</a>&nbsp;<a href=\"https://www.instagram.com/explore/tags/peopledevelopment/\" tabindex=\"0\">#PeopleDevelopment</a>&nbsp;<a href=\"https://www.instagram.com/explore/tags/humancapital/\" tabindex=\"0\">#HumanCapital</a></p>\r\n\r\n	<p>4w</p>\r\n	</li>\r\n</ul>\r\n\r\n<ul>\r\n</ul>', '2025-06-12 15:35:56.340831', '2025-12-05 08:30:43.291519', 3, 1, 4, 1, NULL, 1, 1),
(8, 'ig', 'interest', 'free', '2025-06-12 20:47:00.000000', NULL, 'carousel', 'jangan sampai salah pilih calon karyawan', '<p><a href=\"https://www.instagram.com/p/DKzY0Jsz1cf/?img_index=2&amp;igsh=dnJsa2twazZ0eXF2\">https://www.instagram.com/p/DKzY0Jsz1cf/?img_index=2&amp;igsh=dnJsa2twazZ0eXF2</a></p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>? **Jangan sampai salah pilih calon karyawan!**<br />\r\nSatu keputusan rekrutmen yang keliru bisa memicu konflik tim, menurunkan performa, bahkan menambah biaya operasional diam-diam.</p>\r\n\r\n<p>? Solusinya? **Kenali kepribadian sejak awal** dengan metode yang teruji:<br />\r\n? **BIG 5 Personality** (Openness, Conscientiousness, dst.)<br />\r\n? **DOPE Model** (Dove, Owl, Peacock, Eagle)</p>\r\n\r\n<p>Contoh pertanyaan:<br />\r\n?? &ldquo;Apa kamu suka ide baru &amp; eksperimen?&rdquo;<br />\r\n?? &ldquo;Kamu lebih suka kerja sendiri atau mengatur orang lain?&rdquo;</p>\r\n\r\n<p>? Dengan asesmen yang tepat, kamu bisa:<br />\r\n? Tempatkan orang di posisi yang sesuai<br />\r\n? Bangun tim yang saling melengkapi<br />\r\n? Hindari &ldquo;bom waktu&rdquo; dalam organisasi</p>\r\n\r\n<p>? DM kami untuk:</p>\r\n\r\n<p>* Template pertanyaan siap pakai<br />\r\n* Demo fitur HRIS kami<br />\r\n* Sesi konsultasi gratis untuk seleksi SDM berbasis kepribadian</p>\r\n\r\n<p>\\#HRIndonesia #BigFive #DOPEModel #HRISUMKM #RekrutmenCerdas #SDMPortabel #HiringSmart #TalentMapping #HumanCapitalStrategi<br />\r\n&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; https://www.instagram.com/p/DKzY0Jsz1cf/?img_index=2&amp;igsh=dnJsa2twazZ0eXF2</p>', '2025-06-12 20:49:42.193049', '2025-12-05 08:28:51.603593', 3, 1, 4, 1, NULL, 1, 1),
(10, 'linkedin', 'awareness', 'free', NULL, NULL, 'post', 'cerita refleksi', '<p><a href=\"https://www.linkedin.com/posts/eva-setyabudi-72976578_ceritalapangan-sdmportabel-hrindonesia-activity-7339264055225851904-dEx-?utm_source=social_share_send&amp;utm_medium=member_desktop_web&amp;rcm=ACoAABB8X9EB_v8ZPzE7uIfTPAMawiECDBWPOsc\">https://www.linkedin.com/posts/eva-setyabudi-72976578_ceritalapangan-sdmportabel-hrindonesia-activity-7339264055225851904-dEx-?utm_source=social_share_send&amp;utm_medium=member_desktop_web&amp;rcm=ACoAABB8X9EB_v8ZPzE7uIfTPAMawiECDBWPOsc</a></p>', '2025-06-13 19:16:44.077046', '2025-12-05 08:17:20.521512', 6, 4, 1, 1, NULL, 1, 1),
(11, 'threads', 'awareness', 'free dari akun personal', NULL, NULL, 'post', 'cerita lama', '<p><a href=\"https://www.threads.com/@eva_setyabudi/post/DK1z2gQp54m?xmt=AQF0R3EE2h679_OSywq7iDrSTTv-4lL9V4LXsCeRTM7qwg\">https://www.threads.com/@eva_setyabudi/post/DK1z2gQp54m?xmt=AQF0R3EE2h679_OSywq7iDrSTTv-4lL9V4LXsCeRTM7qwg</a></p>', '2025-06-13 19:22:51.503783', '2025-12-05 08:20:45.616371', 6, 3, 1, 0, NULL, 1, 1),
(12, 'linkedin_newsletter', 'awareness', 'free', '2025-06-24 12:00:00.000000', NULL, 'newsletter', 'Saat KPI Malah Memecah Tim', '<p><a href=\"https://www.linkedin.com/pulse/saat-kpi-malah-memecah-tim-eva-setyabudi-c4l2c\">https://www.linkedin.com/pulse/saat-kpi-malah-memecah-tim-eva-setyabudi-c4l2c</a></p>', '2025-06-13 19:54:12.818026', '2025-12-05 08:48:18.968642', 5, 6, 1, 1, NULL, 1, 1),
(13, 'linkedin_newsletter', 'action', 'free', '2025-09-24 14:00:00.000000', NULL, 'newsletter', 'Tes Psikologi DOPE vs DISC: Mana yang Lebih Cocok untuk Perusahaan, Startup, dan UMKM?', '<p><a href=\"https://www.linkedin.com/pulse/tes-psikologi-dope-vs-disc-mana-yang-lebih-cocok-untuk-eva-setyabudi-jpjdc\">https://www.linkedin.com/pulse/tes-psikologi-dope-vs-disc-mana-yang-lebih-cocok-untuk-eva-setyabudi-jpjdc</a></p>', '2025-09-12 17:55:45.840285', '2025-12-05 08:48:00.619266', 5, 6, 4, 1, NULL, 1, 1),
(14, 'blog', 'awareness', 'free', '2025-10-28 14:00:00.000000', NULL, 'blog post', '1. Perencanaan Tenaga Kerja (Workforce Planning)', '<p>Dalam mengelola suatu perusahaan, tenaga kerja adalah tulang punggung organisasi yang menentukan arah pertumbuhan dan daya saing bisnis. Pengaturan tenaga kerja yang tidak seimbang dapat menimbulkan risiko besar: bila terlalu sedikit, perusahaan sulit berkembang karena beban kerja berlebihan dan inovasi terhambat; namun bila terlalu banyak, biaya operasional meningkat dan margin keuntungan bisa menurun. Oleh karena itu, penting untuk menemukan titik keseimbangan optimal antara jumlah tenaga kerja, biaya yang dikeluarkan, dan nilai yang dihasilkan. Langkah pertama adalah mendefinisikan secara jelas komponen biaya tenaga kerja&mdash;meliputi gaji, tunjangan (termasuk THR), kontribusi BPJS, bonus, biaya rekrutmen, pelatihan, serta outsourcing&mdash;kemudian menentukan basis perhitungannya, apakah terhadap pendapatan (revenue) atau harga pokok produksi (HPP). Rasio biaya tenaga kerja dihitung dengan rumus (Total Biaya Tenaga Kerja &divide; Basis) &times; 100%, lalu dibandingkan dengan benchmark industri untuk mengukur efisiensi. Jika rasio lebih tinggi dari standar, perlu evaluasi terhadap produktivitas, struktur kompensasi, atau potensi overstaffing; sedangkan bila terlalu rendah, risiko under-resourcing bisa menghambat kinerja dan layanan. Dari hasil analisis tersebut, perusahaan dapat mengambil langkah strategis seperti process redesign berbasis lean, upskilling, otomatisasi, atau penyesuaian model kerja agar investasi pada tenaga kerja benar-benar menciptakan nilai yang sepadan.</p>\r\n\r\n<p>Berikut adalah daftar rasio biaya tenaga kerja di Indonesia yang disarikan dari berbagai sumber dan dapat digunakan sebagai acuan awal dalam analisis efisiensi tenaga kerja di berbagai sektor industri:</p>\r\n\r\n<ul>\r\n	<li>\r\n	<p><strong>F&amp;B / Restoran / Kafe:</strong> 20% &ndash; 35%. Umumnya dihitung sebagai persentase dari omzet atau penjualan. Banyak panduan lokal merekomendasikan target sekitar 25&ndash;30% agar usaha F&amp;B tetap sehat.</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Retail (toko ritel, minimarket):</strong> 8% &ndash; 20%. Bergantung pada format usaha (convenience store vs butik premium). Karena margin ritel tipis, biaya tenaga kerja biasanya lebih terkendali dibanding F&amp;B.</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Manufaktur (pabrik, pengolahan):</strong> 10% &ndash; 30%. Untuk manufaktur padat karya rasio bisa lebih tinggi, sedangkan pada industri yang menggunakan otomatisasi tinggi cenderung lebih rendah.</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Konstruksi:</strong> 20% &ndash; 40% (sering sekitar 30%). Biasanya dihitung terhadap nilai kontrak atau HPP proyek; upah dan tenaga borongan dapat menyumbang porsi besar pada proyek padat tenaga.</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Kesehatan (rumah sakit, klinik):</strong> 35% &ndash; 65%. Sektor ini sangat intensif tenaga kerja karena mencakup dokter, perawat, teknisi, dan tunjangan seperti BPJS, dengan variasi tergantung profil layanan.</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Jasa Profesional / Konsultasi / IT &amp; Software:</strong> 20% &ndash; 50%. Pada perusahaan jasa profesional atau IT, tenaga ahli adalah aset utama sehingga kompensasi tinggi dan rasio cenderung lebih besar.</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Transportasi &amp; Logistik:</strong> 15% &ndash; 30%. Dipengaruhi oleh biaya sopir, perawatan kendaraan, dan efisiensi rute; operator besar biasanya memiliki rasio lebih rendah karena skala ekonomi.</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Pertanian / Perkebunan:</strong> 10% &ndash; 30%. Sangat bergantung pada musim dan intensitas tenaga kerja, misalnya padat karya atau sudah bermekanisasi.</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Pendidikan (sekolah, lembaga kursus):</strong> 30% &ndash; 60%. Guru, dosen, dan staf administrasi membentuk proporsi biaya besar, terutama pada institusi swasta atau berkualitas tinggi.</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Keuangan &amp; Perbankan:</strong> 15% &ndash; 35%. Struktur biaya tenaga kerja relatif stabil, namun bank atau fintech berbasis teknologi tinggi cenderung memiliki rasio lebih rendah terhadap pendapatan.</p>\r\n	</li>\r\n</ul>', '2025-10-24 08:30:46.922609', '2025-12-05 08:24:06.490342', 3, 7, 4, 1, NULL, 1, 1),
(15, 'linkedin_newsletter', 'awareness', 'free', '2025-11-04 12:45:00.000000', NULL, 'newsletter', '2. Rekrutmen dan Seleksi (Lean Talent Acquisition)', '<p><a href=\"https://www.linkedin.com/pulse/rekrutmen-dan-seleksi-lean-talent-acquisition-eva-setyabudi-3aufc/\">https://www.linkedin.com/pulse/rekrutmen-dan-seleksi-lean-talent-acquisition-eva-setyabudi-3aufc/</a>Berikut versi revisi lengkap tanpa <strong>penomoran (numbering)</strong> &mdash; semua bagian menggunakan <strong>bullet point (ikon emoji)</strong> agar tampil lebih bersih dan modern, tanpa mengubah isi maupun tone keseluruhan:</p>\r\n\r\n<p>? Seri Lean HR #2: Rekrutmen dan Seleksi (Lean Talent Acquisition)</p>\r\n\r\n<p>Pernah merasa proses rekrutmen memakan waktu lama, hasil akhirnya tidak sesuai ekspektasi, atau kandidat yang sudah direkrut ternyata tidak cocok setelah beberapa bulan bekerja? Atau justru sebaliknya &mdash; terlalu cepat merekrut tanpa evaluasi yang jelas, akhirnya tim tidak sinkron dan turnover meningkat? Masalah-masalah ini sering terjadi karena proses rekrutmen berjalan tanpa arah yang jelas dan terlalu birokratis.</p>\r\n\r\n<p>Pendekatan <strong>Lean Talent Acquisition</strong> hadir untuk menjawab tantangan tersebut: rekrutmen yang ramping, cepat, dan berbasis data. Prinsip utamanya sederhana &mdash; <em>just-in-time hiring</em> dan <em>validated selection tools</em>. Artinya, perusahaan hanya merekrut saat benar-benar dibutuhkan, dengan alat seleksi yang terukur dan relevan dengan performa kerja nyata, sehingga setiap keputusan rekrutmen memberi dampak langsung bagi pertumbuhan bisnis.</p>\r\n\r\n<p>? Link untuk Kandidat</p>\r\n\r\n<p>Gunakan portal kandidat berbasis <strong>self-service form</strong>, agar pelamar bisa mengisi data, mengunggah dokumen, dan menjalani tes awal secara mandiri.<br />\r\n? <em>Hasilnya: proses lebih cepat, transparan, dan mengurangi beban administratif HR.</em></p>\r\n\r\n<p>? Matrix Interview</p>\r\n\r\n<p>Tinggalkan wawancara yang hanya mengandalkan &ldquo;feeling.&rdquo;<br />\r\nGunakan <strong>template evaluasi berbasis kompetensi inti dan cultural fit index</strong>, agar hasil wawancara lebih objektif dan mudah dibandingkan antar kandidat.<br />\r\n? <em>Hasilnya: keputusan lebih konsisten, dan HR dapat memberi rekomendasi berbasis bukti, bukan preferensi personal.</em></p>\r\n\r\n<p>? Psychometric Assessment</p>\r\n\r\n<p>Manfaatkan <strong>tes psikometrik</strong> untuk mendapatkan pemahaman yang lebih dalam tentang kepribadian, gaya kerja, dan potensi kolaborasi kandidat.<br />\r\nTes psikometrik mencakup dimensi seperti <em>stabilitas emosi, keterbukaan, gaya komunikasi, serta cara kandidat beradaptasi dalam tim.</em></p>\r\n\r\n<p>? <em>Hasilnya: perusahaan dapat menilai kesesuaian kandidat secara menyeluruh &mdash; tidak hanya dari kemampuan teknis, tetapi juga dari kecocokan perilaku dan nilai kerja.</em></p>\r\n\r\n<p>?? Hasil Interview</p>\r\n\r\n<p>Rangkum hasil wawancara dalam format <strong>decision support</strong>, bukan opini personal.<br />\r\nDengan struktur ini, hasil evaluasi dapat dibaca lintas tim dan digunakan untuk membandingkan kandidat secara objektif.<br />\r\n? <em>Hasilnya: keputusan rekrutmen lebih jelas, terdokumentasi, dan dapat dipertanggungjawabkan.</em></p>\r\n\r\n<p>? <strong>Tujuan Lean:</strong> setiap data kandidat memberi insight langsung untuk pengambilan keputusan &mdash; bukan sekadar formalitas rekrutmen.</p>\r\n\r\n<p>PilarFokus UtamaManfaat Lean<strong>Link untuk Kandidat</strong>Portal kandidat berbasis self-service formProses cepat, transparan, dan mengurangi clerical work HR<strong>Matrix Interview</strong>Template evaluasi berbasis kompetensi dan cultural fitEvaluasi objektif; menggantikan opini personal<strong>Psychometric Assessment</strong>Memahami kepribadian, gaya kerja, dan dinamika timMeningkatkan job fit &amp; team harmony<strong>Hasil Interview</strong>Dirangkum dalam format decision supportKeputusan hire/no-hire berbasis data</p>\r\n\r\n<p>? Kenapa Pendekatan Ini Penting</p>\r\n\r\n<p>Banyak perusahaan gagal bukan karena kekurangan kandidat, tetapi karena proses rekrutmen yang tidak efisien dan bias. Pendekatan <strong>Lean Talent Acquisition</strong> memastikan setiap tahap rekrutmen memberi nilai tambah &mdash; cepat, objektif, dan terukur. Rekrutmen bukan sekadar mengisi posisi kosong, tetapi strategi bisnis untuk tumbuh dengan orang yang tepat. Dengan prinsip <strong>Lean HR</strong>, setiap talenta yang direkrut menjadi investasi nyata bagi pertumbuhan perusahaan, karena prosesnya mampu <strong>mengurangi time-to-hire</strong> melalui sistem dan tes terstandar, <strong>meningkatkan akurasi rekrutmen</strong> lewat asesmen terukur, serta memastikan keputusan pimpinan berbasis <strong>data, bukan opini</strong>, melalui metrik seperti <em>Job Fit Score</em> dan <em>Cultural Fit Index</em>.</p>\r\n\r\n<p>? <strong>Nantikan Seri Berikutnya:</strong><br />\r\n<strong>Seri Lean HR #3: Performance Management &mdash; Dari Penilaian ke Pengembangan.</strong></p>\r\n\r\n<p>#LeanHR #TalentAcquisition #RecruitmentStrategy #HRInnovation #StartupIndonesia #UMKMNaikKelas #PeopleAnalytics</p>', '2025-10-24 08:30:51.254226', '2025-12-05 08:45:41.635316', 5, 6, 1, 1, NULL, 1, 1),
(16, 'linkedin_newsletter', 'awareness', 'free', '2025-11-13 14:00:00.000000', NULL, 'newsletter', '3. Onboarding (Lean Integration)', '<p>Bagus banget &mdash; menambahkan <strong>Job Description</strong> (JD) di bagian onboarding itu langkah strategis karena banyak perusahaan gagal menyambungkan JD dengan realitas kerja. Berikut versi <strong>newsletter lengkap revisi</strong> dengan tambahan konteks <em>Job Description Alignment</em>, tetap mengikuti tone dan format seri Lean HR sebelumnya ?</p>\r\n\r\n<p>? <strong>Seri Lean HR #3: Onboarding (Lean Integration)</strong></p>\r\n\r\n<p>Pernahkah karyawan baru di timmu butuh waktu lama untuk &ldquo;nyetel&rdquo; dan benar-benar produktif?<br />\r\nAtau malah kebingungan di minggu pertama karena informasi yang diberikan terlalu banyak tapi tidak terstruktur?</p>\r\n\r\n<p>Masalah ini sering terjadi karena proses <strong>onboarding</strong> dianggap sekadar orientasi &mdash; bukan strategi integrasi.<br />\r\nPadahal, onboarding yang efektif bukan hanya soal memperkenalkan budaya dan SOP, tapi membangun <em>adaptation sprint</em> &mdash; proses cepat agar karyawan baru bisa memberikan kontribusi nyata dalam waktu singkat.</p>\r\n\r\n<p>Pendekatan <strong>Lean Integration</strong> hadir untuk membuat proses adaptasi lebih cepat, terarah, dan berbasis <em>continuous learning</em>.<br />\r\nTujuannya bukan sekadar &ldquo;mengenalkan perusahaan&rdquo;, tetapi mengantarkan karyawan baru menjadi bagian dari aliran nilai (<em>value stream</em>) sejak hari pertama.</p>\r\n\r\n<p>? SOP yang Ringkas dan Visual</p>\r\n\r\n<p>Alih-alih dokumen panjang yang jarang dibaca, gunakan <strong>SOP ringkas berbasis checklist learning</strong> &mdash; panduan langkah demi langkah dengan visual atau video pendek.<br />\r\n? <strong>Hasilnya:</strong> onboarding menjadi mudah diikuti, seragam antar divisi, dan mengurangi kesalahan berulang di minggu-minggu awal.</p>\r\n\r\n<p>? Job Description Alignment</p>\r\n\r\n<p>Pastikan karyawan baru memahami <strong>Job Description (JD)</strong> bukan hanya sebagai daftar tugas, tetapi sebagai <em>commitment map</em> antara peran, target, dan kontribusi.<br />\r\nJD sebaiknya dijelaskan dengan konteks: siapa pelanggan internalnya, metrik keberhasilannya, dan bagaimana pekerjaan mereka terhubung dengan value stream organisasi.</p>\r\n\r\n<p>? <strong>Hasilnya:</strong> karyawan tidak hanya tahu &ldquo;apa yang harus dilakukan&rdquo;, tapi juga &ldquo;mengapa&rdquo; &mdash; sehingga motivasi, akuntabilitas, dan arah kerja menjadi lebih jelas sejak awal.</p>\r\n\r\n<p>?? Struktur Organisasi sebagai Value Stream Map</p>\r\n\r\n<p>Tinggalkan struktur organisasi yang kaku dan hierarkis.<br />\r\nPerkenalkan tim melalui <strong>value stream map</strong> &mdash; peta aliran nilai yang memperlihatkan siapa berperan di bagian mana dalam menghasilkan output untuk pelanggan.<br />\r\n? <strong>Hasilnya:</strong> karyawan baru memahami bagaimana pekerjaannya berkontribusi langsung terhadap hasil tim dan tujuan perusahaan, bukan hanya tahu &ldquo;siapa atasannya&rdquo;.</p>\r\n\r\n<p>? Kenapa Pendekatan Ini Penting</p>\r\n\r\n<p>Banyak organisasi kehilangan momentum di 30 hari pertama karena onboarding yang tidak efektif.<br />\r\nDengan <strong>Lean Integration</strong>, proses adaptasi menjadi cepat, bermakna, dan menghemat biaya pelatihan ulang.<br />\r\nKaryawan baru belajar dari aktivitas nyata, bukan dari dokumen statis &mdash; sehingga mereka bisa <em>perform faster, learn smarter, and stay longer</em>.</p>\r\n\r\n<p>? Dampak Nyata Lean Onboarding</p>\r\n\r\n<ul>\r\n	<li>\r\n	<p>Waktu adaptasi karyawan baru berkurang hingga 50%.</p>\r\n	</li>\r\n	<li>\r\n	<p>Penguasaan SOP lebih cepat dengan media visual dan microlearning.</p>\r\n	</li>\r\n	<li>\r\n	<p>Job description dipahami sebagai kompas kinerja, bukan sekadar daftar tugas.</p>\r\n	</li>\r\n	<li>\r\n	<p>Keterlibatan meningkat karena karyawan tahu kontribusinya sejak awal.</p>\r\n	</li>\r\n	<li>\r\n	<p>HR dapat memantau progres onboarding dengan data, bukan asumsi.</p>\r\n	</li>\r\n</ul>\r\n\r\n<p>? <strong>Nantikan Seri Berikutnya:</strong><br />\r\n<strong>Seri Lean HR #4: Performance Management &mdash; Dari Penilaian ke Pengembangan.</strong></p>\r\n\r\n<p>#LeanHR #Onboarding #HRInnovation #PeopleDevelopment #StartupIndonesia #UMKMNaikKelas #EmployeeExperience #ContinuousLearning #TalentManagement</p>\r\n\r\n<p>Apakah kamu ingin saya bantu buatkan <strong>versi short LinkedIn caption</strong> (4&ndash;5 kalimat pembuka + CTA) untuk promosi newsletter ini di feed?<br />\r\nBiasanya itu bikin engagement artikel naik 2&ndash;3x lebih tinggi.</p>', '2025-10-24 08:30:59.899937', '2025-12-05 08:44:12.818249', 5, 6, 1, 1, NULL, 1, 1),
(17, 'linkedin_newsletter', 'awareness', 'free', '2025-11-21 14:00:00.000000', '2025-11-21', 'newsletter', '4. Manajemen Kinerja (Lean Performance System)', '<p>Berikut adalah contoh <strong>use case</strong> yang dapat dimasukkan dalam <strong>Seri Lean HR #4: Performance Management &mdash; Dari Penilaian ke Pengembangan</strong>:</p>\r\n\r\n<p><strong>Seri Lean HR #4: Performance Management &mdash; Dari Penilaian ke Pengembangan</strong></p>\r\n\r\n<p>Pernahkah Anda merasa proses penilaian kinerja di perusahaan hanya menjadi rutinitas tahunan yang tidak memberikan dampak nyata? Atau mungkin sistem KPI yang ada terasa terlalu kaku dan tidak mencerminkan perkembangan karyawan yang sesungguhnya? Banyak organisasi terjebak dalam siklus penilaian kinerja yang statis dan kurang fokus pada pengembangan berkelanjutan.</p>\r\n\r\n<p>Dengan pendekatan Lean Performance Management, kita berfokus pada pengelolaan kinerja yang dinamis, berbasis data, dan berorientasi pada pengembangan berkelanjutan. Alih-alih hanya menilai karyawan, kita menciptakan sistem yang membantu mereka berkembang dan berkontribusi lebih maksimal terhadap tujuan organisasi.</p>\r\n\r\n<p>? <strong>Menghubungkan Kinerja dengan Tujuan Organisasi</strong></p>\r\n\r\n<ol>\r\n	<li>\r\n	<p><strong>Visi Organisasi</strong><br />\r\n	Menjadi pemimpin pasar dalam teknologi ramah lingkungan.</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Misi Organisasi</strong><br />\r\n	Mengembangkan teknologi hemat energi untuk pasar Asia Tenggara.</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Dimensi OKR (Aspek Kinerja)</strong><br />\r\n	Fokus pada hasil dan pencapaian yang akan mendukung visi dan misi organisasi:</p>\r\n\r\n	<ul>\r\n		<li>\r\n		<p>Inovasi Produk</p>\r\n		</li>\r\n		<li>\r\n		<p>Pengalaman Pelanggan</p>\r\n		</li>\r\n		<li>\r\n		<p>Efisiensi Operasional</p>\r\n		</li>\r\n		<li>\r\n		<p>Pertumbuhan Pasar</p>\r\n		</li>\r\n	</ul>\r\n	</li>\r\n	<li>\r\n	<p><strong>Objective (Tujuan)</strong><br />\r\n	Menjadi pemimpin pasar dalam solusi teknologi hemat energi.</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Key Results (Hasil Kunci)</strong></p>\r\n\r\n	<ul>\r\n		<li>\r\n		<p>Meningkatkan penjualan 30%</p>\r\n		</li>\r\n		<li>\r\n		<p>Menurunkan biaya produksi 15%</p>\r\n		</li>\r\n		<li>\r\n		<p>Meningkatkan kepuasan pelanggan 20% (Rating 4.5 bintang)</p>\r\n		</li>\r\n	</ul>\r\n	</li>\r\n	<li>\r\n	<p><strong>KPI (Indikator Kinerja)</strong><br />\r\n	Indikator yang spesifik dan terukur untuk memastikan bahwa tujuan yang lebih besar tercapai:</p>\r\n\r\n	<ul>\r\n		<li>\r\n		<p>Total Penjualan Produk</p>\r\n		</li>\r\n		<li>\r\n		<p>Biaya Produksi per Unit</p>\r\n		</li>\r\n		<li>\r\n		<p>Rating Kepuasan Pelanggan</p>\r\n		</li>\r\n	</ul>\r\n	</li>\r\n</ol>\r\n\r\n<p>? <strong>Dari Penilaian ke Pengembangan</strong></p>\r\n\r\n<p>Pendekatan Lean Performance Management bukan hanya tentang mengevaluasi kinerja, tetapi juga mengembangkan potensi setiap individu. Hal ini dilakukan melalui:</p>\r\n\r\n<ul>\r\n	<li>\r\n	<p><strong>Penilaian Berkelanjutan dan Tindak Lanjut:</strong><br />\r\n	Kinerja tidak dievaluasi hanya sekali setahun. Proses penilaian dilakukan secara berkelanjutan, dengan umpan balik langsung dan diskusi terbuka antara manajer dan karyawan. Hal ini memastikan bahwa setiap individu memahami ekspektasi dan area yang perlu diperbaiki sebelum penilaian tahunan.</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Pengembangan Berbasis Data:</strong><br />\r\n	Menggunakan data dari KPI dan OKR untuk menentukan area pengembangan karyawan. Pendekatan ini mengarah pada pengembangan kompetensi yang tidak hanya berhubungan dengan pekerjaan saat ini, tetapi juga mendukung tujuan jangka panjang organisasi.</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Fokus pada Pembelajaran dan Pertumbuhan:</strong><br />\r\n	Alih-alih hanya memberikan penilaian, fokuskan sistem kinerja pada pembelajaran dan pengembangan berkelanjutan. Dengan memberikan kesempatan untuk mengikuti pelatihan atau mentransformasikan tantangan pekerjaan menjadi peluang pembelajaran, karyawan akan merasa lebih terlibat dan termotivasi.</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Pelatihan Sebagai Solusi:</strong><br />\r\n	Jika seorang karyawan tidak mencapai target kinerja, langkah pertama bukan langsung pemutusan hubungan kerja (PHK). Sebaliknya, mereka diberikan kesempatan untuk mengikuti program pelatihan dan pengembangan yang disesuaikan dengan kebutuhan mereka. Ini memberikan karyawan kesempatan untuk belajar dan meningkatkan keterampilan mereka, sehingga mereka dapat berkontribusi lebih baik di masa depan. Pendekatan ini mengurangi biaya rekrutmen dan mengembangkan loyalitas karyawan.</p>\r\n	</li>\r\n</ul>\r\n\r\n<p>? <strong>Use Case: Karyawan yang Tidak Mencapai Target &mdash; Pendekatan Pelatihan</strong></p>\r\n\r\n<p><strong>Situasi:</strong><br />\r\nDi sebuah perusahaan teknologi hemat energi, seorang karyawan di bagian penjualan (sebut saja Andi) telah bekerja selama 6 bulan. Andi ditugaskan untuk mencapai target penjualan tahunan sebesar Rp 5 miliar. Namun, setelah evaluasi kuartalan, hasil penjualannya baru mencapai 50% dari target yang ditetapkan.</p>\r\n\r\n<p><strong>Langkah-Langkah:</strong></p>\r\n\r\n<ol>\r\n	<li>\r\n	<p><strong>Evaluasi Kinerja dan Umpan Balik:</strong><br />\r\n	Manajer memberikan umpan balik konstruktif kepada Andi. Ditemukan bahwa meskipun Andi memiliki keterampilan teknis yang sangat baik tentang produk, ia kurang berpengalaman dalam melakukan presentasi penjualan kepada klien potensial. Hal ini menghambat kemampuan Andi untuk menutup penjualan yang lebih besar.</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Identifikasi Area Pengembangan:</strong><br />\r\n	Berdasarkan evaluasi, manajer dan Andi menyepakati area pengembangan yang spesifik: peningkatan keterampilan presentasi penjualan dan teknik negosiasi. Kinerja Andi diukur dengan KPI terkait penjualan dan feedback dari klien, serta waktu yang dihabiskan untuk pelatihan.</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Pelatihan Khusus:</strong><br />\r\n	Andi diarahkan untuk mengikuti pelatihan presentasi penjualan dan workshop teknik negosiasi. Pelatihan ini diadakan oleh perusahaan atau melalui vendor eksternal yang memiliki keahlian di bidang tersebut. Tujuannya adalah agar Andi memiliki keterampilan praktis yang dapat langsung diterapkan dalam pekerjaan sehari-hari.</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Penerapan dan Tindak Lanjut:</strong><br />\r\n	Setelah pelatihan, Andi diberikan kesempatan untuk mempraktikkan keterampilan barunya dalam presentasi dengan klien-klien yang sudah ada. Selama tiga bulan berikutnya, hasil penjualannya dipantau lebih intensif.</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Hasil:</strong><br />\r\n	Setelah mengikuti pelatihan, Andi menunjukkan peningkatan signifikan dalam keterampilan presentasi dan negosiasi. Ia berhasil menutup beberapa kesepakatan besar, yang meningkatkan penjualannya hampir 25% dibandingkan dengan kuartal sebelumnya. Andi kini lebih percaya diri dalam mempresentasikan produk, dan tidak hanya mencapai target yang ditetapkan tetapi juga menunjukkan komitmen untuk berkembang.</p>\r\n	</li>\r\n</ol>\r\n\r\n<p>? <strong>Kenapa Pendekatan Ini Penting</strong></p>\r\n\r\n<p>Banyak perusahaan mengalami stagnasi karena kinerja karyawan hanya diukur melalui hasil penilaian yang sempit, tanpa memedulikan proses dan perkembangan berkelanjutan. Lean Performance Management membantu menciptakan ekosistem di mana setiap karyawan merasa dihargai dan didorong untuk tumbuh bersama perusahaan, bukan hanya memenuhi target semata.</p>\r\n\r\n<p>Dengan mengintegrasikan OKR dan KPI dalam sistem manajemen kinerja, kita bisa lebih jelas melihat kontribusi setiap individu terhadap tujuan organisasi yang lebih besar. Pendekatan ini juga memungkinkan organisasi untuk lebih fleksibel dalam menyesuaikan tujuan kinerja sesuai dengan dinamika pasar dan perubahan internal yang terjadi.</p>\r\n\r\n<p>? <strong>Nantikan Seri Berikutnya: Seri Lean HR #5: Lean Employee Engagement &mdash; Meningkatkan Keterlibatan Karyawan dengan Proses yang Efisien.</strong></p>\r\n\r\n<p>#LeanHR #PerformanceManagement #OKR #EmployeeDevelopment #StartupIndonesia #UMKMNaikKelas #HRInnovation #ContinuousImprovement #KPI #EmployeeEngagement</p>\r\n\r\n<p>Dengan <strong>use case</strong> ini, Anda menunjukkan bagaimana pendekatan Lean Performance Management memberikan kesempatan bagi karyawan untuk berkembang daripada langsung dihentikan. Ini menekankan pentingnya pengembangan berkelanjutan, bukan hanya evaluasi hasil, untuk memastikan karyawan terus memberikan kontribusi maksimal.</p>', '2025-10-24 09:50:19.282250', '2025-12-05 08:22:17.972479', 5, 6, 1, 1, NULL, 1, 1),
(18, 'linkedin_newsletter', 'awareness', 'free', '2025-12-05 14:00:00.000000', NULL, 'newsletter', '5. Pengembangan Karyawan (Capability Growth Loop)', '<p><strong>Lean HR #5 &mdash; Pengembangan Karyawan (Capability Growth Loop)</strong></p>\r\n\r\n<p>Dalam banyak organisasi, performa karyawan masih diperlakukan sebagai hasil akhir&mdash;yang bagus dipuji, yang rendah ditegur, bahkan dianggap sebagai masalah individu. Pola ini memicu budaya saling menyalahkan dan membuat karyawan takut gagal. Padahal dalam pendekatan Lean HR, performa bukanlah label baik-buruk, melainkan <strong>cermin kapabilitas yang perlu terus dikembangkan</strong>. Jika seseorang tidak mencapai target, itu bukan semata soal &ldquo;kinerja buruk&rdquo;, tetapi sinyal bahwa ada keterampilan, pengetahuan, atau perilaku yang harus diperkuat. Bila organisasi hanya fokus menegur tanpa memperkuat kemampuan, performa tidak akan pernah benar-benar meningkat.</p>\r\n\r\n<p>Ketika seorang karyawan menunjukkan hasil yang tidak optimal, itu bukan sekadar &ldquo;masalah performa&rdquo;&mdash;sering kali itu adalah <strong>sinyal pembelajaran</strong>: ada keterampilan, pengetahuan, atau perilaku yang perlu diperkuat. Karena itulah, pengembangan karyawan bukan aktivitas tambahan, melainkan <strong>komponen inti peningkatan kinerja organisasi</strong>.</p>\r\n\r\n<p>Inilah yang disebut <strong>Capability Growth Loop </strong>siklus pengembangan berkelanjutan yang menghubungkan pekerjaan nyata, pembelajaran nyata, dan dampak nyata.</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p><strong>Kompetensi Harus Dinyatakan dalam Perilaku Terukur</strong></p>\r\n\r\n<p>Agar pengembangan karyawan efektif, kompetensi tidak boleh berhenti pada istilah umum seperti <em>leadership</em>, <em>teamwork</em>, atau <em>problem solving</em>.<br />\r\nKompetensi harus diturunkan menjadi <strong>perilaku konkret</strong>, misalnya:</p>\r\n\r\n<ul>\r\n	<li>Mampu menganalisis akar masalah dalam 15 menit menggunakan 5-Why</li>\r\n	<li>Mampu menyelesaikan administrasi harian tanpa rework</li>\r\n</ul>\r\n\r\n<p>Perilaku terukur membantu organisasi melihat <strong>apa yang perlu dikembangkan</strong>, bukan menilai orang secara subjektif.</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p><strong>2. Kebutuhan Pelatihan Harus Berbasis Data Performa</strong></p>\r\n\r\n<p>Dalam Lean HR, indikasi bahwa karyawan perlu dikembangkan datang dari dua sumber utama:</p>\r\n\r\n<p><strong>a. Evaluasi Kinerja <a href=\"https://www.linkedin.com/posts/eva-setyabudi-72976578_activity-7397529201395834880-hnX0?utm_source=share&amp;utm_medium=member_desktop&amp;rcm=ACoAABB8X9EB_v8ZPzE7uIfTPAMawiECDBWPOsc\" style=\"color:#0563c1; text-decoration:underline\">https://www.linkedin.com/posts/eva-setyabudi-72976578_activity-7397529201395834880-hnX0?utm_source=share&amp;utm_medium=member_desktop&amp;rcm=ACoAABB8X9EB_v8ZPzE7uIfTPAMawiECDBWPOsc</a> </strong></p>\r\n\r\n<p>Ketika performa rendah atau target tidak tercapai, pertanyaannya adalah:<br />\r\n&nbsp;<strong>&ldquo;Keterampilan atau perilaku apa yang perlu diperkuat?&rdquo;</strong></p>\r\n\r\n<p>Ini menggeser fokus dari menyalahkan individu menjadi membangun fondasi kompetensi yang lebih kuat.</p>\r\n\r\n<p><strong>b. Feedback Harian &amp; Coaching Berkelanjutan</strong></p>\r\n\r\n<p>Setiap kendala operasional adalah peluang pembelajaran.</p>\r\n\r\n<p>Contoh:</p>\r\n\r\n<ul>\r\n	<li>Pekerjaan berulang tinggi &rarr; perlu penguatan ketelitian proses</li>\r\n	<li>Arahan kerja sering tidak jelas &rarr; perlu pelatihan komunikasi instruksional</li>\r\n	<li>Proses lambat &rarr; perlu pelatihan efisiensi praktik kerja</li>\r\n</ul>\r\n\r\n<p>Dalam Lean HR, pengembangan karyawan harus selalu terhubung dengan sasaran organisasi. Artinya, tidak ada lagi &ldquo;training list&rdquo; tanpa arah. Setiap pelatihan harus membentuk aliran nilai yang jelas: <em>pekerjaan &rarr; pembelajaran &rarr; perubahan perilaku &rarr; performa meningkat</em>. Contohnya, target waktu operasional turun 10% memerlukan pelatihan efisiensi; turnover tinggi menuntut penguatan coaching atasan; penjualan stagnan membutuhkan pelatihan pemahaman pelanggan dan feedback loop.</p>\r\n\r\n<p>Agar benar-benar berdampak, setiap proses pembelajaran harus <strong>cepat diterapkan</strong> dalam pekerjaan, <strong>terukur</strong> melalui perubahan perilaku dan hasil, <strong>dan terhubung</strong> langsung dengan peningkatan performa tim dan organisasi. Dengan prinsip ini, pelatihan menjadi alat strategis pencipta nilai, bukan sekadar formalitas. &nbsp;pengembangan karyawan adalah <strong>sistem pembelajaran berkelanjutan yang mendorong performa terus meningkat</strong>.</p>', '2025-10-24 09:51:04.990375', '2025-12-05 08:21:37.153668', 5, 6, 1, 1, NULL, 1, 1),
(19, 'linkedin_newsletter', 'awareness', 'free', '2026-01-16 14:00:00.000000', NULL, 'newsletter', '6. Kompensasi (Fair & Transparent Rewards System)', '<ul>\r\n	<li><strong>Daftar Payroll, Komponen Gaji, Periode, Slip Gaji:</strong><br />\r\n	Dikelola digital dengan prinsip transparansi &amp; efisiensi waktu.</li>\r\n	<li>Gunakan <em>pay-for-skill model</em>: kompensasi tumbuh seiring kontribusi nyata dan pembelajaran.</li>\r\n</ul>', '2025-10-24 09:53:07.003054', '2026-02-20 03:27:51.696420', 5, 6, 1, 1, NULL, 1, 1),
(20, 'linkedin_newsletter', 'awareness', 'free', NULL, NULL, 'newsletter', '8. Hubungan Industrial (Lean People Relation)', '<p>Alih-alih reaktif terhadap masalah, buat sistem <em>early signal</em> untuk mendeteksi isu tim lebih cepat.</p>\r\n\r\n<ul>\r\n	<li><strong>8.A Daftar Keluhan Karyawan:</strong> Dashboard keluhan digital dengan SLA penanganan.</li>\r\n	<li><strong>8.B Ajukan Keluhan Baru:</strong> Form online dengan kategorisasi (lingkungan, kompensasi, atasan, dll).<br />\r\n	Tujuan: menciptakan budaya <em>trust &amp; open feedback</em>.</li>\r\n</ul>', '2025-10-24 09:54:02.245983', '2025-12-05 08:12:50.358531', 5, 6, 1, 0, NULL, 1, 1),
(21, 'linkedin_newsletter', 'awareness', 'free', NULL, NULL, 'newsletter', '9. Continuous Improvement (Lean Culture Evolution)', '<p>Perusahaan perlu <em>learning loop</em> berbasis data dan refleksi tim.</p>\r\n\r\n<ul>\r\n	<li><strong>9.A Link Test OCAI (Organizational Culture Assessment Instrument):</strong> Mengukur kesesuaian budaya saat ini dengan arah bisnis.</li>\r\n	<li><strong>9.B Hasil Test OCAI:</strong> Jadi dasar perbaikan struktur, sistem, dan perilaku organisasi.</li>\r\n</ul>\r\n\r\n<p>? Hasilnya: budaya organisasi yang <em>adaptif, berkelanjutan, dan bernilai tambah tinggi</em>.</p>', '2025-10-24 09:54:52.825933', '2025-12-05 08:14:59.859633', 5, 6, 1, 0, NULL, 1, 1),
(23, 'linkedin_company', 'awareness', 'free', '2025-05-05 14:00:00.000000', NULL, 'post', 'Mengapa Banyak UMKM & Startup Gagal Memaksimalkan Potensi Talenta Mereka?', '<p><a href=\"https://www.linkedin.com/pulse/mengapa-banyak-umkm-startup-gagal-memaksimalkan-potensi-talenta-tvi0c/?trackingId=Xx1COqtfws0THuIMTxprrQ%3D%3D\">https://www.linkedin.com/pulse/mengapa-banyak-umkm-startup-gagal-memaksimalkan-potensi-talenta-tvi0c/?trackingId=Xx1COqtfws0THuIMTxprrQ%3D%3D</a></p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>artivle views 22</p>', '2025-10-24 10:09:11.477879', '2025-12-05 08:31:30.076737', 3, 4, 1, 1, NULL, 1, 1),
(25, 'linkedin_company', 'awareness', 'free', '2025-06-12 14:00:00.000000', NULL, 'carousel', '*Jangan sampai salah pilih calon karyawan!*', '<p>&nbsp;<a href=\"https://www.linkedin.com/feed/update/urn:li:activity:7338929152483389441\">https://www.linkedin.com/feed/update/urn:li:activity:7338929152483389441</a></p>', '2025-10-24 15:36:17.369870', '2025-12-05 08:30:17.645194', 3, 4, 4, 1, NULL, 1, 1),
(26, 'linkedin_newsletter', 'awareness', 'free', '2025-02-19 14:00:00.000000', NULL, 'newsletter', 'HC Strategic Planning untuk UMKM dan Startup', '<p><a href=\"https://www.linkedin.com/pulse/hc-strategic-planning-untuk-umkm-dan-startup-eva-setyabudi-ci6ne/?trackingId=%2FW03LmXLRVmeH7HgX4de6Q%3D%3D\">https://www.linkedin.com/pulse/hc-strategic-planning-untuk-umkm-dan-startup-eva-setyabudi-ci6ne/?trackingId=%2FW03LmXLRVmeH7HgX4de6Q%3D%3D</a></p>', '2025-10-24 16:41:55.535180', '2025-12-05 08:51:32.324074', 5, 6, 1, 1, NULL, 1, 1),
(27, 'linkedin_newsletter', 'awareness', 'free', '2025-04-28 14:00:00.000000', '2025-04-24', 'newsletter', 'Hambatan Tersembunyi Pertumbuhan UMKM & Startup', '<p><a href=\"https://www.linkedin.com/pulse/sdm-hambatan-tersembunyi-pertumbuhan-umkm-startup-eva-setyabudi-ixcvc/\">https://www.linkedin.com/pulse/sdm-hambatan-tersembunyi-pertumbuhan-umkm-startup-eva-setyabudi-ixcvc/</a></p>', '2025-10-24 17:32:23.604327', '2025-12-05 08:50:31.652833', 5, 6, 1, 1, NULL, 1, 1),
(28, 'linkedin_newsletter', 'awareness', 'free', '2025-02-28 15:00:00.000000', NULL, 'newsletter', 'Manfaat DOPE Analysis dalam Organisasi UMKM dan Startup', '<p><a href=\"https://www.linkedin.com/pulse/manfaat-dope-analysis-dalam-organisasi-umkm-dan-eva-setyabudi-y6qne/\">https://www.linkedin.com/pulse/manfaat-dope-analysis-dalam-organisasi-umkm-dan-eva-setyabudi-y6qne/</a></p>', '2025-10-24 18:58:26.027742', '2025-12-05 08:51:10.850306', 5, 6, 1, 1, NULL, 1, 1),
(29, 'ig', 'awareness', 'free', '2025-03-03 15:00:00.000000', NULL, 'post', 'komunikasi', '<p><a href=\"https://www.instagram.com/p/DGu3uKfz0Ih/?utm_source=ig_web_copy_link&amp;igsh=MzRlODBiNWFlZA==\">https://www.instagram.com/p/DGu3uKfz0Ih/?utm_source=ig_web_copy_link&amp;igsh=MzRlODBiNWFlZA==</a></p>', '2025-10-25 08:33:17.099348', '2025-12-05 08:32:10.404702', 3, 1, 4, 1, NULL, 1, 1),
(30, 'ig', 'awareness', 'free', '2025-06-18 15:00:00.000000', NULL, 'carousel', 'transformasi dunia kerja', '<p><a href=\"https://www.instagram.com/p/DLC1TdnTX01/?utm_source=ig_web_copy_link&amp;igsh=MzRlODBiNWFlZA==\">https://www.instagram.com/p/DLC1TdnTX01/?utm_source=ig_web_copy_link&amp;igsh=MzRlODBiNWFlZA==</a></p>', '2025-10-25 08:38:52.024988', '2025-12-05 08:28:04.926563', 3, 1, 4, 1, NULL, 1, 1),
(31, 'threads', 'awareness', 'free', '2025-02-28 14:00:00.000000', NULL, 'psot', 'UMKM sering kesulitan mengatur karyawan?', '<p><a href=\"https://www.threads.com/@eva_setyabudi/post/DGmgFc4JyRQ?xmt=AQF0Op6dAhqfryAv1uBI8uZ3HNFQZeAejSRWptIvJtI-OA\">https://www.threads.com/@eva_setyabudi/post/DGmgFc4JyRQ?xmt=AQF0Op6dAhqfryAv1uBI8uZ3HNFQZeAejSRWptIvJtI-OA</a></p>', '2025-10-25 08:45:49.108518', '2025-12-05 08:20:56.802211', 6, 3, 1, 1, NULL, 1, 1),
(32, 'ig', 'awareness', 'free', '2025-10-25 10:44:00.000000', '2025-10-25', 'carousel', 'Kesalahan UMKM dalam Merekrut Karyawan”', '<p><a href=\"https://www.instagram.com/p/DQN7AfmE6eZ/?utm_source=ig_web_copy_link&amp;igsh=MzRlODBiNWFlZA==\">https://www.instagram.com/p/DQN7AfmE6eZ/?utm_source=ig_web_copy_link&amp;igsh=MzRlODBiNWFlZA==</a></p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>? <strong>Slide 1 &mdash; Hook / Cover</strong></p>\r\n\r\n<p>?<br />\r\n<strong>&ldquo;3 Kesalahan UMKM dalam Merekrut Karyawan&rdquo;</strong><br />\r\n?? Banyak UMKM butuh tim cepat, tapi malah salah langkah sejak awal rekrutmen.<br />\r\n(Sertakan visual: ilustrasi wawancara kerja / tumpukan CV berantakan)</p>\r\n\r\n<p>? <strong>Slide 2 &mdash; Intro Singkat</strong></p>\r\n\r\n<p>Pernah merasa karyawan baru cepat bosan atau nggak cocok dengan budaya kerja?</p>\r\n\r\n<p>Bisa jadi masalahnya bukan di mereka &mdash; tapi di proses rekrutmennya.<br />\r\nYuk pelajari 3 kesalahan yang sering terjadi ?</p>\r\n\r\n<p>? <strong>Slide 3 &mdash; Kesalahan #1: Tidak Punya Kriteria yang Jelas</strong></p>\r\n\r\n<p>Banyak UMKM hanya mencari &ldquo;yang bisa kerja sekarang&rdquo;.</p>\r\n\r\n<p>? Akibatnya: karyawan nggak sesuai kebutuhan.<br />\r\n? Hasil kerja nggak maksimal.</p>\r\n\r\n<p>? <strong>Solusi:</strong> Tentukan 3 hal utama &mdash; <em>skill wajib, sikap kerja, dan kecocokan budaya tim.</em></p>\r\n\r\n<p>? <strong>Slide 4 &mdash; Kesalahan #2: Fokus pada Harga, Bukan Nilai</strong></p>\r\n\r\n<p>&ldquo;Yang penting gajinya murah.&rdquo;</p>\r\n\r\n<p>Tapi kalau akhirnya harus rekrut ulang, malah lebih mahal!</p>\r\n\r\n<p>? <strong>Solusi:</strong> Anggap rekrutmen sebagai <em>investasi jangka panjang</em>, bukan biaya sesaat.</p>\r\n\r\n<p>? <strong>Slide 5 &mdash; Kesalahan #3: Tidak Ada Proses Seleksi yang Efektif</strong></p>\r\n\r\n<p>Masih banyak UMKM yang rekrut tanpa wawancara mendalam.</p>\r\n\r\n<p>? Tidak cek attitude<br />\r\n? Tidak beri studi kasus / tes kecil</p>\r\n\r\n<p>? <strong>Solusi:</strong> Buat seleksi sederhana tapi tepat sasaran &mdash; misal tes simulasi kerja singkat.</p>\r\n\r\n<p>? <strong>Slide 6 &mdash; Ringkasan</strong></p>\r\n\r\n<p>? 3 Kesalahan Umum dalam Rekrutmen<br />\r\n1?? Tidak punya kriteria jelas<br />\r\n2?? Fokus pada harga, bukan nilai<br />\r\n3?? Seleksi asal-asalan</p>\r\n\r\n<p>? Rekrut bukan untuk &ldquo;isi kursi&rdquo;, tapi &ldquo;tambah energi tim.&rdquo;</p>', '2025-10-25 09:45:53.611935', '2025-12-05 08:25:49.832072', 3, 1, 4, 1, NULL, 1, 1),
(33, 'ig', 'interest', 'free', '2025-10-28 14:54:00.000000', '2025-10-27', 'post', 'Checklist: Proses Rekrutmen Efisien untuk Bisnis Kecil', '<p><a href=\"https://www.instagram.com/p/DQWIUqcEyhV/?utm_source=ig_web_copy_link&amp;igsh=MzRlODBiNWFlZA==\">https://www.instagram.com/p/DQWIUqcEyhV/?utm_source=ig_web_copy_link&amp;igsh=MzRlODBiNWFlZA==</a></p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>Rekrutmen bukan cuma soal mencari orang yang bisa kerja, tapi menemukan orang yang tepat di posisi yang tepat.<br />\r\nGunakan langkah sederhana ini biar proses seleksimu lebih efisien ?<br />\r\n<br />\r\n?? Kandidat mengisi data diri<br />\r\n?? Tes ringan (psikologi, kognitif, atau tes relevan)<br />\r\n?? Dari hasil tes, lanjutkan ke tahap wawancara<br />\r\n?? Catat hasil wawancara dengan form terstandar &mdash; pertimbangkan siapa yang akan diterima, ditolak, atau masih dalam pertimbangan<br />\r\n<br />\r\nDokumentasikan setiap tahap supaya keputusan lebih objektif dan mudah ditinjau ulang.<br />\r\n<br />\r\nTag temanmu yang lagi rekrut karyawan &mdash; biar prosesnya nggak bikin pusing!</p>', '2025-10-25 09:48:28.738874', '2025-12-05 08:23:17.759122', 3, 1, 4, 1, NULL, 1, 1);
INSERT INTO `post_media_channel` (`id`, `channel_old`, `funnel_stage`, `kategori_biaya`, `tanggal_posting`, `rencana_tanggal_posting`, `jenis_konten`, `judul`, `isi_konten`, `created_at`, `updated_at`, `for_market_id`, `channel_id`, `akun_id`, `is_posted`, `amount`, `funnel_stage_id`, `kategori_biaya_id`) VALUES
(34, 'ig', 'desire', 'free', NULL, '2025-10-29', 'carousel', 'Cara Praktis Terapkan Lean HR untuk UMKM', '<p>Berikut <strong>ide postingan Instagram</strong> yang diambil dari <strong>seri Newsletter Lean HR</strong> Anda. Formatnya lebih visual, singkat, dan cocok untuk carousel IG.</p>\r\n\r\n<p>? <strong>IG Carousel Ideas dari Newsletter Lean HR</strong></p>\r\n\r\n<p><strong>1. Workforce Planning (Perencanaan Tenaga Kerja)</strong></p>\r\n\r\n<p><strong>Tema:</strong> &ldquo;Berapa Sih Biaya Ideal untuk Tenaga Kerja di Bisnismu?&rdquo;<br />\r\n<strong>Slide Ide:</strong></p>\r\n\r\n<ul>\r\n	<li>\r\n	<p>S1: Judul + ilustrasi tim kerja</p>\r\n	</li>\r\n	<li>\r\n	<p>S2: Rumus sederhana Labor Cost Ratio</p>\r\n	</li>\r\n	<li>\r\n	<p>S3: Contoh bisnis UMKM &amp; angka ideal</p>\r\n	</li>\r\n	<li>\r\n	<p>S4: Kenapa banyak bisnis rugi karena salah hitung SDM</p>\r\n	</li>\r\n	<li>\r\n	<p>S5: Tips praktis merapikan beban tenaga kerja</p>\r\n	</li>\r\n	<li>\r\n	<p>CTA: &ldquo;Cek ratio bisnismu hari ini!&rdquo;</p>\r\n	</li>\r\n</ul>\r\n\r\n<p><strong>2. Rekrutmen &amp; Seleksi (Lean Talent Acquisition)</strong></p>\r\n\r\n<p><strong>Tema:</strong> &ldquo;Rekrut Cepat, Tepat, dan Hemat&mdash;Tanpa Drama!&rdquo;<br />\r\n<strong>Slide Ide:</strong></p>\r\n\r\n<ul>\r\n	<li>\r\n	<p>S1: Judul visual</p>\r\n	</li>\r\n	<li>\r\n	<p>S2: Alur rekrutmen berantakan = boros waktu &amp; biaya</p>\r\n	</li>\r\n	<li>\r\n	<p>S3: Lean hiring model (3 langkah ringkas)</p>\r\n	</li>\r\n	<li>\r\n	<p>S4: Contoh kompetensi &amp; scorecard</p>\r\n	</li>\r\n	<li>\r\n	<p>S5: Manfaat: objektif, cepat, kandidat puas</p>\r\n	</li>\r\n	<li>\r\n	<p>CTA: &ldquo;Mau template scorecard gratis?&rdquo;</p>\r\n	</li>\r\n</ul>\r\n\r\n<p><strong>3. Onboarding (Lean Integration)</strong></p>\r\n\r\n<p><strong>Tema:</strong> &ldquo;Minggu Pertama Menentukan Masa Depan!&rdquo;<br />\r\n<strong>Slide Ide:</strong></p>\r\n\r\n<ul>\r\n	<li>\r\n	<p>S1: Judul + ilustrasi welcome employee</p>\r\n	</li>\r\n	<li>\r\n	<p>S2: Mengapa 30 hari pertama krusial</p>\r\n	</li>\r\n	<li>\r\n	<p>S3: SOP visual &amp; job clarity</p>\r\n	</li>\r\n	<li>\r\n	<p>S4: Learning loop onboarding (harian&ndash;mingguan)</p>\r\n	</li>\r\n	<li>\r\n	<p>S5: Dampak: cepat produktif, cepat nyambung</p>\r\n	</li>\r\n	<li>\r\n	<p>CTA: &ldquo;Save untuk checklist onboarding!&rdquo;</p>\r\n	</li>\r\n</ul>\r\n\r\n<p><strong>4. Performance Management (Lean Performance System)</strong></p>\r\n\r\n<p><strong>Tema:</strong> &ldquo;Dari Penilaian &rarr; Pengembangan&rdquo;<br />\r\n<strong>Slide Ide:</strong></p>\r\n\r\n<ul>\r\n	<li>\r\n	<p>S1: Judul</p>\r\n	</li>\r\n	<li>\r\n	<p>S2: KPI statis = lambat; OKR = tumbuh</p>\r\n	</li>\r\n	<li>\r\n	<p>S3: Model OKR sederhana (Objective &amp; KR contoh)</p>\r\n	</li>\r\n	<li>\r\n	<p>S4: Continuous feedback flow</p>\r\n	</li>\r\n	<li>\r\n	<p>S5: Kenapa sistem lama gak cocok untuk dunia cepat</p>\r\n	</li>\r\n	<li>\r\n	<p>CTA: &ldquo;DM kalau mau template OKR!&rdquo;</p>\r\n	</li>\r\n</ul>\r\n\r\n<p><strong>5. Pengembangan Karyawan (Capability Growth Loop)</strong></p>\r\n\r\n<p><strong>Tema:</strong> &ldquo;Training Tanpa Arah? STOP!&rdquo;<br />\r\n<strong>Slide Ide:</strong></p>\r\n\r\n<ul>\r\n	<li>\r\n	<p>S1: Judul</p>\r\n	</li>\r\n	<li>\r\n	<p>S2: Pain point: training sering hanya formalitas</p>\r\n	</li>\r\n	<li>\r\n	<p>S3: Growth Loop: Skill &rarr; Practice &rarr; Feedback &rarr; Improve</p>\r\n	</li>\r\n	<li>\r\n	<p>S4: Contoh 3 skill prioritas untuk UMKM &amp; startup</p>\r\n	</li>\r\n	<li>\r\n	<p>S5: Dampak: kapabilitas naik = performa naik</p>\r\n	</li>\r\n	<li>\r\n	<p>CTA: &ldquo;Share kalau relate!&rdquo;</p>\r\n	</li>\r\n</ul>\r\n\r\n<p><strong>6. Kompensasi (Fair &amp; Transparent Rewards System)</strong></p>\r\n\r\n<p><strong>Tema:</strong> &ldquo;Gaji Transparan = Tim Lebih Tenang&rdquo;<br />\r\n<strong>Slide Ide:</strong></p>\r\n\r\n<ul>\r\n	<li>\r\n	<p>S1: Judul</p>\r\n	</li>\r\n	<li>\r\n	<p>S2: Masalah kompensasi umum: &lsquo;kok gajinya beda?&rsquo;</p>\r\n	</li>\r\n	<li>\r\n	<p>S3: Prinsip sistem yang fair (3 pilar)</p>\r\n	</li>\r\n	<li>\r\n	<p>S4: Rentang gaji &amp; benchmark sederhana</p>\r\n	</li>\r\n	<li>\r\n	<p>S5: Dampak: trust naik, turnover turun</p>\r\n	</li>\r\n	<li>\r\n	<p>CTA: &ldquo;Mau template struktur gaji?&rdquo;</p>\r\n	</li>\r\n</ul>\r\n\r\n<p><strong>7. Hubungan Industrial (Lean People Relation)</strong></p>\r\n\r\n<p><strong>Tema:</strong> &ldquo;Konflik Bisa Dicegah Kalau Sistemnya Benar&rdquo;<br />\r\n<strong>Slide Ide:</strong></p>\r\n\r\n<ul>\r\n	<li>\r\n	<p>S1: Judul</p>\r\n	</li>\r\n	<li>\r\n	<p>S2: Penyebab konflik industrial yang sering terjadi</p>\r\n	</li>\r\n	<li>\r\n	<p>S3: Lean People Relation Framework (3 prinsip)</p>\r\n	</li>\r\n	<li>\r\n	<p>S4: Contoh penyelesaian cepat &amp; objektif</p>\r\n	</li>\r\n	<li>\r\n	<p>S5: Manfaat: stabil, minim gesekan, produktif</p>\r\n	</li>\r\n	<li>\r\n	<p>CTA: &ldquo;Tag HR yang butuh ini!&rdquo;</p>\r\n	</li>\r\n</ul>\r\n\r\n<p><strong>8. Continuous Improvement (Lean Culture Evolution)</strong></p>\r\n\r\n<p><strong>Tema:</strong> &ldquo;Budaya Kerja Bukan Poster &mdash; Tapi Kebiasaan&rdquo;<br />\r\n<strong>Slide Ide:</strong></p>\r\n\r\n<ul>\r\n	<li>\r\n	<p>S1: Judul</p>\r\n	</li>\r\n	<li>\r\n	<p>S2: Kenapa budaya sulit berubah</p>\r\n	</li>\r\n	<li>\r\n	<p>S3: Lean Culture Loop (small wins &rarr; learn &rarr; improve)</p>\r\n	</li>\r\n	<li>\r\n	<p>S4: Ritual mingguan peningkatan sederhana</p>\r\n	</li>\r\n	<li>\r\n	<p>S5: Dampak: perusahaan adaptif &amp; maju cepat</p>\r\n	</li>\r\n	<li>\r\n	<p>CTA: &ldquo;Save untuk ide improvement mingguan!&rdquo;</p>\r\n	</li>\r\n</ul>\r\n\r\n<p>Mau saya buatkan <strong>template caption IG</strong> juga?</p>\r\n\r\n<p>Atau mau dibuat <strong>desain carousel Canva</strong> siap pakai?</p>', '2025-10-25 09:50:20.533863', '2025-12-05 08:16:10.308473', 3, 1, 4, 0, NULL, 1, 1),
(35, 'linkedin_company', 'awareness', 'free', NULL, '2025-10-27', 'post', '1. Mengapa Banyak UMKM & Startup Gagal Memaksimalkan Potensi Talenta Mereka?', '<p>perlu perbaikan</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p><strong>? Funnel Stage:</strong> <strong>TOFU (Top of Funnel) &mdash; Awareness</strong><br />\r\n<strong>? Format:</strong> Artikel pendek / LinkedIn post dengan storytelling ringan<br />\r\n<strong>? Isi singkat:</strong></p>\r\n\r\n<p>Banyak UMKM dan startup punya tim yang potensial, tapi gagal memaksimalkannya karena:<br />\r\n&bull; Rekrutmen tanpa strategi jelas<br />\r\n&bull; HR masih dianggap fungsi administratif<br />\r\n&bull; Tidak ada sistem umpan balik yang konsisten</p>\r\n\r\n<p>Saat bisnis tumbuh, struktur tim harus ikut berevolusi. HR yang adaptif justru bisa jadi kunci efisiensi &mdash; bukan beban.</p>\r\n\r\n<p>? Solusi: mulai terapkan prinsip <strong>Lean HR</strong> &mdash; sederhanakan proses, fokus pada nilai, dan libatkan tim dalam pengambilan keputusan.</p>\r\n\r\n<p><strong>? CTA:</strong></p>\r\n\r\n<p>Bagaimana Anda melihat peran HR di UMKM? Masih administratif, atau sudah strategis?</p>', '2025-10-25 09:53:40.737091', '2025-12-05 08:23:01.063901', 3, 3, 1, 0, NULL, 1, 1),
(36, 'linkedin_company', 'awareness', 'free', NULL, '2025-10-29', 'post', '2. Lean HR untuk UMKM: Fokus pada Nilai, Bukan Proses yang Ribet', '<p><strong>? Funnel Stage:</strong> <strong>MOFU (Middle of Funnel) &mdash; Consideration</strong><br />\r\n<strong>? Format:</strong> Carousel / Long-form post (dengan poin-poin konkret)<br />\r\n<strong>? Isi singkat:</strong></p>\r\n\r\n<p>Banyak pelaku UMKM berpikir HR efisien berarti memangkas orang &mdash; padahal bukan itu intinya.</p>\r\n\r\n<p><strong>Lean HR</strong> membantu tim fokus pada hal yang benar-benar bernilai:<br />\r\n1?? Hapus aktivitas yang tidak memberikan dampak bisnis<br />\r\n2?? Libatkan karyawan dalam proses perbaikan<br />\r\n3?? Gunakan data sederhana (bukan sistem rumit) untuk ambil keputusan</p>\r\n\r\n<p>Dengan pendekatan Lean, HR bisa jadi mitra strategis yang mendukung pertumbuhan, bukan sekadar bagian operasional.</p>\r\n\r\n<p><strong>? CTA:</strong></p>\r\n\r\n<p>Apakah perusahaan Anda sudah mulai menerapkan prinsip Lean HR? Kalau belum, apa kendalanya?</p>', '2025-10-25 09:56:04.456077', '2025-12-05 08:18:53.106384', 3, 3, 1, 0, NULL, 1, 1),
(37, 'linkedin_newsletter', 'awareness', 'free', '2025-10-28 14:25:00.000000', '2025-10-28', 'newsletter', '1. Perencanaan Tenaga Kerja (Workforce Planning)', '<p><a href=\"https://www.linkedin.com/pulse/perencanaan-tenaga-kerja-dengan-rasio-biaya-eva-setyabudi-5qcmc\">https://www.linkedin.com/pulse/perencanaan-tenaga-kerja-dengan-rasio-biaya-eva-setyabudi-5qcmc</a></p>', '2025-10-28 09:34:14.887804', '2025-12-05 08:47:38.646114', 5, 6, 1, 1, NULL, 1, 1),
(38, 'linkedin', 'awareness', 'free', NULL, '2025-11-05', 'post', 'burount kerja remote', '<p>saya punya gudang kecil berukutan 1 x 4 meter yangsaya funsgsikan sebagai perpustakaan , kantor dan juga ruan server. dulu ketika saya kerja 9 t0 5 saya pikir enak kerja dari rumah ternyata jika tidak dikelola dengan baik kerja remote bisa cepat burn out, saka ketemu komunitas remotewokerpontianak. saya juga kadang kena ganggu anak istri, kadang bingung antara pekerjaan atau jeluarga karena tercampur aduk</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>? <strong>1. SEO Title</strong></p>\r\n\r\n<p>? <strong>Tujuan:</strong> Menarik klik di hasil pencarian, tapi tetap relevan.<br />\r\nGunakan <strong>judul yang mengandung kata kunci utama</strong> (misalnya: <em>rekrutmen efisien, lean HR, talent acquisition</em>).<br />\r\nContoh:</p>\r\n\r\n<p>Lean Talent Acquisition: Cara Rekrutmen Efisien dan Berbasis Data untuk Startup &amp; UMKM</p>\r\n\r\n<p>Rekrutmen Ramping dan Cepat: Prinsip Lean HR untuk Perusahaan Modern</p>\r\n\r\n<p>?? <strong>2. SEO Description</strong></p>\r\n\r\n<p>? <strong>Tujuan:</strong> Ringkasan singkat yang muncul di bawah judul di hasil pencarian.<br />\r\nIsi dengan <strong>kalimat yang menggambarkan manfaat utama artikelmu</strong>, dan sertakan <strong>1&ndash;2 kata kunci utama</strong>.<br />\r\nPanjang ideal: <strong>140&ndash;160 karakter</strong>.</p>\r\n\r\n<p>Contoh:</p>\r\n\r\n<p>Pelajari cara menerapkan Lean Talent Acquisition agar rekrutmen lebih cepat, efisien, dan berbasis data tanpa mengorbankan kualitas kandidat.</p>\r\n\r\n<p>Panduan praktis untuk HR dan pemilik bisnis: rekrutmen ramping, cepat, dan akurat dengan prinsip Lean HR.</p>\r\n\r\n<p>Kalau kamu mau, aku bisa bantu buatkan versi <strong>SEO title + SEO description</strong> spesifik untuk artikel <em>Seri Lean HR #2: Rekrutmen dan Seleksi</em> agar langsung siap pakai. Mau saya bantu buatkan?</p>', '2025-11-04 12:58:18.082316', '2025-12-05 08:11:25.303536', 3, 1, 1, 0, NULL, 1, 1),
(39, NULL, '', '', '2025-10-25 14:00:00.000000', NULL, 'utas', 'Ketika kamu anak milenial biasa bekerja dengan gaya boomer, kemu', '<p><a href=\"https://www.threads.com/@eva_setyabudi/post/DQN8x5Hic_A\">https://www.threads.com/@eva_setyabudi/post/DQN8x5Hic_A</a></p>', '2025-12-09 04:15:27.398785', '2025-12-09 04:15:27.398810', 6, 3, 1, 1, NULL, 1, 1),
(40, NULL, '', '', '2026-01-16 09:19:00.000000', NULL, 'post', 'skill HR yang dibutuhkan 5 tahun ke depan', '<p><a href=\"https://www.instagram.com/p/DTje5m2k4xU/?utm_source=ig_web_copy_link&amp;igsh=NTc4MTIwNjQ2YQ==\">https://www.instagram.com/p/DTje5m2k4xU/?utm_source=ig_web_copy_link&amp;igsh=NTc4MTIwNjQ2YQ==</a></p>', '2026-01-16 02:20:28.952835', '2026-01-16 02:20:28.952857', 3, 1, 4, 1, NULL, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `post_media_channelperformance`
--

CREATE TABLE `post_media_channelperformance` (
  `id` bigint(20) NOT NULL,
  `period` varchar(10) NOT NULL,
  `as_of_date` date NOT NULL,
  `metrics` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`metrics`)),
  `created_at` datetime(6) NOT NULL,
  `channel_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `post_media_channelperformance`
--

INSERT INTO `post_media_channelperformance` (`id`, `period`, `as_of_date`, `metrics`, `created_at`, `channel_id`) VALUES
(5, '1w', '2025-10-24', '{}', '2025-10-24 15:26:32.010025', 13),
(6, '1m', '2025-10-24', '{\"views\": 4, \"impressions\": 193, \"reactions\": 7, \"comments\": 0, \"shares\": 0, \"member_reached\": 78, \"profile_activity\": 0, \"social_engagement\": 1}', '2025-10-24 15:26:32.026490', 13),
(7, '24h', '2025-10-24', '{}', '2025-10-24 15:36:29.011645', 25),
(8, '1w', '2025-10-24', '{}', '2025-10-24 15:36:29.020091', 25),
(9, '1m', '2025-10-24', '{\"views\": 0, \"impressions\": 152, \"reactions\": 2, \"comments\": 0, \"shares\": 0, \"member_reached\": 11, \"engagement\": 3, \"clicks\": 0, \"repost\": 0}', '2025-10-24 15:36:29.032696', 25),
(10, '24h', '2025-10-24', '{}', '2025-10-24 15:41:54.057105', 12),
(11, '1w', '2025-10-24', '{}', '2025-10-24 15:41:54.065974', 12),
(12, '1m', '2025-10-24', '{\"impressions\": 258, \"member_reached\": 104, \"profile_activity\": 0, \"views\": 73, \"social_engagement\": 3}', '2025-10-24 15:41:54.076031', 12),
(13, '24h', '2025-10-24', '{}', '2025-10-24 15:43:37.272799', 10),
(14, '1w', '2025-10-24', '{}', '2025-10-24 15:43:37.280887', 10),
(15, '1m', '2025-10-24', '{}', '2025-10-24 15:43:37.292833', 10),
(16, '24h', '2025-10-24', '{}', '2025-10-24 15:49:41.455708', 11),
(17, '1w', '2025-10-24', '{}', '2025-10-24 15:49:41.477323', 11),
(18, '1m', '2025-10-24', '{}', '2025-10-24 15:49:41.493193', 11),
(19, '24h', '2025-10-24', '{}', '2025-10-24 15:55:32.261635', 23),
(20, '1w', '2025-10-24', '{}', '2025-10-24 15:55:32.271817', 23),
(21, '1m', '2025-10-24', '{\"views\": 24, \"impressions\": 140, \"likes\": 0, \"reactions\": 7, \"comments\": 0, \"shares\": 0, \"member_reached\": 4, \"engagement\": 7, \"clicks\": 0, \"repost\": 0}', '2025-10-24 15:55:32.283514', 23),
(22, '24h', '2025-10-24', '{}', '2025-10-24 16:42:37.310440', 26),
(23, '1w', '2025-10-24', '{}', '2025-10-24 16:42:37.320313', 26),
(24, '1m', '2025-10-24', '{\"impressions\": 324, \"member_reached\": 127, \"profile_activity\": 4, \"views\": 18, \"social_engagement\": 0}', '2025-10-24 16:42:37.330096', 26),
(25, '24h', '2025-10-24', '{}', '2025-10-24 17:32:44.506065', 27),
(26, '1w', '2025-10-24', '{}', '2025-10-24 17:32:44.515319', 27),
(27, '1m', '2025-10-24', '{\"impressions\": 450, \"member_reached\": 191, \"profile_activity\": 3, \"views\": 111, \"social_engagement\": 9}', '2025-10-24 17:32:44.524848', 27),
(28, '24h', '2025-10-24', '{}', '2025-10-24 18:58:41.255932', 28),
(29, '1w', '2025-10-24', '{}', '2025-10-24 18:58:41.269607', 28),
(30, '1m', '2025-10-24', '{\"impressions\": 389, \"member_reached\": 139, \"profile_activity\": 0, \"views\": 17, \"social_engagement\": 2}', '2025-10-24 18:58:41.283035', 28),
(31, '24h', '2025-10-24', '{}', '2025-10-24 20:13:51.759840', 3),
(32, '1w', '2025-10-24', '{}', '2025-10-24 20:13:51.767232', 3),
(33, '1m', '2025-10-24', '{}', '2025-10-24 20:13:51.775766', 3),
(34, '24h', '2025-10-24', '{}', '2025-10-24 20:32:33.892047', 4),
(35, '1w', '2025-10-24', '{}', '2025-10-24 20:32:33.901795', 4),
(36, '1m', '2025-10-24', '{}', '2025-10-24 20:32:33.910140', 4),
(37, '24h', '2025-10-24', '{}', '2025-10-24 20:38:00.351934', 21),
(38, '1w', '2025-10-24', '{}', '2025-10-24 20:38:00.360079', 21),
(39, '1m', '2025-10-24', '{}', '2025-10-24 20:38:00.368949', 21),
(40, '24h', '2025-10-25', '{}', '2025-10-25 08:26:35.661290', 3),
(41, '1w', '2025-10-25', '{}', '2025-10-25 08:26:35.670662', 3),
(42, '1m', '2025-10-25', '{\"views\": 93, \"view_f\": 31, \"view_nf\": 69, \"account_reached\": 14, \"interaction\": 1, \"profile\": 3}', '2025-10-25 08:26:35.679029', 3),
(43, '24h', '2025-10-25', '{}', '2025-10-25 08:29:21.065274', 4),
(44, '1w', '2025-10-25', '{}', '2025-10-25 08:29:21.083059', 4),
(45, '1m', '2025-10-25', '{\"views\": 91, \"view_f\": 32, \"view_nf\": 68, \"account_reached\": 16, \"interaction\": 2, \"profile\": 0}', '2025-10-25 08:29:21.092037', 4),
(46, '24h', '2025-10-25', '{}', '2025-10-25 08:30:23.256387', 6),
(47, '1w', '2025-10-25', '{}', '2025-10-25 08:30:23.265891', 6),
(48, '1m', '2025-10-25', '{\"views\": 99, \"view_f\": 38, \"view_nf\": 61, \"account_reached\": 17, \"interaction\": 3, \"profile\": 1}', '2025-10-25 08:30:23.275923', 6),
(49, '24h', '2025-10-25', '{}', '2025-10-25 08:31:24.749379', 7),
(50, '1w', '2025-10-25', '{}', '2025-10-25 08:31:24.764960', 7),
(51, '1m', '2025-10-25', '{\"views\": 106, \"view_f\": 32, \"view_nf\": 68, \"account_reached\": 20, \"interaction\": 5, \"profile\": 0}', '2025-10-25 08:31:24.772100', 7),
(52, '24h', '2025-10-25', '{}', '2025-10-25 08:33:31.430727', 29),
(53, '1w', '2025-10-25', '{}', '2025-10-25 08:33:31.440950', 29),
(54, '1m', '2025-10-25', '{\"views\": 105, \"view_f\": 38, \"view_nf\": 62, \"account_reached\": 17, \"interaction\": 2, \"profile\": 0}', '2025-10-25 08:33:31.450357', 29),
(55, '24h', '2025-10-25', '{}', '2025-10-25 08:36:52.649331', 8),
(56, '1w', '2025-10-25', '{}', '2025-10-25 08:36:52.659027', 8),
(57, '1m', '2025-10-25', '{\"views\": 96, \"view_f\": 32, \"view_nf\": 68, \"account_reached\": 16, \"interaction\": 2, \"profile\": 0}', '2025-10-25 08:36:52.672982', 8),
(58, '24h', '2025-10-25', '{}', '2025-10-25 08:38:54.738003', 30),
(59, '1w', '2025-10-25', '{}', '2025-10-25 08:38:54.765102', 30),
(60, '1m', '2025-10-25', '{\"views\": 105, \"view_f\": 32, \"view_nf\": 68, \"account_reached\": 19, \"interaction\": 1, \"profile\": 1}', '2025-10-25 08:38:54.785928', 30),
(61, '24h', '2025-10-25', '{}', '2025-10-25 08:45:51.981960', 31),
(62, '1w', '2025-10-25', '{}', '2025-10-25 08:45:51.992104', 31),
(63, '1m', '2025-10-25', '{}', '2025-10-25 08:45:52.015418', 31),
(64, '24h', '2025-10-25', '{}', '2025-10-25 09:58:58.121273', 32),
(65, '1w', '2025-10-25', '{}', '2025-10-25 09:58:58.129126', 32),
(66, '1m', '2025-10-25', '{}', '2025-10-25 09:58:58.143703', 32),
(67, '24h', '2025-10-28', '{}', '2025-10-28 08:34:10.287018', 33),
(68, '1w', '2025-10-28', '{}', '2025-10-28 08:34:10.296143', 33),
(69, '1m', '2025-10-28', '{}', '2025-10-28 08:34:10.315902', 33),
(70, '24h', '2025-10-28', '{}', '2025-10-28 08:35:06.313052', 32),
(71, '1w', '2025-10-28', '{}', '2025-10-28 08:35:06.325730', 32),
(72, '1m', '2025-10-28', '{\"views\": 36, \"view_f\": 97, \"view_nf\": 3, \"account_reached\": 9, \"interaction\": 3, \"profile\": 2}', '2025-10-28 08:35:06.347702', 32),
(73, '24h', '2025-10-28', '{}', '2025-10-28 08:41:30.434141', 36),
(74, '1w', '2025-10-28', '{}', '2025-10-28 08:41:30.444562', 36),
(75, '1m', '2025-10-28', '{}', '2025-10-28 08:41:30.457910', 36),
(76, '24h', '2025-10-28', '{}', '2025-10-28 08:41:53.114449', 14),
(77, '1w', '2025-10-28', '{}', '2025-10-28 08:41:53.121603', 14),
(78, '1m', '2025-10-28', '{}', '2025-10-28 08:41:53.130940', 14),
(79, '24h', '2025-10-28', '{}', '2025-10-28 09:54:45.757278', 15),
(80, '1w', '2025-10-28', '{}', '2025-10-28 09:54:46.165066', 15),
(81, '1m', '2025-10-28', '{}', '2025-10-28 09:54:46.181322', 15),
(82, '24h', '2025-10-28', '{}', '2025-10-28 14:25:16.378224', 37),
(83, '1w', '2025-10-28', '{}', '2025-10-28 14:25:16.387124', 37),
(84, '1m', '2025-10-28', '{}', '2025-10-28 14:25:16.397527', 37),
(85, '24h', '2025-10-28', '{}', '2025-10-28 14:26:45.292144', 1),
(86, '1w', '2025-10-28', '{}', '2025-10-28 14:26:45.304240', 1),
(87, '1m', '2025-10-28', '{}', '2025-10-28 14:26:45.344185', 1),
(88, '24h', '2025-10-31', '{}', '2025-10-31 10:45:53.593674', 37),
(89, '1w', '2025-10-31', '{}', '2025-10-31 10:45:53.603124', 37),
(90, '1m', '2025-10-31', '{\"impressions\": 207, \"member_reached\": 122, \"profile_activity\": 2, \"views\": 48, \"social_engagement\": 7}', '2025-10-31 10:45:53.612920', 37),
(91, '24h', '2025-10-31', '{}', '2025-10-31 10:57:43.237107', 32),
(92, '1w', '2025-10-31', '{\"views\": 42, \"view_f\": 97, \"view_nf\": 3, \"account_reached\": 10, \"interaction\": 3, \"profile\": 2}', '2025-10-31 10:57:43.245663', 32),
(93, '1m', '2025-10-31', '{}', '2025-10-31 10:57:43.264983', 32),
(94, '24h', '2025-10-31', '{}', '2025-10-31 11:00:42.661374', 33),
(95, '1w', '2025-10-31', '{\"views\": 30, \"view_f\": 100, \"view_nf\": 0, \"account_reached\": 8, \"interaction\": 5, \"profile\": 0}', '2025-10-31 11:00:42.688399', 33),
(96, '1m', '2025-10-31', '{}', '2025-10-31 11:00:42.697312', 33),
(97, '24h', '2025-11-04', '{}', '2025-11-04 12:02:21.302209', 37),
(98, '1w', '2025-11-04', '{}', '2025-11-04 12:02:21.310747', 37),
(99, '1m', '2025-11-04', '{\"impressions\": 258, \"member_reached\": 154, \"profile_activity\": 2, \"views\": 55, \"social_engagement\": 8}', '2025-11-04 12:02:21.320381', 37),
(100, '24h', '2025-11-04', '{}', '2025-11-04 12:05:46.563114', 15),
(101, '1w', '2025-11-04', '{}', '2025-11-04 12:05:46.570697', 15),
(102, '1m', '2025-11-04', '{}', '2025-11-04 12:05:46.578827', 15),
(103, '24h', '2025-11-04', '{}', '2025-11-04 12:48:01.730157', 16),
(104, '1w', '2025-11-04', '{}', '2025-11-04 12:48:01.749106', 16),
(105, '1m', '2025-11-04', '{}', '2025-11-04 12:48:01.760576', 16),
(106, '24h', '2025-11-04', '{}', '2025-11-04 12:48:20.082098', 17),
(107, '1w', '2025-11-04', '{}', '2025-11-04 12:48:20.091379', 17),
(108, '1m', '2025-11-04', '{}', '2025-11-04 12:48:20.100067', 17),
(109, '24h', '2025-11-04', '{}', '2025-11-04 12:48:35.247276', 18),
(110, '1w', '2025-11-04', '{}', '2025-11-04 12:48:35.262163', 18),
(111, '1m', '2025-11-04', '{}', '2025-11-04 12:48:35.268728', 18),
(112, '24h', '2025-11-04', '{}', '2025-11-04 12:48:55.960857', 19),
(113, '1w', '2025-11-04', '{}', '2025-11-04 12:48:56.034205', 19),
(114, '1m', '2025-11-04', '{}', '2025-11-04 12:48:56.047098', 19),
(115, '24h', '2025-11-04', '{}', '2025-11-04 12:49:40.791626', 20),
(116, '1w', '2025-11-04', '{}', '2025-11-04 12:49:40.801312', 20),
(117, '1m', '2025-11-04', '{}', '2025-11-04 12:49:40.811672', 20),
(118, '24h', '2025-11-04', '{}', '2025-11-04 12:49:54.111530', 21),
(119, '1w', '2025-11-04', '{}', '2025-11-04 12:49:54.120353', 21),
(120, '1m', '2025-11-04', '{}', '2025-11-04 12:49:54.128418', 21),
(121, '24h', '2025-11-04', '{}', '2025-11-04 12:50:28.187465', 10),
(122, '1w', '2025-11-04', '{}', '2025-11-04 12:50:28.204411', 10),
(123, '1m', '2025-11-04', '{}', '2025-11-04 12:50:28.217887', 10),
(124, '24h', '2025-11-04', '{}', '2025-11-04 14:03:27.349443', 8),
(125, '1w', '2025-11-04', '{}', '2025-11-04 14:03:27.420080', 8),
(126, '1m', '2025-11-04', '{}', '2025-11-04 14:03:27.448569', 8),
(127, '24h', '2025-11-12', '{}', '2025-11-12 09:23:56.142236', 16),
(128, '1w', '2025-11-12', '{}', '2025-11-12 09:23:56.151906', 16),
(129, '1m', '2025-11-12', '{}', '2025-11-12 09:23:56.163166', 16),
(130, '24h', '2025-11-21', '{}', '2025-11-21 01:36:14.560375', 38),
(131, '1w', '2025-11-21', '{}', '2025-11-21 01:36:14.591617', 38),
(132, '1m', '2025-11-21', '{}', '2025-11-21 01:36:14.603152', 38),
(133, '24h', '2025-11-21', '{}', '2025-11-21 05:39:50.985387', 16),
(134, '1w', '2025-11-21', '{}', '2025-11-21 05:39:50.998918', 16),
(135, '1m', '2025-11-21', '{}', '2025-11-21 05:39:51.008460', 16),
(136, '24h', '2025-11-21', '{}', '2025-11-21 05:41:49.725814', 17),
(137, '1w', '2025-11-21', '{}', '2025-11-21 05:41:49.733640', 17),
(138, '1m', '2025-11-21', '{}', '2025-11-21 05:41:49.742850', 17),
(139, '24h', '2025-11-21', '{}', '2025-11-21 06:02:07.567378', 28),
(140, '1w', '2025-11-21', '{}', '2025-11-21 06:02:07.594264', 28),
(141, '1m', '2025-11-21', '{}', '2025-11-21 06:02:07.602931', 28),
(142, '24h', '2025-11-21', '{}', '2025-11-21 06:02:10.060322', 37),
(143, '1w', '2025-11-21', '{}', '2025-11-21 06:02:10.067935', 37),
(144, '1m', '2025-11-21', '{}', '2025-11-21 06:02:10.077500', 37),
(145, '24h', '2025-11-21', '{}', '2025-11-21 06:26:32.448119', 18),
(146, '1w', '2025-11-21', '{}', '2025-11-21 06:26:32.481908', 18),
(147, '1m', '2025-11-21', '{}', '2025-11-21 06:26:32.489691', 18),
(148, '24h', '2025-12-05', '{}', '2025-12-05 00:29:54.346874', 17),
(149, '1w', '2025-12-05', '{}', '2025-12-05 00:29:54.391672', 17),
(150, '1m', '2025-12-05', '{}', '2025-12-05 00:29:54.400316', 17),
(151, '24h', '2025-12-05', '{}', '2025-12-05 01:58:15.788097', 26),
(152, '1w', '2025-12-05', '{}', '2025-12-05 01:58:15.797292', 26),
(153, '1m', '2025-12-05', '{}', '2025-12-05 01:58:15.813994', 26),
(154, '24h', '2025-12-05', '{}', '2025-12-05 01:58:57.657077', 28),
(155, '1w', '2025-12-05', '{}', '2025-12-05 01:58:57.669196', 28),
(156, '1m', '2025-12-05', '{}', '2025-12-05 01:58:57.678420', 28),
(157, '24h', '2025-12-05', '{}', '2025-12-05 01:59:30.758420', 27),
(158, '1w', '2025-12-05', '{}', '2025-12-05 01:59:30.779783', 27),
(159, '1m', '2025-12-05', '{}', '2025-12-05 01:59:30.790375', 27),
(160, '24h', '2025-12-05', '{}', '2025-12-05 01:59:46.729141', 13),
(161, '1w', '2025-12-05', '{}', '2025-12-05 01:59:46.746358', 13),
(162, '1m', '2025-12-05', '{}', '2025-12-05 01:59:46.759184', 13),
(163, '24h', '2025-12-05', '{}', '2025-12-05 02:00:03.355830', 18),
(164, '1w', '2025-12-05', '{}', '2025-12-05 02:00:03.367087', 18),
(165, '1m', '2025-12-05', '{}', '2025-12-05 02:00:03.378470', 18),
(166, '24h', '2025-12-05', '{}', '2025-12-05 03:06:19.729262', 8),
(167, '1w', '2025-12-05', '{}', '2025-12-05 03:06:19.761212', 8),
(168, '1m', '2025-12-05', '{}', '2025-12-05 03:06:19.773725', 8),
(169, '24h', '2025-12-05', '{}', '2025-12-05 03:08:55.431834', 7),
(170, '1w', '2025-12-05', '{}', '2025-12-05 03:08:55.442593', 7),
(171, '1m', '2025-12-05', '{}', '2025-12-05 03:08:55.452903', 7),
(172, '24h', '2025-12-05', '{}', '2025-12-05 03:09:12.895688', 6),
(173, '1w', '2025-12-05', '{}', '2025-12-05 03:09:12.903998', 6),
(174, '1m', '2025-12-05', '{}', '2025-12-05 03:09:12.916246', 6),
(175, '24h', '2025-12-05', '{}', '2025-12-05 03:09:43.162826', 4),
(176, '1w', '2025-12-05', '{}', '2025-12-05 03:09:43.183041', 4),
(177, '1m', '2025-12-05', '{}', '2025-12-05 03:09:43.208088', 4),
(178, '24h', '2025-12-05', '{}', '2025-12-05 03:10:33.943275', 2),
(179, '1w', '2025-12-05', '{}', '2025-12-05 03:10:33.964335', 2),
(180, '1m', '2025-12-05', '{}', '2025-12-05 03:10:33.983969', 2),
(181, '24h', '2025-12-05', '{}', '2025-12-05 03:10:54.294142', 1),
(182, '1w', '2025-12-05', '{}', '2025-12-05 03:10:54.301923', 1),
(183, '1m', '2025-12-05', '{}', '2025-12-05 03:10:54.310389', 1),
(184, '24h', '2025-12-05', '{}', '2025-12-05 03:11:27.524495', 25),
(185, '1w', '2025-12-05', '{}', '2025-12-05 03:11:27.564138', 25),
(186, '1m', '2025-12-05', '{}', '2025-12-05 03:11:27.576158', 25),
(187, '24h', '2025-12-05', '{}', '2025-12-05 03:11:44.636581', 23),
(188, '1w', '2025-12-05', '{}', '2025-12-05 03:11:44.648861', 23),
(189, '1m', '2025-12-05', '{}', '2025-12-05 03:11:44.660619', 23),
(190, '24h', '2025-12-05', '{}', '2025-12-05 03:12:28.908124', 34),
(191, '1w', '2025-12-05', '{}', '2025-12-05 03:12:28.917433', 34),
(192, '1m', '2025-12-05', '{}', '2025-12-05 03:12:28.925663', 34),
(193, '24h', '2025-12-05', '{}', '2025-12-05 07:26:00.837176', 38),
(194, '1w', '2025-12-05', '{}', '2025-12-05 07:26:00.896705', 38),
(195, '1m', '2025-12-05', '{}', '2025-12-05 07:26:00.921038', 38),
(196, '24h', '2025-12-05', '{}', '2025-12-05 08:09:43.440690', 19),
(197, '1w', '2025-12-05', '{}', '2025-12-05 08:09:43.449048', 19),
(198, '1m', '2025-12-05', '{}', '2025-12-05 08:09:43.459677', 19),
(199, '24h', '2025-12-05', '{}', '2025-12-05 08:11:37.208808', 11),
(200, '1w', '2025-12-05', '{}', '2025-12-05 08:11:37.216481', 11),
(201, '1m', '2025-12-05', '{}', '2025-12-05 08:11:37.224912', 11),
(202, '24h', '2025-12-05', '{}', '2025-12-05 08:12:31.832458', 20),
(203, '1w', '2025-12-05', '{}', '2025-12-05 08:12:31.842962', 20),
(204, '1m', '2025-12-05', '{}', '2025-12-05 08:12:31.853080', 20),
(205, '24h', '2025-12-05', '{}', '2025-12-05 08:14:42.767263', 21),
(206, '1w', '2025-12-05', '{}', '2025-12-05 08:14:42.773577', 21),
(207, '1m', '2025-12-05', '{}', '2025-12-05 08:14:42.780577', 21),
(208, '24h', '2025-12-05', '{}', '2025-12-05 08:16:30.887545', 10),
(209, '1w', '2025-12-05', '{}', '2025-12-05 08:16:30.895158', 10),
(210, '1m', '2025-12-05', '{}', '2025-12-05 08:16:30.902309', 10),
(211, '24h', '2025-12-05', '{}', '2025-12-05 08:17:20.907636', 14),
(212, '1w', '2025-12-05', '{}', '2025-12-05 08:17:20.918681', 14),
(213, '1m', '2025-12-05', '{}', '2025-12-05 08:17:20.926382', 14),
(214, '24h', '2025-12-05', '{}', '2025-12-05 08:17:44.713996', 31),
(215, '1w', '2025-12-05', '{}', '2025-12-05 08:17:44.723663', 31),
(216, '1m', '2025-12-05', '{}', '2025-12-05 08:17:44.732398', 31),
(217, '24h', '2025-12-05', '{}', '2025-12-05 08:18:13.025392', 36),
(218, '1w', '2025-12-05', '{}', '2025-12-05 08:18:13.038535', 36),
(219, '1m', '2025-12-05', '{}', '2025-12-05 08:18:13.048111', 36),
(220, '24h', '2025-12-05', '{}', '2025-12-05 08:19:37.339966', 3),
(221, '1w', '2025-12-05', '{}', '2025-12-05 08:19:37.388238', 3),
(222, '1m', '2025-12-05', '{}', '2025-12-05 08:19:37.397082', 3),
(223, '24h', '2025-12-05', '{}', '2025-12-05 08:22:35.918417', 35),
(224, '1w', '2025-12-05', '{}', '2025-12-05 08:22:35.926162', 35),
(225, '1m', '2025-12-05', '{}', '2025-12-05 08:22:35.932575', 35),
(226, '24h', '2025-12-05', '{}', '2025-12-05 08:23:04.470309', 33),
(227, '1w', '2025-12-05', '{}', '2025-12-05 08:23:04.476957', 33),
(228, '1m', '2025-12-05', '{}', '2025-12-05 08:23:04.482844', 33),
(229, '24h', '2025-12-05', '{}', '2025-12-05 08:25:37.221637', 32),
(230, '1w', '2025-12-05', '{}', '2025-12-05 08:25:37.239267', 32),
(231, '1m', '2025-12-05', '{}', '2025-12-05 08:25:37.250218', 32),
(232, '24h', '2025-12-05', '{}', '2025-12-05 08:25:54.816008', 30),
(233, '1w', '2025-12-05', '{}', '2025-12-05 08:25:54.822457', 30),
(234, '1m', '2025-12-05', '{}', '2025-12-05 08:25:54.838018', 30),
(235, '24h', '2025-12-05', '{}', '2025-12-05 08:31:57.553697', 29),
(236, '1w', '2025-12-05', '{}', '2025-12-05 08:31:57.568915', 29),
(237, '1m', '2025-12-05', '{}', '2025-12-05 08:31:57.576281', 29),
(238, '24h', '2025-12-05', '{}', '2025-12-05 08:35:36.992315', 15),
(239, '1w', '2025-12-05', '{}', '2025-12-05 08:35:37.100528', 15),
(240, '1m', '2025-12-05', '{}', '2025-12-05 08:35:37.108714', 15),
(241, '24h', '2025-12-05', '{}', '2025-12-05 08:44:01.156929', 16),
(242, '1w', '2025-12-05', '{}', '2025-12-05 08:44:01.199375', 16),
(243, '1m', '2025-12-05', '{}', '2025-12-05 08:44:01.222952', 16),
(244, '24h', '2025-12-05', '{}', '2025-12-05 08:45:55.076599', 37),
(245, '1w', '2025-12-05', '{}', '2025-12-05 08:45:55.109939', 37),
(246, '1m', '2025-12-05', '{}', '2025-12-05 08:45:55.117289', 37),
(247, '24h', '2025-12-05', '{}', '2025-12-05 08:48:04.551912', 12),
(248, '1w', '2025-12-05', '{}', '2025-12-05 08:48:04.559943', 12),
(249, '1m', '2025-12-05', '{}', '2025-12-05 08:48:04.568108', 12),
(250, '24h', '2025-12-09', '{}', '2025-12-09 04:15:45.156845', 39),
(251, '1w', '2025-12-09', '{}', '2025-12-09 04:15:45.168571', 39),
(252, '1m', '2025-12-09', '{\"views\": 94, \"impressions\": 0, \"likes\": 1, \"reactions\": 0, \"comments\": 0, \"shares\": 0}', '2025-12-09 04:15:45.177340', 39),
(253, '24h', '2026-01-16', '{}', '2026-01-16 01:08:34.755716', 19),
(254, '1w', '2026-01-16', '{}', '2026-01-16 01:08:34.784151', 19),
(255, '1m', '2026-01-16', '{}', '2026-01-16 01:08:34.794781', 19),
(256, '24h', '2026-01-16', '{}', '2026-01-16 01:12:31.407557', 18),
(257, '1w', '2026-01-16', '{}', '2026-01-16 01:12:31.429161', 18),
(258, '1m', '2026-01-16', '{}', '2026-01-16 01:12:31.437503', 18),
(259, '24h', '2026-01-16', '{}', '2026-01-16 02:18:56.709347', 34),
(260, '1w', '2026-01-16', '{}', '2026-01-16 02:18:56.768057', 34),
(261, '1m', '2026-01-16', '{}', '2026-01-16 02:18:56.781779', 34),
(262, '24h', '2026-02-20', '{}', '2026-02-20 03:27:13.376915', 19),
(263, '1w', '2026-02-20', '{}', '2026-02-20 03:27:13.396792', 19),
(264, '1m', '2026-02-20', '{}', '2026-02-20 03:27:13.414616', 19);

-- --------------------------------------------------------

--
-- Table structure for table `post_media_digitalchannel`
--

CREATE TABLE `post_media_digitalchannel` (
  `id` bigint(20) NOT NULL,
  `name` varchar(20) DEFAULT NULL,
  `description` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `post_media_digitalchannel`
--

INSERT INTO `post_media_digitalchannel` (`id`, `name`, `description`) VALUES
(1, 'Instagram', ''),
(2, 'Facebook', ''),
(3, 'Threads', ''),
(4, 'Linkedin', ''),
(5, 'Linkedin Company', ''),
(6, 'Linkedin Newsletter', ''),
(7, 'Blog Post', '');

-- --------------------------------------------------------

--
-- Table structure for table `post_media_funnelstage`
--

CREATE TABLE `post_media_funnelstage` (
  `id` bigint(20) NOT NULL,
  `name` varchar(20) DEFAULT NULL,
  `description` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `post_media_funnelstage`
--

INSERT INTO `post_media_funnelstage` (`id`, `name`, `description`) VALUES
(1, 'Awareness', ''),
(2, 'Interest', ''),
(3, 'Desire', ''),
(4, 'Action', ''),
(5, 'Retention', '');

-- --------------------------------------------------------

--
-- Table structure for table `post_media_market`
--

CREATE TABLE `post_media_market` (
  `id` bigint(20) NOT NULL,
  `name` varchar(20) DEFAULT NULL,
  `description` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `post_media_market`
--

INSERT INTO `post_media_market` (`id`, `name`, `description`) VALUES
(1, 'Nusa Sawit', 'Nusa Sawit'),
(2, 'Teknusa', 'data tech nusanta'),
(3, 'SDMPortabel', 'sdmportabel'),
(4, 'Spoonfull', 'spoonfull'),
(5, 'HC Strategic Plannin', 'Newsletter mingguan untukmenggaet folower'),
(6, 'Personal', '');

-- --------------------------------------------------------

--
-- Table structure for table `servermanager_commands`
--

CREATE TABLE `servermanager_commands` (
  `id` bigint(20) NOT NULL,
  `title` varchar(300) NOT NULL,
  `command` varchar(2000) NOT NULL,
  `describe` varchar(300) NOT NULL,
  `created_time` datetime(6) NOT NULL,
  `last_mod_time` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `servermanager_emailsendlog`
--

CREATE TABLE `servermanager_emailsendlog` (
  `id` bigint(20) NOT NULL,
  `emailto` varchar(300) NOT NULL,
  `title` varchar(2000) NOT NULL,
  `content` longtext NOT NULL,
  `send_result` tinyint(1) NOT NULL,
  `created_time` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `setting_customcode`
--

CREATE TABLE `setting_customcode` (
  `id` bigint(20) NOT NULL,
  `statistics` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `setting_friendlinks`
--

CREATE TABLE `setting_friendlinks` (
  `id` bigint(20) NOT NULL,
  `name` varchar(50) NOT NULL,
  `link` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `setting_seo`
--

CREATE TABLE `setting_seo` (
  `id` bigint(20) NOT NULL,
  `title` varchar(100) NOT NULL,
  `sub_title` varchar(200) NOT NULL,
  `description` varchar(200) NOT NULL,
  `keywords` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `setting_siteinfo`
--

CREATE TABLE `setting_siteinfo` (
  `id` bigint(20) NOT NULL,
  `created_time` date NOT NULL,
  `record_info` varchar(100) NOT NULL,
  `development_info` varchar(100) NOT NULL,
  `arrange_info` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `setting_social`
--

CREATE TABLE `setting_social` (
  `id` bigint(20) NOT NULL,
  `github` varchar(200) NOT NULL,
  `wei_bo` varchar(200) NOT NULL,
  `zhi_hu` varchar(200) NOT NULL,
  `qq` varchar(20) NOT NULL,
  `wechat` varchar(50) NOT NULL,
  `official_wechat` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `about_teamexpert`
--
ALTER TABLE `about_teamexpert`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `accounts_employer`
--
ALTER TABLE `accounts_employer`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `accounts_employer_groups`
--
ALTER TABLE `accounts_employer_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `accounts_employer_groups_employer_id_group_id_3a8bfde7_uniq` (`employer_id`,`group_id`),
  ADD KEY `accounts_employer_groups_group_id_4c0754e8_fk_auth_group_id` (`group_id`);

--
-- Indexes for table `accounts_employer_user_permissions`
--
ALTER TABLE `accounts_employer_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `accounts_employer_user_p_employer_id_permission_i_c23ad76c_uniq` (`employer_id`,`permission_id`),
  ADD KEY `accounts_employer_us_permission_id_446747b0_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indexes for table `auth_user`
--
ALTER TABLE `auth_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  ADD KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`);

--
-- Indexes for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  ADD KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `blog_article`
--
ALTER TABLE `blog_article`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `title` (`title`),
  ADD KEY `blog_article_author_id_905add38_fk_auth_user_id` (`author_id`),
  ADD KEY `blog_article_category_id_7e38f15e_fk_blog_category_id` (`category_id`);

--
-- Indexes for table `blog_article_tags`
--
ALTER TABLE `blog_article_tags`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `blog_article_tags_article_id_tag_id_b78a22e9_uniq` (`article_id`,`tag_id`),
  ADD KEY `blog_article_tags_tag_id_88eb3ed9_fk_blog_tag_id` (`tag_id`);

--
-- Indexes for table `blog_blogsettings`
--
ALTER TABLE `blog_blogsettings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `blog_category`
--
ALTER TABLE `blog_category`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `blog_category_parent_category_id_f50c3c0c_fk_blog_category_id` (`parent_category_id`),
  ADD KEY `blog_category_slug_92643dc5` (`slug`);

--
-- Indexes for table `blog_links`
--
ALTER TABLE `blog_links`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `sequence` (`sequence`);

--
-- Indexes for table `blog_sidebar`
--
ALTER TABLE `blog_sidebar`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sequence` (`sequence`);

--
-- Indexes for table `blog_speech`
--
ALTER TABLE `blog_speech`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `blog_tag`
--
ALTER TABLE `blog_tag`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `blog_tag_slug_01068d0e` (`slug`);

--
-- Indexes for table `careers_applicant`
--
ALTER TABLE `careers_applicant`
  ADD PRIMARY KEY (`id`),
  ADD KEY `careers_applicant_user_id_5526cd57_fk_auth_user_id` (`user_id`),
  ADD KEY `careers_applicant_job_id_9e209def_fk_careers_job_id` (`job_id`);

--
-- Indexes for table `careers_applicantdetails`
--
ALTER TABLE `careers_applicantdetails`
  ADD PRIMARY KEY (`id`),
  ADD KEY `careers_applicantdetails_user_id_c6f7193b_fk_auth_user_id` (`user_id`),
  ADD KEY `careers_applicantdetails_job_id_f1bdc3c3_fk_careers_job_id` (`job_id`);

--
-- Indexes for table `careers_job`
--
ALTER TABLE `careers_job`
  ADD PRIMARY KEY (`id`),
  ADD KEY `careers_job_jobcategory_id_d1947878_fk_careers_jobcategory_id` (`jobcategory_id`),
  ADD KEY `careers_job_location_id_bd996914_fk_careers_joblocation_id` (`location_id`),
  ADD KEY `careers_job_user_id_67a2b7e5_fk_auth_user_id` (`user_id`);

--
-- Indexes for table `careers_jobcategory`
--
ALTER TABLE `careers_jobcategory`
  ADD PRIMARY KEY (`id`),
  ADD KEY `careers_jobcategory_user_id_9f2ab589_fk_auth_user_id` (`user_id`);

--
-- Indexes for table `careers_joblocation`
--
ALTER TABLE `careers_joblocation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `careers_joblocation_user_id_fd3e7f7d_fk_auth_user_id` (`user_id`);

--
-- Indexes for table `comment_comment`
--
ALTER TABLE `comment_comment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `comment_comment_content_type_id_fbfb9793_fk_django_co` (`content_type_id`),
  ADD KEY `comment_comment_parent_id_b612524c_fk_comment_comment_id` (`parent_id`),
  ADD KEY `comment_comment_reply_to_id_e0adcef8_fk_auth_user_id` (`reply_to_id`),
  ADD KEY `comment_comment_root_id_28721811_fk_comment_comment_id` (`root_id`),
  ADD KEY `comment_comment_user_id_6078e57b_fk_auth_user_id` (`user_id`);

--
-- Indexes for table `contactus_contact`
--
ALTER TABLE `contactus_contact`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `contactus_mailbook`
--
ALTER TABLE `contactus_mailbook`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `cookie_consent_cookie`
--
ALTER TABLE `cookie_consent_cookie`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `natural_key` (`cookiegroup_id`,`name`,`domain`);

--
-- Indexes for table `cookie_consent_cookiegroup`
--
ALTER TABLE `cookie_consent_cookiegroup`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cookie_consent_cookiegroup_varname_322d11a0_uniq` (`varname`);

--
-- Indexes for table `cookie_consent_logitem`
--
ALTER TABLE `cookie_consent_logitem`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cookie_consent_logit_cookiegroup_id_3bfbe953_fk_cookie_co` (`cookiegroup_id`);

--
-- Indexes for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`);

--
-- Indexes for table `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indexes for table `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- Indexes for table `django_site`
--
ALTER TABLE `django_site`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_site_domain_a2e37b91_uniq` (`domain`);

--
-- Indexes for table `django_summernote_attachment`
--
ALTER TABLE `django_summernote_attachment`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `home_meanlist`
--
ALTER TABLE `home_meanlist`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `home_messages`
--
ALTER TABLE `home_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `home_messages_admin_id_72644b2b_fk_auth_user_id` (`admin_id`);

--
-- Indexes for table `leads_interaction`
--
ALTER TABLE `leads_interaction`
  ADD PRIMARY KEY (`id`),
  ADD KEY `leads_interaction_lead_id_3d739f31_fk_leads_lead_id` (`lead_id`);

--
-- Indexes for table `leads_lead`
--
ALTER TABLE `leads_lead`
  ADD PRIMARY KEY (`id`),
  ADD KEY `leads_lead_assigned_to_id_d7a91e6c_fk_auth_user_id` (`assigned_to_id`);

--
-- Indexes for table `lean_build`
--
ALTER TABLE `lean_build`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lean_build_idea_id_d6faeb0d_fk_lean_idea_id` (`idea_id`);

--
-- Indexes for table `lean_datapoint`
--
ALTER TABLE `lean_datapoint`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lean_datapoint_measure_id_4c8fb4c9_fk_lean_measure_id` (`measure_id`);

--
-- Indexes for table `lean_idea`
--
ALTER TABLE `lean_idea`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `lean_learning`
--
ALTER TABLE `lean_learning`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lean_learning_idea_id_305fc1b8_fk_lean_idea_id` (`idea_id`);

--
-- Indexes for table `lean_measure`
--
ALTER TABLE `lean_measure`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lean_measure_product_id_2152f886_fk_lean_product_id` (`product_id`);

--
-- Indexes for table `lean_product`
--
ALTER TABLE `lean_product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lean_product_build_id_542f3ec0_fk_lean_build_id` (`build_id`);

--
-- Indexes for table `ledger_account`
--
ALTER TABLE `ledger_account`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ledger_closingperiod`
--
ALTER TABLE `ledger_closingperiod`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `period` (`period`);

--
-- Indexes for table `ledger_journalentry`
--
ALTER TABLE `ledger_journalentry`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ledger_journalitem`
--
ALTER TABLE `ledger_journalitem`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ledger_journalitem_account_id_d8390bec_fk_ledger_account_id` (`account_id`),
  ADD KEY `ledger_journalitem_journal_entry_id_1a4bc7e4_fk_ledger_jo` (`journal_entry_id`);

--
-- Indexes for table `likeunlike_like`
--
ALTER TABLE `likeunlike_like`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `likeunlike_like_sender_id_content_type_i_de1b24cd_uniq` (`sender_id`,`content_type_id`,`object_id`),
  ADD KEY `likeunlike_like_content_type_id_c9ca64a6_fk_django_co` (`content_type_id`);

--
-- Indexes for table `myzone_talkcontent`
--
ALTER TABLE `myzone_talkcontent`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `myzone_talkcontent_tag`
--
ALTER TABLE `myzone_talkcontent_tag`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `myzone_talkcontent_tag_talkcontent_id_talktags_id_7e0983cc_uniq` (`talkcontent_id`,`talktags_id`),
  ADD KEY `myzone_talkcontent_t_talktags_id_957fd713_fk_myzone_ta` (`talktags_id`);

--
-- Indexes for table `myzone_talktags`
--
ALTER TABLE `myzone_talktags`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `portfolio_basemodel`
--
ALTER TABLE `portfolio_basemodel`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `portfolio_portfolio`
--
ALTER TABLE `portfolio_portfolio`
  ADD PRIMARY KEY (`basemodel_ptr_id`),
  ADD UNIQUE KEY `title` (`title`),
  ADD KEY `portfolio_portfolio_author_id_36e97922_fk_auth_user_id` (`author_id`);

--
-- Indexes for table `post_media_akun`
--
ALTER TABLE `post_media_akun`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `post_media_biaya`
--
ALTER TABLE `post_media_biaya`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `post_media_channel`
--
ALTER TABLE `post_media_channel`
  ADD PRIMARY KEY (`id`),
  ADD KEY `post_media_channel_for_market_id_f1bf43fc_fk_post_medi` (`for_market_id`),
  ADD KEY `post_media_channel_akun_id_f0e9ea03` (`akun_id`),
  ADD KEY `post_media_channel_channel_id_fk` (`channel_id`),
  ADD KEY `post_media_channel_funnel_stage_id_fk` (`funnel_stage_id`),
  ADD KEY `post_media_channel_kategori_biaya_fk` (`kategori_biaya_id`);

--
-- Indexes for table `post_media_channelperformance`
--
ALTER TABLE `post_media_channelperformance`
  ADD PRIMARY KEY (`id`),
  ADD KEY `post_media_channelpe_channel_id_d7768791_fk_post_medi` (`channel_id`);

--
-- Indexes for table `post_media_digitalchannel`
--
ALTER TABLE `post_media_digitalchannel`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `post_media_funnelstage`
--
ALTER TABLE `post_media_funnelstage`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `post_media_market`
--
ALTER TABLE `post_media_market`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `servermanager_commands`
--
ALTER TABLE `servermanager_commands`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `servermanager_emailsendlog`
--
ALTER TABLE `servermanager_emailsendlog`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `setting_customcode`
--
ALTER TABLE `setting_customcode`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `setting_friendlinks`
--
ALTER TABLE `setting_friendlinks`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `setting_seo`
--
ALTER TABLE `setting_seo`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `setting_siteinfo`
--
ALTER TABLE `setting_siteinfo`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `setting_social`
--
ALTER TABLE `setting_social`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `about_teamexpert`
--
ALTER TABLE `about_teamexpert`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `accounts_employer`
--
ALTER TABLE `accounts_employer`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `accounts_employer_groups`
--
ALTER TABLE `accounts_employer_groups`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `accounts_employer_user_permissions`
--
ALTER TABLE `accounts_employer_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=245;

--
-- AUTO_INCREMENT for table `auth_user`
--
ALTER TABLE `auth_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `blog_article`
--
ALTER TABLE `blog_article`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `blog_article_tags`
--
ALTER TABLE `blog_article_tags`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `blog_blogsettings`
--
ALTER TABLE `blog_blogsettings`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `blog_category`
--
ALTER TABLE `blog_category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `blog_links`
--
ALTER TABLE `blog_links`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `blog_sidebar`
--
ALTER TABLE `blog_sidebar`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `blog_speech`
--
ALTER TABLE `blog_speech`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `blog_tag`
--
ALTER TABLE `blog_tag`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `careers_applicant`
--
ALTER TABLE `careers_applicant`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `careers_applicantdetails`
--
ALTER TABLE `careers_applicantdetails`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `careers_job`
--
ALTER TABLE `careers_job`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `careers_jobcategory`
--
ALTER TABLE `careers_jobcategory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `careers_joblocation`
--
ALTER TABLE `careers_joblocation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `comment_comment`
--
ALTER TABLE `comment_comment`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `contactus_contact`
--
ALTER TABLE `contactus_contact`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `contactus_mailbook`
--
ALTER TABLE `contactus_mailbook`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cookie_consent_cookie`
--
ALTER TABLE `cookie_consent_cookie`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cookie_consent_cookiegroup`
--
ALTER TABLE `cookie_consent_cookiegroup`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cookie_consent_logitem`
--
ALTER TABLE `cookie_consent_logitem`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=93;

--
-- AUTO_INCREMENT for table `django_site`
--
ALTER TABLE `django_site`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `django_summernote_attachment`
--
ALTER TABLE `django_summernote_attachment`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `home_meanlist`
--
ALTER TABLE `home_meanlist`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `home_messages`
--
ALTER TABLE `home_messages`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `leads_interaction`
--
ALTER TABLE `leads_interaction`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `leads_lead`
--
ALTER TABLE `leads_lead`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `lean_build`
--
ALTER TABLE `lean_build`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lean_datapoint`
--
ALTER TABLE `lean_datapoint`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lean_idea`
--
ALTER TABLE `lean_idea`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lean_learning`
--
ALTER TABLE `lean_learning`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lean_measure`
--
ALTER TABLE `lean_measure`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lean_product`
--
ALTER TABLE `lean_product`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ledger_account`
--
ALTER TABLE `ledger_account`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=108;

--
-- AUTO_INCREMENT for table `ledger_closingperiod`
--
ALTER TABLE `ledger_closingperiod`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `ledger_journalentry`
--
ALTER TABLE `ledger_journalentry`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=93;

--
-- AUTO_INCREMENT for table `ledger_journalitem`
--
ALTER TABLE `ledger_journalitem`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=372;

--
-- AUTO_INCREMENT for table `likeunlike_like`
--
ALTER TABLE `likeunlike_like`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `myzone_talkcontent`
--
ALTER TABLE `myzone_talkcontent`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `myzone_talkcontent_tag`
--
ALTER TABLE `myzone_talkcontent_tag`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `myzone_talktags`
--
ALTER TABLE `myzone_talktags`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `portfolio_basemodel`
--
ALTER TABLE `portfolio_basemodel`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `post_media_akun`
--
ALTER TABLE `post_media_akun`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `post_media_biaya`
--
ALTER TABLE `post_media_biaya`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `post_media_channel`
--
ALTER TABLE `post_media_channel`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `post_media_channelperformance`
--
ALTER TABLE `post_media_channelperformance`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=265;

--
-- AUTO_INCREMENT for table `post_media_digitalchannel`
--
ALTER TABLE `post_media_digitalchannel`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `post_media_funnelstage`
--
ALTER TABLE `post_media_funnelstage`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `post_media_market`
--
ALTER TABLE `post_media_market`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `servermanager_commands`
--
ALTER TABLE `servermanager_commands`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `servermanager_emailsendlog`
--
ALTER TABLE `servermanager_emailsendlog`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `setting_customcode`
--
ALTER TABLE `setting_customcode`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `setting_friendlinks`
--
ALTER TABLE `setting_friendlinks`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `setting_seo`
--
ALTER TABLE `setting_seo`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `setting_siteinfo`
--
ALTER TABLE `setting_siteinfo`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `setting_social`
--
ALTER TABLE `setting_social`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `accounts_employer_groups`
--
ALTER TABLE `accounts_employer_groups`
  ADD CONSTRAINT `accounts_employer_gr_employer_id_e14242ce_fk_accounts_` FOREIGN KEY (`employer_id`) REFERENCES `accounts_employer` (`id`),
  ADD CONSTRAINT `accounts_employer_groups_group_id_4c0754e8_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `accounts_employer_user_permissions`
--
ALTER TABLE `accounts_employer_user_permissions`
  ADD CONSTRAINT `accounts_employer_us_employer_id_463b1d05_fk_accounts_` FOREIGN KEY (`employer_id`) REFERENCES `accounts_employer` (`id`),
  ADD CONSTRAINT `accounts_employer_us_permission_id_446747b0_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`);

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `blog_article`
--
ALTER TABLE `blog_article`
  ADD CONSTRAINT `blog_article_author_id_905add38_fk_auth_user_id` FOREIGN KEY (`author_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `blog_article_category_id_7e38f15e_fk_blog_category_id` FOREIGN KEY (`category_id`) REFERENCES `blog_category` (`id`);

--
-- Constraints for table `blog_article_tags`
--
ALTER TABLE `blog_article_tags`
  ADD CONSTRAINT `blog_article_tags_article_id_82c02dd6_fk_blog_article_id` FOREIGN KEY (`article_id`) REFERENCES `blog_article` (`id`),
  ADD CONSTRAINT `blog_article_tags_tag_id_88eb3ed9_fk_blog_tag_id` FOREIGN KEY (`tag_id`) REFERENCES `blog_tag` (`id`);

--
-- Constraints for table `blog_category`
--
ALTER TABLE `blog_category`
  ADD CONSTRAINT `blog_category_parent_category_id_f50c3c0c_fk_blog_category_id` FOREIGN KEY (`parent_category_id`) REFERENCES `blog_category` (`id`);

--
-- Constraints for table `careers_applicant`
--
ALTER TABLE `careers_applicant`
  ADD CONSTRAINT `careers_applicant_job_id_9e209def_fk_careers_job_id` FOREIGN KEY (`job_id`) REFERENCES `careers_job` (`id`),
  ADD CONSTRAINT `careers_applicant_user_id_5526cd57_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `careers_applicantdetails`
--
ALTER TABLE `careers_applicantdetails`
  ADD CONSTRAINT `careers_applicantdetails_job_id_f1bdc3c3_fk_careers_job_id` FOREIGN KEY (`job_id`) REFERENCES `careers_job` (`id`),
  ADD CONSTRAINT `careers_applicantdetails_user_id_c6f7193b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `careers_job`
--
ALTER TABLE `careers_job`
  ADD CONSTRAINT `careers_job_jobcategory_id_d1947878_fk_careers_jobcategory_id` FOREIGN KEY (`jobcategory_id`) REFERENCES `careers_jobcategory` (`id`),
  ADD CONSTRAINT `careers_job_location_id_bd996914_fk_careers_joblocation_id` FOREIGN KEY (`location_id`) REFERENCES `careers_joblocation` (`id`),
  ADD CONSTRAINT `careers_job_user_id_67a2b7e5_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `careers_jobcategory`
--
ALTER TABLE `careers_jobcategory`
  ADD CONSTRAINT `careers_jobcategory_user_id_9f2ab589_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `careers_joblocation`
--
ALTER TABLE `careers_joblocation`
  ADD CONSTRAINT `careers_joblocation_user_id_fd3e7f7d_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `comment_comment`
--
ALTER TABLE `comment_comment`
  ADD CONSTRAINT `comment_comment_content_type_id_fbfb9793_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `comment_comment_parent_id_b612524c_fk_comment_comment_id` FOREIGN KEY (`parent_id`) REFERENCES `comment_comment` (`id`),
  ADD CONSTRAINT `comment_comment_reply_to_id_e0adcef8_fk_auth_user_id` FOREIGN KEY (`reply_to_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `comment_comment_root_id_28721811_fk_comment_comment_id` FOREIGN KEY (`root_id`) REFERENCES `comment_comment` (`id`),
  ADD CONSTRAINT `comment_comment_user_id_6078e57b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `cookie_consent_cookie`
--
ALTER TABLE `cookie_consent_cookie`
  ADD CONSTRAINT `cookie_consent_cooki_cookiegroup_id_96c0ab4b_fk_cookie_co` FOREIGN KEY (`cookiegroup_id`) REFERENCES `cookie_consent_cookiegroup` (`id`);

--
-- Constraints for table `cookie_consent_logitem`
--
ALTER TABLE `cookie_consent_logitem`
  ADD CONSTRAINT `cookie_consent_logit_cookiegroup_id_3bfbe953_fk_cookie_co` FOREIGN KEY (`cookiegroup_id`) REFERENCES `cookie_consent_cookiegroup` (`id`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `home_messages`
--
ALTER TABLE `home_messages`
  ADD CONSTRAINT `home_messages_admin_id_72644b2b_fk_auth_user_id` FOREIGN KEY (`admin_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `leads_interaction`
--
ALTER TABLE `leads_interaction`
  ADD CONSTRAINT `leads_interaction_lead_id_3d739f31_fk_leads_lead_id` FOREIGN KEY (`lead_id`) REFERENCES `leads_lead` (`id`);

--
-- Constraints for table `leads_lead`
--
ALTER TABLE `leads_lead`
  ADD CONSTRAINT `leads_lead_assigned_to_id_d7a91e6c_fk_auth_user_id` FOREIGN KEY (`assigned_to_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `lean_build`
--
ALTER TABLE `lean_build`
  ADD CONSTRAINT `lean_build_idea_id_d6faeb0d_fk_lean_idea_id` FOREIGN KEY (`idea_id`) REFERENCES `lean_idea` (`id`);

--
-- Constraints for table `lean_datapoint`
--
ALTER TABLE `lean_datapoint`
  ADD CONSTRAINT `lean_datapoint_measure_id_4c8fb4c9_fk_lean_measure_id` FOREIGN KEY (`measure_id`) REFERENCES `lean_measure` (`id`);

--
-- Constraints for table `lean_learning`
--
ALTER TABLE `lean_learning`
  ADD CONSTRAINT `lean_learning_idea_id_305fc1b8_fk_lean_idea_id` FOREIGN KEY (`idea_id`) REFERENCES `lean_idea` (`id`);

--
-- Constraints for table `lean_measure`
--
ALTER TABLE `lean_measure`
  ADD CONSTRAINT `lean_measure_product_id_2152f886_fk_lean_product_id` FOREIGN KEY (`product_id`) REFERENCES `lean_product` (`id`);

--
-- Constraints for table `lean_product`
--
ALTER TABLE `lean_product`
  ADD CONSTRAINT `lean_product_build_id_542f3ec0_fk_lean_build_id` FOREIGN KEY (`build_id`) REFERENCES `lean_build` (`id`);

--
-- Constraints for table `ledger_journalitem`
--
ALTER TABLE `ledger_journalitem`
  ADD CONSTRAINT `ledger_journalitem_account_id_d8390bec_fk_ledger_account_id` FOREIGN KEY (`account_id`) REFERENCES `ledger_account` (`id`),
  ADD CONSTRAINT `ledger_journalitem_journal_entry_id_1a4bc7e4_fk_ledger_jo` FOREIGN KEY (`journal_entry_id`) REFERENCES `ledger_journalentry` (`id`);

--
-- Constraints for table `likeunlike_like`
--
ALTER TABLE `likeunlike_like`
  ADD CONSTRAINT `likeunlike_like_content_type_id_c9ca64a6_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `likeunlike_like_sender_id_f7fdcc97_fk_auth_user_id` FOREIGN KEY (`sender_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `myzone_talkcontent_tag`
--
ALTER TABLE `myzone_talkcontent_tag`
  ADD CONSTRAINT `myzone_talkcontent_t_talkcontent_id_4ce38da9_fk_myzone_ta` FOREIGN KEY (`talkcontent_id`) REFERENCES `myzone_talkcontent` (`id`),
  ADD CONSTRAINT `myzone_talkcontent_t_talktags_id_957fd713_fk_myzone_ta` FOREIGN KEY (`talktags_id`) REFERENCES `myzone_talktags` (`id`);

--
-- Constraints for table `portfolio_portfolio`
--
ALTER TABLE `portfolio_portfolio`
  ADD CONSTRAINT `portfolio_portfolio_author_id_36e97922_fk_auth_user_id` FOREIGN KEY (`author_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `portfolio_portfolio_basemodel_ptr_id_8531c54c_fk_portfolio` FOREIGN KEY (`basemodel_ptr_id`) REFERENCES `portfolio_basemodel` (`id`);

--
-- Constraints for table `post_media_channel`
--
ALTER TABLE `post_media_channel`
  ADD CONSTRAINT `post_media_channel_channel_id_fk` FOREIGN KEY (`channel_id`) REFERENCES `post_media_digitalchannel` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `post_media_channel_for_market_id_f1bf43fc_fk_post_medi` FOREIGN KEY (`for_market_id`) REFERENCES `post_media_market` (`id`),
  ADD CONSTRAINT `post_media_channel_funnel_stage_id_fk` FOREIGN KEY (`funnel_stage_id`) REFERENCES `post_media_funnelstage` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `post_media_channel_kategori_biaya_fk` FOREIGN KEY (`kategori_biaya_id`) REFERENCES `post_media_biaya` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `post_media_channelperformance`
--
ALTER TABLE `post_media_channelperformance`
  ADD CONSTRAINT `post_media_channelpe_channel_id_d7768791_fk_post_medi` FOREIGN KEY (`channel_id`) REFERENCES `post_media_channel` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
