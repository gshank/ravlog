-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Tue Jun  9 18:29:56 2009
-- 
SET foreign_key_checks=0;

DROP TABLE IF EXISTS `articles`;

--
-- Table: `articles`
--
CREATE TABLE `articles` (
  `id` integer NOT NULL auto_increment,
  `subject` character varying(255),
  `body` text,
  `created_at` datetime,
  `updated_at` datetime,
  `user_id` integer(4),
  INDEX articles_idx_user_id (`user_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `articles_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `categories`;

--
-- Table: `categories`
--
CREATE TABLE `categories` (
  `id` integer NOT NULL auto_increment,
  `name` character varying(255),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `categories_articles`;

--
-- Table: `categories_articles`
--
CREATE TABLE `categories_articles` (
  `id` integer NOT NULL auto_increment,
  `category_id` integer(4),
  `article_id` integer(4),
  INDEX categories_articles_idx_article_id (`article_id`),
  INDEX categories_articles_idx_category_id (`category_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `categories_articles_fk_article_id` FOREIGN KEY (`article_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `categories_articles_fk_category_id` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `comments`;

--
-- Table: `comments`
--
CREATE TABLE `comments` (
  `id` integer NOT NULL auto_increment,
  `name` character varying(255),
  `email` character varying(255),
  `url` character varying(255),
  `comment` text,
  `created_at` timestamp DEFAULT now(),
  `article_id` integer(4),
  INDEX comments_idx_article_id (`article_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `comments_fk_article_id` FOREIGN KEY (`article_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `links`;

--
-- Table: `links`
--
CREATE TABLE `links` (
  `id` integer NOT NULL auto_increment,
  `url` character varying(255),
  `name` character varying(255),
  `description` character varying(255),
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `pages`;

--
-- Table: `pages`
--
CREATE TABLE `pages` (
  `id` integer NOT NULL auto_increment,
  `name` character varying(255),
  `body` text,
  `display_sidebar` smallint NOT NULL DEFAULT '1',
  `display_in_drawer` smallint NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `users`;

--
-- Table: `users`
--
CREATE TABLE `users` (
  `id` integer NOT NULL auto_increment,
  `name` character varying(255),
  `password` character varying(255),
  `website` character varying(255),
  `email` character varying(255),
  `created_at` timestamp DEFAULT now(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

SET foreign_key_checks=1;

