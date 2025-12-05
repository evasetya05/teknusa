-- Production Data Insertion Script
-- Run this after the migration script

-- Insert default Akun data
INSERT IGNORE INTO `post_media_akun` (`name`, `description`) VALUES
('Instagram Business', 'Instagram Business account'),
('LinkedIn Company', 'LinkedIn Company page'),
('TikTok Business', 'TikTok Business account'),
('Blog/Website', 'Blog or Website platform');

-- Insert default DigitalChannel data
INSERT IGNORE INTO `post_media_digitalchannel` (`name`, `description`) VALUES
('Instagram', 'Instagram platform'),
('LinkedIn', 'LinkedIn platform'),
('TikTok', 'TikTok platform'),
('Blog', 'Blog/Website platform');

-- Insert default FunnelStage data
INSERT IGNORE INTO `post_media_funnelstage` (`name`, `description`) VALUES
('Awareness', 'Top of funnel - awareness stage'),
('Consideration', 'Middle of funnel - consideration stage'),
('Conversion', 'Bottom of funnel - conversion stage'),
('Retention', 'Post-purchase - retention stage');

-- Insert default Biaya data
INSERT IGNORE INTO `post_media_biaya` (`name`, `description`) VALUES
('Iklan Berbayar', 'Paid advertising costs'),
('Produk Konten', 'Content production costs'),
('Tools & Software', 'Software and tools costs'),
('Lainnya', 'Other costs');

-- Update existing channel records to set default foreign key values
-- Set existing channels to use the first available foreign key (or NULL if none exist)
UPDATE `post_media_channel` 
SET 
    `akun_id` = (SELECT id FROM `post_media_akun` LIMIT 1),
    `channel_id` = (SELECT id FROM `post_media_digitalchannel` LIMIT 1),
    `funnel_stage_id` = (SELECT id FROM `post_media_funnelstage` LIMIT 1),
    `kategori_biaya_id` = (SELECT id FROM `post_media_biaya` LIMIT 1)
WHERE 
    `akun_id` IS NULL OR 
    `channel_id` IS NULL OR 
    `funnel_stage_id` IS NULL OR 
    `kategori_biaya_id` IS NULL;
