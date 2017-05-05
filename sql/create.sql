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
  `quantity` decimal(6,3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='Link between the recipe and thier indredients';

USE `koch-rezepte`;
CREATE 
     OR REPLACE ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `ingredients` AS
    SELECT 
        `rezept`.`id` AS `rezept`,
        `rezept`.`name` AS `rezeptname`,
        `zutaten_rezept`.`quantity` AS `quantity`,
        `zutaten`.`unit` AS `unit`,
        `zutaten`.`name` AS `name`
    FROM
        ((`rezept`
        JOIN `zutaten_rezept` ON ((`rezept`.`id` = `zutaten_rezept`.`rezept-id`)))
        JOIN `zutaten` ON ((`zutaten`.`id` = `zutaten_rezept`.`zutat-id`)));

USE `koch-rezepte`;
DROP procedure IF EXISTS `add_ingredient`;

DELIMITER $$
USE `koch-rezepte`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_ingredient`(IN rezept_name varchar(255), in qty float,in unit varchar(10), in ingredient varchar(255), out error_code int)
BEGIN

	set error_code = 0;

	set @rezept_id = (select id from `koch-rezepte`.`rezept` where `name` = rezept_name);
	if( @rezept_id is null ) then 
		set error_code = -1;
	else
		set @zid = (select id from `koch-rezepte`.`zutaten` where `name` = ingredient);
		if( @zid is NULL) then
			insert into `koch-rezepte`.`zutaten` (`unit`,`name`) values (unit, ingredient);
			set @zid = LAST_INSERT_ID();
		end if;
		set @exist = (select id from `koch-rezepte`.`zutaten_rezept` where `rezept-id` = @rezept_id and `zutat-id` = @zid);
		if( @exist is null ) then 
			insert into `koch-rezepte`.`zutaten_rezept` (`rezept-id`, `zutat-id`, `quantity`) values (@rezept_id, @zid, qty);
		else
			set error_code = -2;
		end if;
	end if;
END$$

DELIMITER ;

DROP procedure IF EXISTS `del_ingredient`;

DELIMITER $$
USE `koch-rezepte`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `del_ingredient`(`rid` INT, `item` VARCHAR(50))
	RETURNS int(11)
	LANGUAGE SQL
	DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT 'Deletes an ingredient from a recipe'
BEGIN
	set @zid = (select id from `koch-rezepte`.`zutaten` where `name` = item);
	if( @zid is NULL) then
		return -1;
	else
		set @del_id = (select id from `koch-rezepte`.`zutaten_rezept` where `rezept-id` = rid and `zutat-id` = @zid);
		if( @del_id is null ) then 
			return -2;
		else
			delete from `koch-rezepte`.`zutaten_rezept` where `id` = @del_id;
		end if;
	end if;
	return 0 ;

END$$

DELIMITER ;



