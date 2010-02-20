-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Sat Feb 20 13:49:51 2010
-- 


BEGIN TRANSACTION;

--
-- Table: config
--
DROP TABLE config;

CREATE TABLE config (
  name varchar(255) NOT NULL,
  value varchar(255),
  description varchar(255),
  PRIMARY KEY (name)
);

--
-- Table: links
--
DROP TABLE links;

CREATE TABLE links (
  link_id INTEGER PRIMARY KEY NOT NULL,
  url character varying(255),
  name character varying(255),
  description character varying(255)
);

--
-- Table: pages
--
DROP TABLE pages;

CREATE TABLE pages (
  page_id INTEGER PRIMARY KEY NOT NULL,
  name character varying(255),
  body text,
  display_sidebar smallint NOT NULL DEFAULT '1',
  display_in_drawer smallint NOT NULL DEFAULT '1'
);

--
-- Table: tags
--
DROP TABLE tags;

CREATE TABLE tags (
  tag_id INTEGER PRIMARY KEY NOT NULL,
  name character varying(255)
);

--
-- Table: users
--
DROP TABLE users;

CREATE TABLE users (
  user_id INTEGER PRIMARY KEY NOT NULL,
  username character varying(255),
  password character varying(255),
  website character varying(255),
  email character varying(255),
  created_at datetime DEFAULT 'now()'
);

--
-- Table: articles
--
DROP TABLE articles;

CREATE TABLE articles (
  article_id INTEGER PRIMARY KEY NOT NULL,
  subject character varying(255),
  body text,
  created_at datetime,
  updated_at datetime,
  user_id integer(4)
);

CREATE INDEX articles_idx_user_id ON articles (user_id);

--
-- Table: comments
--
DROP TABLE comments;

CREATE TABLE comments (
  comment_id INTEGER PRIMARY KEY NOT NULL,
  name character varying(255),
  email character varying(255),
  url character varying(255),
  body text,
  remote_ip character varying(32),
  created_at datetime DEFAULT 'now()',
  article_id integer(4),
  user_id integer(4)
);

CREATE INDEX comments_idx_article_id ON comments (article_id);

CREATE INDEX comments_idx_user_id ON comments (user_id);

--
-- Table: tags_articles
--
DROP TABLE tags_articles;

CREATE TABLE tags_articles (
  tag_article_id INTEGER PRIMARY KEY NOT NULL,
  tag_id integer(4),
  article_id integer(4)
);

CREATE INDEX tags_articles_idx_article_id ON tags_articles (article_id);

CREATE INDEX tags_articles_idx_tag_id ON tags_articles (tag_id);

COMMIT;
