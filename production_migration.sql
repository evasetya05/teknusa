-- Production Migration Script for post_media app
-- Run this in production MySQL database

-- Create new tables
CREATE TABLE IF NOT EXISTS `post_media_akun` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    `name` varchar(20) NULL UNIQUE, 
    `description` longtext NULL
);

CREATE TABLE IF NOT EXISTS `post_media_biaya` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    `name` varchar(20) NULL UNIQUE, 
    `description` longtext NULL
);

CREATE TABLE IF NOT EXISTS `post_media_digitalchannel` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    `name` varchar(20) NULL UNIQUE, 
    `description` longtext NULL
);

CREATE TABLE IF NOT EXISTS `post_media_funnelstage` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    `name` varchar(20) NULL UNIQUE, 
    `description` longtext NULL
);

-- Add amount column if it doesn't exist
ALTER TABLE `post_media_channel` 
ADD COLUMN IF NOT EXISTS `amount` numeric(12, 2) NULL;

-- Modify name columns to allow NULL
ALTER TABLE `post_media_market` 
MODIFY `name` varchar(20) NULL;

-- Rename columns and add foreign keys
-- Note: These operations need to be done carefully with existing data

-- First, make the columns nullable if they aren't already
ALTER TABLE `post_media_channel` 
MODIFY `akun_id` bigint NULL,
MODIFY `for_market_id` bigint NULL, 
MODIFY `channel_id` bigint NULL,
MODIFY `funnel_stage_id` bigint NULL,
MODIFY `kategori_biaya_id` bigint NULL;

-- Add foreign key constraints
ALTER TABLE `post_media_channel` 
ADD CONSTRAINT IF NOT EXISTS `post_media_channel_akun_id_f0e9ea03_fk_post_media_akun_id` 
FOREIGN KEY (`akun_id`) REFERENCES `post_media_akun` (`id`);

ALTER TABLE `post_media_channel` 
ADD CONSTRAINT IF NOT EXISTS `post_media_channel_kategori_biaya_id_ab7fd9d6_fk_post_medi` 
FOREIGN KEY (`kategori_biaya_id`) REFERENCES `post_media_biaya` (`id`);

ALTER TABLE `post_media_channel` 
ADD CONSTRAINT IF NOT EXISTS `post_media_channel_channel_id_743d7c10_fk_post_medi` 
FOREIGN KEY (`channel_id`) REFERENCES `post_media_digitalchannel` (`id`);

ALTER TABLE `post_media_channel` 
ADD CONSTRAINT IF NOT EXISTS `post_media_channel_funnel_stage_id_4e511dd9_fk_post_medi` 
FOREIGN KEY (`funnel_stage_id`) REFERENCES `post_media_funnelstage` (`id`);
