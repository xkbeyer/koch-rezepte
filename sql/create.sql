CREATE SCHEMA `koch-rezepte` ;

CREATE TABLE `koch-rezepte`.`rezept` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Identifier',
  `name` varchar(45) NOT NULL,
  `description` varchar(45) DEFAULT NULL COMMENT 'Short description of the receive',
  `instructions` longtext COMMENT 'The receive (instruction) of this one.',
  `picture` blob COMMENT 'Optionally uploadable pciture of the result.',
  `ingredients` int(10) unsigned NOT NULL COMMENT 'Id to the list of ingredients.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='Contains the cooking receives ';

CREATE TABLE `koch-rezepte`.`zutaten` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `unit` enum('pcs','l','gr') DEFAULT NULL COMMENT 'Unit, can  be a piece, volume in litre or the weigth in gramm.',
  `name` varchar(45) NOT NULL COMMENT 'Name of this ingredient',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='List of ingredients';

CREATE TABLE `koch-rezepte`.`zutaten_rezept` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rezept-id` int(11) NOT NULL,
  `zutat-id` int(11) NOT NULL,
  `quantity` decimal(10,0) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='Link between the recipe and thier indredients';

CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `ingredients` AS
    SELECT 
        `zutaten_rezept`.`quantity` AS `quantity`,
        `zutaten`.`unit` AS `unit`,
        `zutaten`.`name` AS `name`
    FROM
        ((`rezept`
        JOIN `zutaten_rezept` ON ((`rezept`.`id` = `zutaten_rezept`.`rezept-id`)))
        JOIN `zutaten` ON ((`zutaten`.`id` = `zutaten_rezept`.`rezept-id`)))
