-- Snipz Admin Menu persistence.
--
-- The resource creates this table automatically on first start when oxmysql is
-- available, so importing this file is optional. It is provided for servers that
-- prefer to provision schema manually.
--
-- Bans, warnings, notes and staff tags are each stored as a single JSON document
-- in one row (`store` = 'bans' | 'warnings' | 'notes' | 'staffTags').

CREATE TABLE IF NOT EXISTS `snipz_adminmenu_storage` (
    `store` VARCHAR(32) NOT NULL,
    `data` LONGTEXT NOT NULL,
    `updated_at` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`store`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
