-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Fri Jun 12 07:16:38 2009
-- 
SET foreign_key_checks=0;

DROP TABLE IF EXISTS `articles`;

--
-- Table: `articles`
--
CREATE TABLE `articles` (
  `article_id` integer NOT NULL auto_increment,
  `subject` character varying(255),
  `body` text,
  `created_at` datetime,
  `updated_at` datetime,
  `user_id` integer(4),
  INDEX articles_idx_user_id (`user_id`),
  PRIMARY KEY (`article_id`),
  CONSTRAINT `articles_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `comments`;

--
-- Table: `comments`
--
CREATE TABLE `comments` (
  `comment_id` integer NOT NULL auto_increment,
  `name` character varying(255),
  `email` character varying(255),
  `url` character varying(255),
  `comment` text,
  `created_at` timestamp DEFAULT now(),
  `article_id` integer(4),
  INDEX comments_idx_article_id (`article_id`),
  PRIMARY KEY (`comment_id`),
  CONSTRAINT `comments_fk_article_id` FOREIGN KEY (`article_id`) REFERENCES `articles` (`article_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `links`;

--
-- Table: `links`
--
CREATE TABLE `links` (
  `link_id` integer NOT NULL auto_increment,
  `url` character varying(255),
  `name` character varying(255),
  `description` character varying(255),
  PRIMARY KEY (`link_id`)
);

DROP TABLE IF EXISTS `pages`;

--
-- Table: `pages`
--
CREATE TABLE `pages` (
  `page_id` integer NOT NULL auto_increment,
  `name` character varying(255),
  `body` text,
  `display_sidebar` smallint NOT NULL DEFAULT '1',
  `display_in_drawer` smallint NOT NULL DEFAULT '1',
  PRIMARY KEY (`page_id`)
);

DROP TABLE IF EXISTS `tags`;

--
-- Table: `tags`
--
CREATE TABLE `tags` (
  `tag_id` integer NOT NULL auto_increment,
  `name` character varying(255),
  PRIMARY KEY (`tag_id`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `tags_articles`;

--
-- Table: `tags_articles`
--
CREATE TABLE `tags_articles` (
  `tag_article_id` integer NOT NULL auto_increment,
  `tag_id` integer(4),
  `article_id` integer(4),
  INDEX tags_articles_idx_article_id (`article_id`),
  INDEX tags_articles_idx_tag_id (`tag_id`),
  PRIMARY KEY (`tag_article_id`),
  CONSTRAINT `tags_articles_fk_article_id` FOREIGN KEY (`article_id`) REFERENCES `articles` (`article_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tags_articles_fk_tag_id` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`tag_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `users`;

--
-- Table: `users`
--
CREATE TABLE `users` (
  `user_id` integer NOT NULL auto_increment,
  `username` character varying(255),
  `password` character varying(255),
  `website` character varying(255),
  `email` character varying(255),
  `created_at` timestamp DEFAULT now(),
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB;

SET foreign_key_checks=1;

