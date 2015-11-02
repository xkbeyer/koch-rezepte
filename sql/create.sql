CREATE SCHEMA `koch-rezepte` ;
CREATE TABLE `koch-rezepte`.`rezept` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Identifier',
  `description` VARCHAR(45) NULL COMMENT 'Short description of the receive',
  `instructions` LONGTEXT NULL COMMENT 'The receive (instruction) of this one.',
  `picture` BLOB NULL COMMENT 'Optionally uploadable pciture of the result.',
  `ingredients` INT UNSIGNED NOT NULL COMMENT 'Id to the list of ingredients.',
  PRIMARY KEY (`idrezept`)  COMMENT '')
COMMENT = 'Contains the cooking receives ';

CREATE TABLE `koch-rezepte`.`zutaten` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '',
  `quantity` INT NOT NULL COMMENT 'How much',
  `unit` ENUM('pcs', 'l', 'gr') NULL COMMENT 'Unit, can  be a piece, volume in litre or the weigth in gramm.',
  `name` VARCHAR(45) NOT NULL COMMENT 'Name of this ingredient',
  PRIMARY KEY (`idzutaten`)  COMMENT '',
  UNIQUE INDEX `name_UNIQUE` (`name` ASC)  COMMENT '')
COMMENT = 'List of ingredients';
