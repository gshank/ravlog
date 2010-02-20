
DROP TABLE IF EXISTS `config`;

--
-- Table: `config`
--
CREATE TABLE `config` (
  `name` varchar(255) NOT NULL,
  `value` varchar(255),
  `description` varchar(255),
  PRIMARY KEY (`name`)
);

INSERT INTO `config` VALUES ('front page', 'blog', 'which page to display as front page');
