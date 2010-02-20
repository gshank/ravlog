-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Sat Feb 20 13:49:51 2010
-- 
--
-- Table: config
--
DROP TABLE "config" CASCADE;
CREATE TABLE "config" (
  "name" character varying(255) NOT NULL,
  "value" character varying(255),
  "description" character varying(255),
  PRIMARY KEY ("name")
);

--
-- Table: links
--
DROP TABLE "links" CASCADE;
CREATE TABLE "links" (
  "link_id" serial NOT NULL,
  "url" character varying(255),
  "name" character varying(255),
  "description" character varying(255),
  PRIMARY KEY ("link_id")
);

--
-- Table: pages
--
DROP TABLE "pages" CASCADE;
CREATE TABLE "pages" (
  "page_id" serial NOT NULL,
  "name" character varying(255),
  "body" text,
  "display_sidebar" smallint DEFAULT '1' NOT NULL,
  "display_in_drawer" smallint DEFAULT '1' NOT NULL,
  PRIMARY KEY ("page_id")
);

--
-- Table: tags
--
DROP TABLE "tags" CASCADE;
CREATE TABLE "tags" (
  "tag_id" serial NOT NULL,
  "name" character varying(255),
  PRIMARY KEY ("tag_id")
);

--
-- Table: users
--
DROP TABLE "users" CASCADE;
CREATE TABLE "users" (
  "user_id" serial NOT NULL,
  "username" character varying(255),
  "password" character varying(255),
  "website" character varying(255),
  "email" character varying(255),
  "created_at" timestamp DEFAULT 'now()',
  PRIMARY KEY ("user_id")
);

--
-- Table: articles
--
DROP TABLE "articles" CASCADE;
CREATE TABLE "articles" (
  "article_id" serial NOT NULL,
  "subject" character varying(255),
  "body" text,
  "created_at" timestamp,
  "updated_at" timestamp,
  "user_id" smallint,
  PRIMARY KEY ("article_id")
);
CREATE INDEX "articles_idx_user_id" on "articles" ("user_id");

--
-- Table: comments
--
DROP TABLE "comments" CASCADE;
CREATE TABLE "comments" (
  "comment_id" serial NOT NULL,
  "name" character varying(255),
  "email" character varying(255),
  "url" character varying(255),
  "body" text,
  "remote_ip" character varying(32),
  "created_at" timestamp DEFAULT 'now()',
  "article_id" smallint,
  "user_id" smallint,
  PRIMARY KEY ("comment_id")
);
CREATE INDEX "comments_idx_article_id" on "comments" ("article_id");
CREATE INDEX "comments_idx_user_id" on "comments" ("user_id");

--
-- Table: tags_articles
--
DROP TABLE "tags_articles" CASCADE;
CREATE TABLE "tags_articles" (
  "tag_article_id" serial NOT NULL,
  "tag_id" smallint,
  "article_id" smallint,
  PRIMARY KEY ("tag_article_id")
);
CREATE INDEX "tags_articles_idx_article_id" on "tags_articles" ("article_id");
CREATE INDEX "tags_articles_idx_tag_id" on "tags_articles" ("tag_id");

--
-- Foreign Key Definitions
--

ALTER TABLE "articles" ADD FOREIGN KEY ("user_id")
  REFERENCES "users" ("user_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "comments" ADD FOREIGN KEY ("article_id")
  REFERENCES "articles" ("article_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "comments" ADD FOREIGN KEY ("user_id")
  REFERENCES "users" ("user_id") DEFERRABLE;

ALTER TABLE "tags_articles" ADD FOREIGN KEY ("article_id")
  REFERENCES "articles" ("article_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "tags_articles" ADD FOREIGN KEY ("tag_id")
  REFERENCES "tags" ("tag_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

