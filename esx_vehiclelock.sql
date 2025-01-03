CREATE TABLE IF NOT EXISTS `user_vehicles` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `owner` VARCHAR(50) NOT NULL,       
    `plate` VARCHAR(8) NOT NULL,        
    `got` ENUM('true', 'false') NOT NULL DEFAULT 'false', -- Si le joueur possède la clé
    `NB` INT(11) NOT NULL DEFAULT 1,
    PRIMARY KEY (`id`),
    UNIQUE KEY `plate` (`plate`)
);

CREATE TABLE IF NOT EXISTS `player_keys` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `player_id` INT(11) NOT NULL,       
    `vehicle_plate` VARCHAR(8) NOT NULL, 
    `key_status` ENUM('own', 'loaned') NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`player_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`vehicle_plate`) REFERENCES `user_vehicles`(`plate`) ON DELETE CASCADE
);
