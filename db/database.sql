/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 100316
 Source Host           : localhost:3306
 Source Schema         : webflix

 Target Server Type    : MySQL
 Target Server Version : 100316
 File Encoding         : 65001

 Date: 20/01/2021 16:44:59
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for actor_table
-- ----------------------------
DROP TABLE IF EXISTS `actor_table`;
CREATE TABLE `actor_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `media_id` int NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `born` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `height` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `type` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `bio` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `UNIQ_D2AD64D2989D9B62`(`slug`) USING BTREE,
  INDEX `IDX_D2AD64D2EA9FDD75`(`media_id`) USING BTREE,
  CONSTRAINT `FK_D2AD64D2EA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of actor_table
-- ----------------------------
INSERT INTO `actor_table` VALUES (1, 6, 'Vlad', '111', '111', 'Actor', '111', 'vlad');

-- ----------------------------
-- Table structure for category_table
-- ----------------------------
DROP TABLE IF EXISTS `category_table`;
CREATE TABLE `category_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `media_id` int NULL DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `position` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `IDX_1E1AC00FEA9FDD75`(`media_id`) USING BTREE,
  CONSTRAINT `FK_1E1AC00FEA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of category_table
-- ----------------------------

-- ----------------------------
-- Table structure for channel_table
-- ----------------------------
DROP TABLE IF EXISTS `channel_table`;
CREATE TABLE `channel_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `media_id` int NULL DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `description` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `tags` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `rating` double NOT NULL,
  `classification` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `website` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `views` int NOT NULL,
  `shares` int NOT NULL,
  `created` datetime(0) NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `featured` tinyint(1) NOT NULL,
  `playas` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `comment` tinyint(1) NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `label` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `sublabel` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `UNIQ_410887DE989D9B62`(`slug`) USING BTREE,
  INDEX `IDX_410887DEEA9FDD75`(`media_id`) USING BTREE,
  CONSTRAINT `FK_410887DEEA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of channel_table
-- ----------------------------
INSERT INTO `channel_table` VALUES (1, 7, 'Game Channel', 'This is Game TV Channel', NULL, 0, NULL, NULL, 0, 0, '2021-01-19 09:29:17', 1, 1, '1', 1, 'game-channel', 'Game Channel', 'Game Channel');

-- ----------------------------
-- Table structure for channels_categories
-- ----------------------------
DROP TABLE IF EXISTS `channels_categories`;
CREATE TABLE `channels_categories`  (
  `channel_id` int NOT NULL,
  `category_id` int NOT NULL,
  PRIMARY KEY (`channel_id`, `category_id`) USING BTREE,
  INDEX `IDX_5D59DF4872F5A1AA`(`channel_id`) USING BTREE,
  INDEX `IDX_5D59DF4812469DE2`(`category_id`) USING BTREE,
  CONSTRAINT `FK_5D59DF4812469DE2` FOREIGN KEY (`category_id`) REFERENCES `category_table` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `FK_5D59DF4872F5A1AA` FOREIGN KEY (`channel_id`) REFERENCES `channel_table` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of channels_categories
-- ----------------------------

-- ----------------------------
-- Table structure for channels_countries
-- ----------------------------
DROP TABLE IF EXISTS `channels_countries`;
CREATE TABLE `channels_countries`  (
  `channel_id` int NOT NULL,
  `country_id` int NOT NULL,
  PRIMARY KEY (`channel_id`, `country_id`) USING BTREE,
  INDEX `IDX_2AB5073672F5A1AA`(`channel_id`) USING BTREE,
  INDEX `IDX_2AB50736F92F3E70`(`country_id`) USING BTREE,
  CONSTRAINT `FK_2AB5073672F5A1AA` FOREIGN KEY (`channel_id`) REFERENCES `channel_table` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `FK_2AB50736F92F3E70` FOREIGN KEY (`country_id`) REFERENCES `country_table` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of channels_countries
-- ----------------------------

-- ----------------------------
-- Table structure for comment_table
-- ----------------------------
DROP TABLE IF EXISTS `comment_table`;
CREATE TABLE `comment_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `poster_id` int NULL DEFAULT NULL,
  `channel_id` int NULL DEFAULT NULL,
  `user_id` int NOT NULL,
  `content` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `created` datetime(0) NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `IDX_5FB317B75BB66C05`(`poster_id`) USING BTREE,
  INDEX `IDX_5FB317B772F5A1AA`(`channel_id`) USING BTREE,
  INDEX `IDX_5FB317B7A76ED395`(`user_id`) USING BTREE,
  CONSTRAINT `FK_5FB317B75BB66C05` FOREIGN KEY (`poster_id`) REFERENCES `poster_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_5FB317B772F5A1AA` FOREIGN KEY (`channel_id`) REFERENCES `channel_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_5FB317B7A76ED395` FOREIGN KEY (`user_id`) REFERENCES `fos_user_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of comment_table
-- ----------------------------

-- ----------------------------
-- Table structure for country_table
-- ----------------------------
DROP TABLE IF EXISTS `country_table`;
CREATE TABLE `country_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `media_id` int NULL DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `IDX_51C99AACEA9FDD75`(`media_id`) USING BTREE,
  CONSTRAINT `FK_51C99AACEA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of country_table
-- ----------------------------

-- ----------------------------
-- Table structure for device_table
-- ----------------------------
DROP TABLE IF EXISTS `device_table`;
CREATE TABLE `device_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `token` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of device_table
-- ----------------------------

-- ----------------------------
-- Table structure for episode_table
-- ----------------------------
DROP TABLE IF EXISTS `episode_table`;
CREATE TABLE `episode_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `season_id` int NULL DEFAULT NULL,
  `thumbnail_id` int NULL DEFAULT NULL,
  `media_id` int NULL DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `description` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `duration` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `playas` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `downloadas` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL,
  `position` int NOT NULL,
  `downloads` int NOT NULL,
  `views` int NOT NULL,
  `created` datetime(0) NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `UNIQ_CD237912989D9B62`(`slug`) USING BTREE,
  INDEX `IDX_CD2379124EC001D1`(`season_id`) USING BTREE,
  INDEX `IDX_CD237912FDFF2E92`(`thumbnail_id`) USING BTREE,
  INDEX `IDX_CD237912EA9FDD75`(`media_id`) USING BTREE,
  CONSTRAINT `FK_CD2379124EC001D1` FOREIGN KEY (`season_id`) REFERENCES `season_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_CD237912EA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_CD237912FDFF2E92` FOREIGN KEY (`thumbnail_id`) REFERENCES `media_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of episode_table
-- ----------------------------

-- ----------------------------
-- Table structure for feature_table
-- ----------------------------
DROP TABLE IF EXISTS `feature_table`;
CREATE TABLE `feature_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `url` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `video_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `position` int NULL DEFAULT NULL,
  `created` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of feature_table
-- ----------------------------
INSERT INTO `feature_table` VALUES (2, 'AdinRoss', 'https://static-cdn.jtvnw.net/jtv_user_pictures/10c197cb-295f-4d40-8a6c-26a0a5da22ee-profile_image-300x300.png', NULL, 2, '2021-01-20 09:21:20');
INSERT INTO `feature_table` VALUES (3, 'mrstiventc', 'https://static-cdn.jtvnw.net/jtv_user_pictures/f2ffe190-8a7d-4ceb-aa12-1f1afe2f1f76-profile_image-300x300.png', NULL, 3, '2021-01-20 09:21:23');

-- ----------------------------
-- Table structure for fos_user_table
-- ----------------------------
DROP TABLE IF EXISTS `fos_user_table`;
CREATE TABLE `fos_user_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `media_id` int NULL DEFAULT NULL,
  `username` varchar(180) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `username_canonical` varchar(180) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(180) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `email_canonical` varchar(180) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `salt` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `last_login` datetime(0) NULL DEFAULT NULL,
  `locked` tinyint(1) NOT NULL,
  `expired` tinyint(1) NOT NULL,
  `confirmation_token` varchar(180) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `password_requested_at` datetime(0) NULL DEFAULT NULL,
  `roles` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '(DC2Type:array)',
  `credentials_expired` tinyint(1) NOT NULL,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `type` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `token` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `theme` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `UNIQ_C3D4D4BD92FC23A8`(`username_canonical`) USING BTREE,
  UNIQUE INDEX `UNIQ_C3D4D4BDA0D96FBF`(`email_canonical`) USING BTREE,
  UNIQUE INDEX `UNIQ_C3D4D4BDC05FB297`(`confirmation_token`) USING BTREE,
  INDEX `IDX_C3D4D4BDEA9FDD75`(`media_id`) USING BTREE,
  CONSTRAINT `FK_C3D4D4BDEA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fos_user_table
-- ----------------------------
INSERT INTO `fos_user_table` VALUES (1, NULL, 'ADMIN', 'admin', 'ADMIN', 'admin', 1, 'djtfgbufxr4gwk4k0gss4sgs4k48wc4', '$2y$13$djtfgbufxr4gwk4k0gss4ekodAwfJ3IP01OyKvMD.stoxgr6MMa2S', '2021-01-20 15:33:27', 0, 0, NULL, NULL, 'a:1:{i:0;s:10:\"ROLE_ADMIN\";}', 0, 'Video Status', 'email', NULL, NULL);
INSERT INTO `fos_user_table` VALUES (2, 4, 'Paul425@protonmail.com', 'paul425@protonmail.com', 'Paul425@protonmail.com', 'paul425@protonmail.com', 1, '8US.JCnRs8pXwTZSupzA6eb9owVyKM8mXB/VfAhebYg', '$2y$13$lyoUA19DwCUn8hlmh0lVG.HWCliyrgNRpdrH/.Ci8Lj4YHt2GqSky', '2021-01-15 19:31:12', 0, 0, NULL, NULL, 'a:0:{}', 0, 'Paul', 'email', NULL, 'dark');

-- ----------------------------
-- Table structure for gallery_table
-- ----------------------------
DROP TABLE IF EXISTS `gallery_table`;
CREATE TABLE `gallery_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `titre` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gallery_table
-- ----------------------------

-- ----------------------------
-- Table structure for game_table
-- ----------------------------
DROP TABLE IF EXISTS `game_table`;
CREATE TABLE `game_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `url` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `position` int NOT NULL,
  `created` datetime(0) NULL DEFAULT NULL,
  `viewer_count` int NOT NULL,
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `language` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `video_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of game_table
-- ----------------------------
INSERT INTO `game_table` VALUES (1, 'Call of Duty: Warzone', 'https://static-cdn.jtvnw.net/ttv-boxart/./Call%20of%20Duty:%20Warzone-500x500.jpg', 1, '2021-01-20 06:57:58', 22773, 'Use Code \"SWAGG\" in the Store | FaZe Swagg | !BLM !sub', 'en', 'https://www.twitch.tv/videos/814230487');
INSERT INTO `game_table` VALUES (2, 'VRChat', 'https://static-cdn.jtvnw.net/ttv-boxart/VRChat-500x500.jpg', 2, '2021-01-20 06:58:01', 26166, 'My dad has a date in VR | www.sodapoppin.shop Discount code: POOR', 'en', 'https://www.twitch.tv/videos/876339259');
INSERT INTO `game_table` VALUES (3, 'Grand Theft Auto V', 'https://static-cdn.jtvnw.net/ttv-boxart/Grand%20Theft%20Auto%20V-500x500.jpg', 3, '2021-01-20 06:58:04', 29066, 'GRIZZ RP !sub !prime', 'en', 'https://www.twitch.tv/videos/30511676');

-- ----------------------------
-- Table structure for genre_table
-- ----------------------------
DROP TABLE IF EXISTS `genre_table`;
CREATE TABLE `genre_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `position` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of genre_table
-- ----------------------------
INSERT INTO `genre_table` VALUES (1, 'NewGenre', 1);
INSERT INTO `genre_table` VALUES (2, '111', 2);

-- ----------------------------
-- Table structure for items_table
-- ----------------------------
DROP TABLE IF EXISTS `items_table`;
CREATE TABLE `items_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `poster_id` int NULL DEFAULT NULL,
  `channel_id` int NULL DEFAULT NULL,
  `user_id` int NOT NULL,
  `position` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `IDX_F2F545FD5BB66C05`(`poster_id`) USING BTREE,
  INDEX `IDX_F2F545FD72F5A1AA`(`channel_id`) USING BTREE,
  INDEX `IDX_F2F545FDA76ED395`(`user_id`) USING BTREE,
  CONSTRAINT `FK_F2F545FD5BB66C05` FOREIGN KEY (`poster_id`) REFERENCES `poster_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_F2F545FD72F5A1AA` FOREIGN KEY (`channel_id`) REFERENCES `channel_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_F2F545FDA76ED395` FOREIGN KEY (`user_id`) REFERENCES `fos_user_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of items_table
-- ----------------------------

-- ----------------------------
-- Table structure for language_table
-- ----------------------------
DROP TABLE IF EXISTS `language_table`;
CREATE TABLE `language_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `media_id` int NULL DEFAULT NULL,
  `language` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `position` int NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `IDX_89718B17EA9FDD75`(`media_id`) USING BTREE,
  CONSTRAINT `FK_89718B17EA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of language_table
-- ----------------------------

-- ----------------------------
-- Table structure for livechannel_table
-- ----------------------------
DROP TABLE IF EXISTS `livechannel_table`;
CREATE TABLE `livechannel_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `position` int NULL DEFAULT NULL,
  `url` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `video_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `created` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of livechannel_table
-- ----------------------------
INSERT INTO `livechannel_table` VALUES (4, 'yoda', 'ACHE O N - FOMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM', 2, 'https://static-cdn.jtvnw.net/jtv_user_pictures/1e5bddcc-5b39-48a7-aa42-b945fd58a6e8-profile_banner-480.png', 'https://www.twitch.tv/yoda', '2021-01-20 15:21:57');
INSERT INTO `livechannel_table` VALUES (6, 'spygea', '楽しんでゲームしていきます', 3, 'https://static-cdn.jtvnw.net/jtv_user_pictures/add23377-6e8e-47db-9417-e449aedf2e55-profile_banner-480.png', 'https://www.twitch.tv/spygea', '2021-01-20 15:22:03');
INSERT INTO `livechannel_table` VALUES (7, 'mckytv', 'Streamzeiten: spontan | streamfreie Tage: spontan ', 4, 'https://static-cdn.jtvnw.net/jtv_user_pictures/62c632fa-9144-4932-9e6b-b254476a8cf7-profile_banner-480.jpeg', 'https://www.twitch.tv/mckytv', '2021-01-20 15:22:05');

-- ----------------------------
-- Table structure for media_table
-- ----------------------------
DROP TABLE IF EXISTS `media_table`;
CREATE TABLE `media_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `titre` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `url` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `type` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `extension` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `date` datetime(0) NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of media_table
-- ----------------------------
INSERT INTO `media_table` VALUES (1, 'logo.png', 'logo.png', 'image/png', 'png', '2019-11-19 22:21:00', 1);
INSERT INTO `media_table` VALUES (4, 'Paul', 'https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg', 'link', 'png', '2021-01-15 19:31:11', 1);
INSERT INTO `media_table` VALUES (5, 'Capture.PNG', 'afd2c8e25482186ebb0ff7c4fca5c7b9.PNG', 'image/png', 'PNG', '2021-01-18 08:05:47', 1);
INSERT INTO `media_table` VALUES (6, 'Capture.PNG', 'aa35fbc3650cdd402b6cbac55dc020f9.PNG', 'image/png', 'PNG', '2021-01-19 09:26:54', 1);
INSERT INTO `media_table` VALUES (7, 'Capture.PNG', 'c7e31033725a442268ffb0533f19edb4.PNG', 'image/png', 'PNG', '2021-01-19 09:29:17', 1);

-- ----------------------------
-- Table structure for medias_gallerys_table
-- ----------------------------
DROP TABLE IF EXISTS `medias_gallerys_table`;
CREATE TABLE `medias_gallerys_table`  (
  `gallery_id` int NOT NULL,
  `media_id` int NOT NULL,
  PRIMARY KEY (`gallery_id`, `media_id`) USING BTREE,
  INDEX `IDX_CC965DCE4E7AF8F`(`gallery_id`) USING BTREE,
  INDEX `IDX_CC965DCEEA9FDD75`(`media_id`) USING BTREE,
  CONSTRAINT `FK_CC965DCE4E7AF8F` FOREIGN KEY (`gallery_id`) REFERENCES `gallery_table` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `FK_CC965DCEEA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media_table` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of medias_gallerys_table
-- ----------------------------

-- ----------------------------
-- Table structure for pack_table
-- ----------------------------
DROP TABLE IF EXISTS `pack_table`;
CREATE TABLE `pack_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `discount` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `price` double NOT NULL,
  `duration` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pack_table
-- ----------------------------

-- ----------------------------
-- Table structure for poster_table
-- ----------------------------
DROP TABLE IF EXISTS `poster_table`;
CREATE TABLE `poster_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `cover_id` int NULL DEFAULT NULL,
  `posted_id` int NULL DEFAULT NULL,
  `trailer_id` int NULL DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `duration` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `playas` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `downloadas` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `type` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `tags` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `rating` double NOT NULL,
  `imdb` double NULL DEFAULT NULL,
  `classification` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `year` int NULL DEFAULT NULL,
  `description` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `downloads` int NOT NULL,
  `shares` int NOT NULL,
  `views` int NOT NULL,
  `created` datetime(0) NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `comment` tinyint(1) NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `label` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `sublabel` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `UNIQ_2AD2483989D9B62`(`slug`) USING BTREE,
  INDEX `IDX_2AD2483922726E9`(`cover_id`) USING BTREE,
  INDEX `IDX_2AD24832EC46446`(`posted_id`) USING BTREE,
  INDEX `IDX_2AD2483B6C04CFD`(`trailer_id`) USING BTREE,
  CONSTRAINT `FK_2AD24832EC46446` FOREIGN KEY (`posted_id`) REFERENCES `media_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_2AD2483922726E9` FOREIGN KEY (`cover_id`) REFERENCES `media_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_2AD2483B6C04CFD` FOREIGN KEY (`trailer_id`) REFERENCES `source_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of poster_table
-- ----------------------------

-- ----------------------------
-- Table structure for posters_genres
-- ----------------------------
DROP TABLE IF EXISTS `posters_genres`;
CREATE TABLE `posters_genres`  (
  `poster_id` int NOT NULL,
  `genre_id` int NOT NULL,
  PRIMARY KEY (`poster_id`, `genre_id`) USING BTREE,
  INDEX `IDX_888D8635BB66C05`(`poster_id`) USING BTREE,
  INDEX `IDX_888D8634296D31F`(`genre_id`) USING BTREE,
  CONSTRAINT `FK_888D8634296D31F` FOREIGN KEY (`genre_id`) REFERENCES `genre_table` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `FK_888D8635BB66C05` FOREIGN KEY (`poster_id`) REFERENCES `poster_table` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of posters_genres
-- ----------------------------

-- ----------------------------
-- Table structure for rate_table
-- ----------------------------
DROP TABLE IF EXISTS `rate_table`;
CREATE TABLE `rate_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `poster_id` int NULL DEFAULT NULL,
  `channel_id` int NULL DEFAULT NULL,
  `user_id` int NOT NULL,
  `value` int NOT NULL,
  `review` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `created` datetime(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `IDX_666996655BB66C05`(`poster_id`) USING BTREE,
  INDEX `IDX_6669966572F5A1AA`(`channel_id`) USING BTREE,
  INDEX `IDX_66699665A76ED395`(`user_id`) USING BTREE,
  CONSTRAINT `FK_666996655BB66C05` FOREIGN KEY (`poster_id`) REFERENCES `poster_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_6669966572F5A1AA` FOREIGN KEY (`channel_id`) REFERENCES `channel_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_66699665A76ED395` FOREIGN KEY (`user_id`) REFERENCES `fos_user_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of rate_table
-- ----------------------------

-- ----------------------------
-- Table structure for role_table
-- ----------------------------
DROP TABLE IF EXISTS `role_table`;
CREATE TABLE `role_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `poster_id` int NULL DEFAULT NULL,
  `actor_id` int NULL DEFAULT NULL,
  `role` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `position` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `IDX_1F567695BB66C05`(`poster_id`) USING BTREE,
  INDEX `IDX_1F5676910DAF24A`(`actor_id`) USING BTREE,
  CONSTRAINT `FK_1F5676910DAF24A` FOREIGN KEY (`actor_id`) REFERENCES `actor_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_1F567695BB66C05` FOREIGN KEY (`poster_id`) REFERENCES `poster_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of role_table
-- ----------------------------

-- ----------------------------
-- Table structure for season_table
-- ----------------------------
DROP TABLE IF EXISTS `season_table`;
CREATE TABLE `season_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `poster_id` int NULL DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `position` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `IDX_E11878995BB66C05`(`poster_id`) USING BTREE,
  CONSTRAINT `FK_E11878995BB66C05` FOREIGN KEY (`poster_id`) REFERENCES `poster_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of season_table
-- ----------------------------

-- ----------------------------
-- Table structure for settings_table
-- ----------------------------
DROP TABLE IF EXISTS `settings_table`;
CREATE TABLE `settings_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `media_id` int NULL DEFAULT NULL,
  `appname` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `appdescription` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `googleplay` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `privacypolicy` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `firebasekey` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `rewardedadmobid` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `banneradmobid` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `bannerfacebookid` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `bannertype` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `nativeadmobid` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `nativefacebookid` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `nativeitem` int NULL DEFAULT NULL,
  `nativetype` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `interstitialadmobid` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `interstitialfacebookid` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `interstitialtype` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `interstitialclick` int NULL DEFAULT NULL,
  `logo_id` int NULL DEFAULT NULL,
  `favicon_id` int NULL DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `subtitle` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `sitedescription` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `sitekeywords` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `login` tinyint(1) NOT NULL,
  `currency` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `cashaccount` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `paypalclientid` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `paypalclientsecret` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `paypalaccount` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `stripeapikey` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `manual` tinyint(1) NOT NULL,
  `stripe` tinyint(1) NOT NULL,
  `paypal` tinyint(1) NOT NULL,
  `gpay` tinyint(1) NOT NULL,
  `stripepublickey` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `paypalsandbox` tinyint(1) NOT NULL,
  `refundpolicy` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `faq` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `homebanner` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `homebannertype` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `moviebanner` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `moviebannertype` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `seriebanner` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `seriebannertype` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `channelbanner` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `channelbannertype` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `themoviedbkey` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `themoviedblang` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `header` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `IDX_4EF0C90FEA9FDD75`(`media_id`) USING BTREE,
  INDEX `IDX_4EF0C90FF98F144A`(`logo_id`) USING BTREE,
  INDEX `IDX_4EF0C90FD78119FD`(`favicon_id`) USING BTREE,
  CONSTRAINT `FK_4EF0C90FD78119FD` FOREIGN KEY (`favicon_id`) REFERENCES `media_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_4EF0C90FEA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_4EF0C90FF98F144A` FOREIGN KEY (`logo_id`) REFERENCES `media_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of settings_table
-- ----------------------------
INSERT INTO `settings_table` VALUES (2, 1, 'Flix App', 'Flix Application Movies App / Tv Seris / Live Channel - Demo app .', 'https://play.google.com/store/apps/details?id=com.virmana.flix', '<p>Your Privacy Policy Content</p>', 'AIzaSyCg77N96veclCZBruelCXqKY5MVJc1nUds', 'ca-app-pub-xxxxxxxxxxxxxxx/xxxxxxxxxxxxxxx', 'ca-app-pub-xxxxxxxxxxxxxxx/xxxxxxxxxxxxxxx', 'ca-app-pub-xxxxxxxxxxxxxxx/xxxxxxxxxxxxxxx', 'BOTH', 'ca-app-pub-xxxxxxxxxxxxxxx/xxxxxxxxxxxxxxx', 'ca-app-pub-xxxxxxxxxxxxxxx/xxxxxxxxxxxxxxx', 4, 'BOTH', 'ca-app-pub-xxxxxxxxxxxxxxx/xxxxxxxxxxxxxxx', 'XXXXXXXXXXXXXXXX_XXXXXXXXXXXXXXXX', 'BOTH', 5, NULL, NULL, 'Flix', 'Free Movies and Series and channel tv', 'Free Movies and Series and channel tv', 'movies,tv series,channel,tv', 1, 'USD', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, 0, '<p>Your Refund Policy Content</p>', '<p>Your FAQ Policy Content</p>', NULL, 'none', NULL, 'none', NULL, 'none', NULL, 'none', '10471161c6c1b74f6278ff73bfe95982', 'en', NULL);

-- ----------------------------
-- Table structure for slide_table
-- ----------------------------
DROP TABLE IF EXISTS `slide_table`;
CREATE TABLE `slide_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `poster_id` int NULL DEFAULT NULL,
  `channel_id` int NULL DEFAULT NULL,
  `genre_id` int NULL DEFAULT NULL,
  `category_id` int NULL DEFAULT NULL,
  `media_id` int NULL DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `url` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `type` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `position` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `IDX_77A059655BB66C05`(`poster_id`) USING BTREE,
  INDEX `IDX_77A0596572F5A1AA`(`channel_id`) USING BTREE,
  INDEX `IDX_77A059654296D31F`(`genre_id`) USING BTREE,
  INDEX `IDX_77A0596512469DE2`(`category_id`) USING BTREE,
  INDEX `IDX_77A05965EA9FDD75`(`media_id`) USING BTREE,
  CONSTRAINT `FK_77A0596512469DE2` FOREIGN KEY (`category_id`) REFERENCES `category_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_77A059654296D31F` FOREIGN KEY (`genre_id`) REFERENCES `genre_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_77A059655BB66C05` FOREIGN KEY (`poster_id`) REFERENCES `poster_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_77A0596572F5A1AA` FOREIGN KEY (`channel_id`) REFERENCES `channel_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_77A05965EA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of slide_table
-- ----------------------------
INSERT INTO `slide_table` VALUES (1, NULL, NULL, NULL, NULL, 5, 'TmV3U2xpZGU=', NULL, '5', 1);

-- ----------------------------
-- Table structure for source_table
-- ----------------------------
DROP TABLE IF EXISTS `source_table`;
CREATE TABLE `source_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `media_id` int NULL DEFAULT NULL,
  `poster_id` int NULL DEFAULT NULL,
  `episode_id` int NULL DEFAULT NULL,
  `channel_id` int NULL DEFAULT NULL,
  `type` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `url` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `quality` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `size` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `kind` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `external` tinyint(1) NULL DEFAULT NULL,
  `premium` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `IDX_6F215479EA9FDD75`(`media_id`) USING BTREE,
  INDEX `IDX_6F2154795BB66C05`(`poster_id`) USING BTREE,
  INDEX `IDX_6F215479362B62A0`(`episode_id`) USING BTREE,
  INDEX `IDX_6F21547972F5A1AA`(`channel_id`) USING BTREE,
  CONSTRAINT `FK_6F215479362B62A0` FOREIGN KEY (`episode_id`) REFERENCES `episode_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_6F2154795BB66C05` FOREIGN KEY (`poster_id`) REFERENCES `poster_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_6F21547972F5A1AA` FOREIGN KEY (`channel_id`) REFERENCES `channel_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_6F215479EA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of source_table
-- ----------------------------

-- ----------------------------
-- Table structure for subscription_table
-- ----------------------------
DROP TABLE IF EXISTS `subscription_table`;
CREATE TABLE `subscription_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `media_id` int NULL DEFAULT NULL,
  `created` datetime(0) NOT NULL,
  `duration` int NOT NULL,
  `method` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `pack` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `infos` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `status` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `currency` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `price` double NOT NULL,
  `transaction` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `started` datetime(0) NULL DEFAULT NULL,
  `expired` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `IDX_C118E35A76ED395`(`user_id`) USING BTREE,
  INDEX `IDX_C118E35EA9FDD75`(`media_id`) USING BTREE,
  CONSTRAINT `FK_C118E35A76ED395` FOREIGN KEY (`user_id`) REFERENCES `fos_user_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_C118E35EA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of subscription_table
-- ----------------------------

-- ----------------------------
-- Table structure for subtitle_table
-- ----------------------------
DROP TABLE IF EXISTS `subtitle_table`;
CREATE TABLE `subtitle_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `media_id` int NULL DEFAULT NULL,
  `poster_id` int NULL DEFAULT NULL,
  `episode_id` int NULL DEFAULT NULL,
  `language_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `IDX_79585A84EA9FDD75`(`media_id`) USING BTREE,
  INDEX `IDX_79585A845BB66C05`(`poster_id`) USING BTREE,
  INDEX `IDX_79585A84362B62A0`(`episode_id`) USING BTREE,
  INDEX `IDX_79585A8482F1BAF4`(`language_id`) USING BTREE,
  CONSTRAINT `FK_79585A84362B62A0` FOREIGN KEY (`episode_id`) REFERENCES `episode_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_79585A845BB66C05` FOREIGN KEY (`poster_id`) REFERENCES `poster_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_79585A8482F1BAF4` FOREIGN KEY (`language_id`) REFERENCES `language_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_79585A84EA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media_table` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of subtitle_table
-- ----------------------------

-- ----------------------------
-- Table structure for support_table
-- ----------------------------
DROP TABLE IF EXISTS `support_table`;
CREATE TABLE `support_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `subject` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `message` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `created` datetime(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of support_table
-- ----------------------------

-- ----------------------------
-- Table structure for version_table
-- ----------------------------
DROP TABLE IF EXISTS `version_table`;
CREATE TABLE `version_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `features` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `code` int NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of version_table
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
