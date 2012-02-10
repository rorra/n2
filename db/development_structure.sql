CREATE TABLE `announcements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `prefix` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `details` text COLLATE utf8_unicode_ci,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mode` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'rotate',
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_id` int(11) DEFAULT '0',
  `user_id` bigint(20) DEFAULT '0',
  `answer` text COLLATE utf8_unicode_ci,
  `votes_tally` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_answers_on_question_id` (`question_id`),
  KEY `index_answers_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `articles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `body` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `is_draft` tinyint(1) DEFAULT '0',
  `preamble` text COLLATE utf8_unicode_ci,
  `preamble_complete` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `audios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `audioable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `audioable_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `artist` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `album` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `caption` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `votes_tally` int(11) DEFAULT '0',
  `source_id` int(11) DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `embed_code` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `index_audios_on_audioable_type_and_audioable_id` (`audioable_type`,`audioable_id`),
  KEY `index_audios_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `authentications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `provider` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `uid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `credentials_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `credentials_secret` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `nickname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `raw_output` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `index_authentications_on_user_id_and_provider` (`user_id`,`provider`),
  KEY `index_authentications_on_user_id` (`user_id`),
  KEY `index_authentications_on_provider` (`provider`),
  KEY `index_authentications_on_uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `cards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `short_caption` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `long_caption` text COLLATE utf8_unicode_ci,
  `points` int(11) DEFAULT '0',
  `slug_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `not_sendable` tinyint(1) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `updated_at` datetime DEFAULT NULL,
  `sent_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `image_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_file_size` int(11) DEFAULT NULL,
  `image_updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `categorizable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `context` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_categories_on_parent_id` (`parent_id`),
  KEY `index_categories_on_categorizable_type` (`categorizable_type`),
  KEY `index_categories_on_context` (`context`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `categorizations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) DEFAULT NULL,
  `categorizable_id` int(11) DEFAULT NULL,
  `categorizable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_categorizations_on_category_id` (`category_id`),
  KEY `index_categorizations_on_categorizable_type_and_categorizable_id` (`categorizable_type`,`categorizable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `chirps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `recipient_id` int(11) DEFAULT NULL,
  `subject` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `classifieds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `details` text COLLATE utf8_unicode_ci,
  `aasm_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `listing_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `allow` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `amazon_asin` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `price` float DEFAULT NULL,
  `votes_tally` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  `flags_count` int(11) DEFAULT '0',
  `is_blocked` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `location_text` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_classifieds_on_user_id` (`user_id`),
  KEY `index_classifieds_on_aasm_state` (`aasm_state`),
  KEY `index_classifieds_on_expires_at` (`expires_at`),
  KEY `index_classifieds_on_listing_type` (`listing_type`),
  KEY `index_classifieds_on_allow` (`allow`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `commentid` int(11) DEFAULT '0',
  `commentable_id` int(11) DEFAULT '0',
  `contentid` int(11) DEFAULT '0',
  `comments` text COLLATE utf8_unicode_ci,
  `postedByName` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `postedById` int(11) DEFAULT '0',
  `user_id` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `videoid` int(11) DEFAULT '0',
  `updated_at` datetime DEFAULT NULL,
  `commentable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `flags_count` int(11) DEFAULT '0',
  `votes_tally` int(11) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_comments_on_commentable_type_and_commentable_id` (`commentable_type`,`commentable_id`),
  KEY `index_comments_on_commentable_type` (`commentable_type`)
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `consumer_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `type` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `token` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL,
  `secret` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_consumer_tokens_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `content_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `content_id` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_content_images_on_content_id` (`content_id`),
  KEY `siteContentId` (`content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `contents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contentid` int(11) DEFAULT '0',
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `caption` text COLLATE utf8_unicode_ci,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `permalink` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `postedById` int(11) DEFAULT '0',
  `postedByName` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `score` int(11) DEFAULT '0',
  `numComments` int(11) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `user_id` int(11) DEFAULT '0',
  `imageid` int(11) DEFAULT '0',
  `videoIntroId` int(11) DEFAULT '0',
  `is_blocked` tinyint(1) DEFAULT '0',
  `videoid` int(11) DEFAULT '0',
  `widgetid` int(11) DEFAULT '0',
  `isBlogEntry` tinyint(1) DEFAULT '0',
  `isFeatureCandidate` tinyint(1) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `updated_at` datetime DEFAULT NULL,
  `article_id` int(11) DEFAULT NULL,
  `cached_slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `flags_count` int(11) DEFAULT '0',
  `votes_tally` int(11) DEFAULT '0',
  `newswire_id` int(11) DEFAULT NULL,
  `story_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'story',
  `summary` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `full_html` text COLLATE utf8_unicode_ci,
  `source_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `contentid` (`contentid`),
  KEY `relatedItems` (`title`),
  KEY `relatedText` (`title`),
  KEY `index_contents_on_story_type` (`story_type`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `dashboard_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `action_text` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `action_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'draft',
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `news_id` int(11) DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `eid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tagline` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pic` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pic_big` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pic_small` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `host` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `street` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `event_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `event_subtype` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `privacy_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `isApproved` tinyint(1) DEFAULT NULL,
  `nid` int(11) DEFAULT NULL,
  `creator` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `votes_tally` int(11) DEFAULT NULL,
  `comments_count` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `flags_count` int(11) DEFAULT '0',
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `alt_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_events_on_eid` (`eid`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `fbSessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` bigint(20) DEFAULT '0',
  `fbId` bigint(20) DEFAULT '0',
  `fb_sig_session_key` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `fb_sig_time` datetime DEFAULT NULL,
  `fb_sig_expires` datetime DEFAULT NULL,
  `fb_sig_profile_update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `featured_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `featurable_id` int(11) DEFAULT NULL,
  `featurable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `featured_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_featured_items_on_featurable_type_and_featurable_id` (`featurable_type`,`featurable_id`),
  KEY `index_featured_items_on_featured_type` (`featured_type`),
  KEY `index_featured_items_on_name` (`name`),
  KEY `index_featured_items_on_parent_id` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `feeds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wireid` int(11) DEFAULT '0',
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `rss` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `last_fetched_at` datetime DEFAULT NULL,
  `feedType` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'wire',
  `specialType` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'default',
  `loadOptions` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'none',
  `user_id` bigint(20) DEFAULT '0',
  `tagList` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `load_all` tinyint(1) DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `enabled` tinyint(1) DEFAULT '1',
  `newswires_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_feeds_on_deleted_at` (`deleted_at`),
  KEY `index_feeds_on_enabled` (`enabled`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `flags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `flag_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `flaggable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `flaggable_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_flags_on_flaggable_type_and_flaggable_id` (`flaggable_type`,`flaggable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `forums` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `topics_count` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `position` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `galleries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `user_id` int(11) DEFAULT NULL,
  `is_public` tinyint(1) DEFAULT '0',
  `votes_tally` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  `flags_count` int(11) DEFAULT '0',
  `is_blocked` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_galleries_on_user_id` (`user_id`),
  KEY `index_galleries_on_title` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `gallery_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `galleryable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `galleryable_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `gallery_id` int(11) DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cached_slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `caption` text COLLATE utf8_unicode_ci,
  `item_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `position` int(11) DEFAULT '0',
  `votes_tally` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  `flags_count` int(11) DEFAULT '0',
  `is_blocked` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_gallery_items_on_user_id` (`user_id`),
  KEY `index_gallery_items_on_cached_slug` (`cached_slug`),
  KEY `index_gallery_items_on_title` (`title`),
  KEY `index_gallery_items_on_gallery_id` (`gallery_id`),
  KEY `index_gallery_items_on_galleryable_type_and_galleryable_id` (`galleryable_type`,`galleryable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `gos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `goable_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cached_slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `views_count` int(11) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  `flags_count` int(11) DEFAULT '0',
  `is_blocked` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_gos_on_user_id` (`user_id`),
  KEY `index_gos_on_cached_slug` (`cached_slug`),
  KEY `index_gos_on_name` (`name`),
  KEY `index_gos_on_goable_type_and_goable_id` (`goable_type`,`goable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `idea_boards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `section` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `ideas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT '0',
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `details` text COLLATE utf8_unicode_ci,
  `old_tag_id` int(11) DEFAULT '0',
  `old_video_id` int(11) DEFAULT '0',
  `votes_tally` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `idea_board_id` int(11) DEFAULT NULL,
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  `flags_count` int(11) DEFAULT '0',
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `related` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `imageable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `imageable_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `remote_image_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `image_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_file_size` int(11) DEFAULT NULL,
  `image_updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `votes_tally` int(11) DEFAULT '0',
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_images_on_imageable_type_and_imageable_id` (`imageable_type`,`imageable_id`),
  KEY `index_images_on_user_id` (`user_id`),
  KEY `index_images_on_remote_image_url` (`remote_image_url`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `item_actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `actionable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `actionable_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_item_actions_on_user_id` (`user_id`),
  KEY `index_item_actions_on_action_type` (`action_type`),
  KEY `index_item_actions_on_actionable_type_and_actionable_id` (`actionable_type`,`actionable_id`),
  KEY `index_item_actions_on_is_blocked` (`is_blocked`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `item_scores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `scorable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `scorable_id` int(11) DEFAULT NULL,
  `score` float DEFAULT '0',
  `positive_actions_count` int(11) DEFAULT '0',
  `negative_actions_count` int(11) DEFAULT '0',
  `is_blocked` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_item_scores_on_scorable_type_and_scorable_id` (`scorable_type`,`scorable_id`),
  KEY `index_item_scores_on_scorable_type` (`scorable_type`),
  KEY `index_item_scores_on_score` (`score`),
  KEY `index_item_scores_on_positive_actions_count` (`positive_actions_count`),
  KEY `index_item_scores_on_negative_actions_count` (`negative_actions_count`),
  KEY `index_item_scores_on_is_blocked` (`is_blocked`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `item_tweets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `tweet_id` int(11) DEFAULT NULL,
  `primary_item` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_item_tweets_on_item_type_and_item_id` (`item_type`,`item_id`),
  KEY `index_item_tweets_on_tweet_id` (`tweet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `locales` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_locales_on_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `menu_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `menuitemable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `menuitemable_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `enabled` tinyint(1) DEFAULT '1',
  `position` int(11) DEFAULT '0',
  `resource_path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name_slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `locale_string` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_menu_items_on_parent_id` (`parent_id`),
  KEY `index_menu_items_on_enabled` (`enabled`),
  KEY `index_menu_items_on_name_slug` (`name_slug`),
  KEY `index_menu_items_on_menuitemable_type_and_menuitemable_id` (`menuitemable_type`,`menuitemable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subject` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `body` text COLLATE utf8_unicode_ci,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `metadatas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `metadatable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `metadatable_id` int(11) DEFAULT NULL,
  `key_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `key_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `meta_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `key_sub_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_metadatas_on_key_name` (`key_name`),
  KEY `index_metadatas_on_key_type_and_key_name` (`key_type`,`key_name`),
  KEY `index_metadatas_on_metadatable_type_and_metadatable_id` (`metadatable_type`,`metadatable_id`),
  KEY `index_metadatas_on_key_type_and_key_sub_type_and_key_name` (`key_type`,`key_sub_type`,`key_name`)
) ENGINE=InnoDB AUTO_INCREMENT=318 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `newswires` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `caption` text COLLATE utf8_unicode_ci,
  `source` varchar(150) COLLATE utf8_unicode_ci DEFAULT '',
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `wireid` int(11) DEFAULT '0',
  `feedType` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'wire',
  `mediaUrl` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `imageUrl` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `embed` text COLLATE utf8_unicode_ci,
  `feed_id` int(11) DEFAULT '0',
  `updated_at` datetime DEFAULT NULL,
  `published` tinyint(1) DEFAULT '0',
  `read_count` int(11) DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `feedid` (`feed_id`),
  KEY `index_newswires_on_title` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `pfeed_deliveries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pfeed_receiver_id` int(11) DEFAULT NULL,
  `pfeed_receiver_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pfeed_item_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `pfeed_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `originator_id` int(11) DEFAULT NULL,
  `originator_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `participant_id` int(11) DEFAULT NULL,
  `participant_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data` text COLLATE utf8_unicode_ci,
  `expiry` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `prediction_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `section` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'open',
  `user_id` int(11) DEFAULT NULL,
  `is_approved` tinyint(1) DEFAULT '1',
  `votes_tally` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `questions_count` int(11) DEFAULT '0',
  `is_blocked` tinyint(1) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `prediction_questions_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `prediction_guesses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `prediction_question_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `guess` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `guess_numeric` int(11) DEFAULT NULL,
  `guess_date` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_correct` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `prediction_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `prediction_group_id` int(11) DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `prediction_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `choices` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'open',
  `user_id` int(11) DEFAULT NULL,
  `is_approved` tinyint(1) DEFAULT '1',
  `votes_tally` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `guesses_count` int(11) DEFAULT '0',
  `is_blocked` tinyint(1) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `prediction_guesses_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `prediction_results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `prediction_question_id` int(11) DEFAULT NULL,
  `result` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `details` text COLLATE utf8_unicode_ci,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `is_accepted` tinyint(1) DEFAULT '0',
  `accepted_at` datetime DEFAULT NULL,
  `accepted_by_user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `alternate_result` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `prediction_scores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `guess_count` int(11) DEFAULT NULL,
  `correct_count` int(11) DEFAULT NULL,
  `accuracy` float DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT '0',
  `question` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `details` text COLLATE utf8_unicode_ci,
  `votes_tally` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `answers_count` int(11) DEFAULT '0',
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `related` (`question`),
  KEY `index_questions_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `related_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8_unicode_ci,
  `user_id` int(11) DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `relatable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `relatable_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `resource_sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `section` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `details` text COLLATE utf8_unicode_ci,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mapUrl` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `twitterName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `votes_tally` int(11) DEFAULT NULL,
  `comments_count` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `flags_count` int(11) DEFAULT '0',
  `resource_section_id` int(11) DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  `is_sponsored` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `authorizable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `authorizable_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `roles_users` (
  `user_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `scores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `scorable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `scorable_id` int(11) DEFAULT NULL,
  `score_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_scores_on_scorable_type_and_scorable_id` (`scorable_type`,`scorable_id`),
  KEY `index_scores_on_scorable_type` (`scorable_type`),
  KEY `index_scores_on_user_id` (`user_id`),
  KEY `index_scores_on_score_type` (`score_type`),
  KEY `index_scores_on_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sent_cards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_user_id` int(11) DEFAULT NULL,
  `to_fb_user_id` bigint(20) DEFAULT NULL,
  `card_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_sent_cards_on_card_id` (`card_id`),
  KEY `index_sent_cards_on_from_user_id` (`from_user_id`),
  KEY `index_sent_cards_on_to_fb_user_id` (`to_fb_user_id`),
  KEY `index_sent_cards_on_from_user_id_and_card_id` (`from_user_id`,`card_id`),
  KEY `index_sent_cards_on_from_user_id_and_card_id_and_to_fb_user_id` (`from_user_id`,`card_id`,`to_fb_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `data` longtext COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=1086 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `slugs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sluggable_id` int(11) DEFAULT NULL,
  `sequence` int(11) NOT NULL DEFAULT '1',
  `sluggable_type` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `scope` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_slugs_on_n_s_s_and_s` (`name`,`sluggable_type`,`scope`,`sequence`),
  KEY `index_slugs_on_sluggable_id` (`sluggable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=211 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `all_subdomains_valid` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `white_list` tinyint(1) DEFAULT '0',
  `black_list` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_sources_on_url` (`url`),
  KEY `index_sources_on_white_list` (`white_list`),
  KEY `index_sources_on_black_list` (`black_list`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `taggings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_id` int(11) DEFAULT NULL,
  `taggable_id` int(11) DEFAULT NULL,
  `tagger_id` int(11) DEFAULT NULL,
  `tagger_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `taggable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `context` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_taggings_on_tag_id` (`tag_id`),
  KEY `index_taggings_on_taggable_id_and_taggable_type_and_context` (`taggable_id`,`taggable_type`,`context`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `topics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `forum_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `views_count` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `replied_at` datetime DEFAULT NULL,
  `replied_user_id` int(11) DEFAULT NULL,
  `sticky` int(11) DEFAULT '0',
  `last_comment_id` int(11) DEFAULT NULL,
  `locked` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  `flags_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_topics_on_forum_id` (`forum_id`),
  KEY `index_topics_on_user_id` (`user_id`),
  KEY `index_topics_on_forum_id_and_replied_at` (`forum_id`,`replied_at`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `translations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `raw_key` text COLLATE utf8_unicode_ci,
  `value` text COLLATE utf8_unicode_ci,
  `pluralization_index` int(11) DEFAULT '1',
  `locale_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_translations_on_locale_id_and_key_and_pluralization_index` (`locale_id`,`key`,`pluralization_index`)
) ENGINE=InnoDB AUTO_INCREMENT=34368 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `tweet_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `twitter_id_str` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `screen_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `profile_image_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_tweet_accounts_on_twitter_id_str` (`twitter_id_str`),
  KEY `index_tweet_accounts_on_user_id` (`user_id`),
  KEY `index_tweet_accounts_on_screen_name` (`screen_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `tweet_streams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `list_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `list_username` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `twitter_id_str` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `last_fetched_at` datetime DEFAULT NULL,
  `last_fetched_tweet_id` int(11) DEFAULT NULL,
  `tweets_count` int(11) DEFAULT '0',
  `votes_tally` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  `flags_count` int(11) DEFAULT '0',
  `is_blocked` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_tweet_streams_on_twitter_id_str` (`twitter_id_str`),
  KEY `index_tweet_streams_on_list_username_and_list_name` (`list_username`,`list_name`),
  KEY `index_tweet_streams_on_is_blocked` (`is_blocked`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `tweet_urls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tweet_id` int(11) DEFAULT NULL,
  `url_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_tweet_urls_on_tweet_id` (`tweet_id`),
  KEY `index_tweet_urls_on_url_id` (`url_id`),
  KEY `index_tweet_urls_on_tweet_id_and_url_id` (`tweet_id`,`url_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `tweeted_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `tweets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tweet_item_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tweet_item_id` int(11) DEFAULT NULL,
  `tweet_stream_id` int(11) DEFAULT NULL,
  `tweet_account_id` int(11) DEFAULT NULL,
  `twitter_id_str` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `text` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `raw_tweet` text COLLATE utf8_unicode_ci,
  `votes_tally` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  `flags_count` int(11) DEFAULT '0',
  `is_blocked` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_tweets_on_twitter_id_str` (`twitter_id_str`),
  KEY `index_tweets_on_tweet_stream_id` (`tweet_stream_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `urls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `source_id` int(11) DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `votes_tally` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `featured_at` datetime DEFAULT NULL,
  `flags_count` int(11) DEFAULT '0',
  `is_blocked` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_urls_on_source_id` (`source_id`),
  KEY `index_urls_on_url` (`url`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `user_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `facebook_user_id` bigint(20) DEFAULT '0',
  `isAppAuthorized` tinyint(1) DEFAULT '0',
  `born_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `bio` text COLLATE utf8_unicode_ci,
  `referred_by_user_id` bigint(20) DEFAULT '0',
  `comment_notifications` tinyint(1) DEFAULT '0',
  `receive_email_notifications` tinyint(1) DEFAULT '1',
  `dont_ask_me_for_email` tinyint(1) DEFAULT '0',
  `email_last_ask` datetime DEFAULT NULL,
  `dont_ask_me_invite_friends` tinyint(1) DEFAULT '0',
  `invite_last_ask` datetime DEFAULT NULL,
  `post_comments` tinyint(1) DEFAULT '1',
  `post_likes` tinyint(1) DEFAULT '1',
  `post_items` tinyint(1) DEFAULT '1',
  `is_blocked` tinyint(1) DEFAULT '0',
  `profile_image` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_user_infos_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ncu_id` bigint(20) DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `is_admin` tinyint(1) DEFAULT '0',
  `is_blocked` tinyint(1) DEFAULT '0',
  `vote_power` int(11) DEFAULT '1',
  `remoteStatus` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'noverify',
  `is_member` tinyint(1) DEFAULT '0',
  `is_moderator` tinyint(1) DEFAULT '0',
  `is_sponsor` tinyint(1) DEFAULT '0',
  `is_email_verified` tinyint(1) DEFAULT '0',
  `is_researcher` tinyint(1) DEFAULT '0',
  `accept_rules` tinyint(1) DEFAULT '0',
  `opt_in_study` tinyint(1) DEFAULT '1',
  `opt_in_email` tinyint(1) DEFAULT '1',
  `opt_in_profile` tinyint(1) DEFAULT '1',
  `opt_in_feed` tinyint(1) DEFAULT '1',
  `opt_in_sms` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `eligibility` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'team',
  `cachedPointTotal` int(11) DEFAULT '0',
  `cachedPointsEarned` int(11) DEFAULT '0',
  `cachedPointsEarnedThisWeek` int(11) DEFAULT '0',
  `cachedPointsEarnedLastWeek` int(11) DEFAULT '0',
  `cachedStoriesPosted` int(11) DEFAULT '0',
  `cachedCommentsPosted` int(11) DEFAULT '0',
  `userLevel` varchar(25) COLLATE utf8_unicode_ci DEFAULT 'reader',
  `login` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `crypted_password` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `salt` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `remember_token` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remember_token_expires_at` datetime DEFAULT NULL,
  `fb_user_id` bigint(20) DEFAULT NULL,
  `email_hash` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cached_slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `karma_score` int(11) DEFAULT '0',
  `last_active` datetime DEFAULT NULL,
  `is_editor` tinyint(1) DEFAULT '0',
  `is_robot` tinyint(1) DEFAULT '0',
  `posts_count` int(11) DEFAULT '0',
  `last_viewed_feed_item_id` int(11) DEFAULT NULL,
  `last_delivered_feed_item_id` int(11) DEFAULT NULL,
  `is_host` tinyint(1) DEFAULT '0',
  `activity_score` int(11) DEFAULT '0',
  `fb_oauth_key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fb_oauth_denied_at` datetime DEFAULT NULL,
  `twitter_user` tinyint(1) DEFAULT '0',
  `system_user` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_login` (`login`),
  KEY `index_users_on_posts_count` (`posts_count`),
  KEY `index_users_on_twitter_user` (`twitter_user`),
  KEY `index_users_on_system_user` (`system_user`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `videos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `videoable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `videoable_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `remote_video_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  `description` text COLLATE utf8_unicode_ci,
  `embed_code` text COLLATE utf8_unicode_ci,
  `embed_src` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remote_video_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remote_video_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `votes_tally` int(11) DEFAULT '0',
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  `thumb_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `video_processing` tinyint(1) DEFAULT NULL,
  `medium_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_videos_on_user_id` (`user_id`),
  KEY `index_videos_on_videoable_type_and_videoable_id` (`videoable_type`,`videoable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `view_object_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `template` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pretty_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_view_object_templates_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `view_objects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `view_object_template_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `view_tree_edges` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `child_id` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_view_tree_edges_on_parent_id` (`parent_id`),
  KEY `index_view_tree_edges_on_child_id` (`child_id`)
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `votes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vote` tinyint(1) DEFAULT '0',
  `voteable_id` int(11) NOT NULL,
  `voteable_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `voter_id` int(11) DEFAULT NULL,
  `voter_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_voteables` (`voteable_id`,`voteable_type`),
  KEY `fk_voters` (`voter_id`,`voter_type`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `widget_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `widget_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `widget_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `position` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_widget_pages_on_name` (`name`),
  KEY `index_widget_pages_on_parent_id` (`parent_id`),
  KEY `index_widget_pages_on_widget_id` (`widget_id`),
  KEY `index_widget_pages_on_widget_type` (`widget_type`)
) ENGINE=InnoDB AUTO_INCREMENT=611 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `widgets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `load_functions` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `locals` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `partial` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `metadata` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_widgets_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1310 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO schema_migrations (version) VALUES ('20091124161003');

INSERT INTO schema_migrations (version) VALUES ('20091124162312');

INSERT INTO schema_migrations (version) VALUES ('20091124182343');

INSERT INTO schema_migrations (version) VALUES ('20091124190738');

INSERT INTO schema_migrations (version) VALUES ('20091124204325');

INSERT INTO schema_migrations (version) VALUES ('20091124231957');

INSERT INTO schema_migrations (version) VALUES ('20091201224354');

INSERT INTO schema_migrations (version) VALUES ('20091202012039');

INSERT INTO schema_migrations (version) VALUES ('20091202064956');

INSERT INTO schema_migrations (version) VALUES ('20091203014546');

INSERT INTO schema_migrations (version) VALUES ('20091203204959');

INSERT INTO schema_migrations (version) VALUES ('20091203210908');

INSERT INTO schema_migrations (version) VALUES ('20091208012226');

INSERT INTO schema_migrations (version) VALUES ('20091208013109');

INSERT INTO schema_migrations (version) VALUES ('20091222010834');

INSERT INTO schema_migrations (version) VALUES ('20100103205822');

INSERT INTO schema_migrations (version) VALUES ('20100103215300');

INSERT INTO schema_migrations (version) VALUES ('20100103220246');

INSERT INTO schema_migrations (version) VALUES ('20100103220337');

INSERT INTO schema_migrations (version) VALUES ('20100107182956');

INSERT INTO schema_migrations (version) VALUES ('20100109003023');

INSERT INTO schema_migrations (version) VALUES ('20100111222056');

INSERT INTO schema_migrations (version) VALUES ('20100113182120');

INSERT INTO schema_migrations (version) VALUES ('20100114002308');

INSERT INTO schema_migrations (version) VALUES ('20100115011425');

INSERT INTO schema_migrations (version) VALUES ('20100118233030');

INSERT INTO schema_migrations (version) VALUES ('20100120001612');

INSERT INTO schema_migrations (version) VALUES ('20100121193612');

INSERT INTO schema_migrations (version) VALUES ('20100122011348');

INSERT INTO schema_migrations (version) VALUES ('20100204221559');

INSERT INTO schema_migrations (version) VALUES ('20100204232503');

INSERT INTO schema_migrations (version) VALUES ('20100204233243');

INSERT INTO schema_migrations (version) VALUES ('20100205014711');

INSERT INTO schema_migrations (version) VALUES ('20100205015017');

INSERT INTO schema_migrations (version) VALUES ('20100205015709');

INSERT INTO schema_migrations (version) VALUES ('20100211002808');

INSERT INTO schema_migrations (version) VALUES ('20100211013650');

INSERT INTO schema_migrations (version) VALUES ('20100211072609');

INSERT INTO schema_migrations (version) VALUES ('20100212003651');

INSERT INTO schema_migrations (version) VALUES ('20100212014901');

INSERT INTO schema_migrations (version) VALUES ('20100212220024');

INSERT INTO schema_migrations (version) VALUES ('20100212220146');

INSERT INTO schema_migrations (version) VALUES ('20100213221244');

INSERT INTO schema_migrations (version) VALUES ('20100215214122');

INSERT INTO schema_migrations (version) VALUES ('20100215224032');

INSERT INTO schema_migrations (version) VALUES ('20100216031801');

INSERT INTO schema_migrations (version) VALUES ('20100217011121');

INSERT INTO schema_migrations (version) VALUES ('20100217021117');

INSERT INTO schema_migrations (version) VALUES ('20100227021124');

INSERT INTO schema_migrations (version) VALUES ('20100227190146');

INSERT INTO schema_migrations (version) VALUES ('20100227190653');

INSERT INTO schema_migrations (version) VALUES ('20100302203538');

INSERT INTO schema_migrations (version) VALUES ('20100303014650');

INSERT INTO schema_migrations (version) VALUES ('20100303202402');

INSERT INTO schema_migrations (version) VALUES ('20100305005027');

INSERT INTO schema_migrations (version) VALUES ('20100309162706');

INSERT INTO schema_migrations (version) VALUES ('20100315185556');

INSERT INTO schema_migrations (version) VALUES ('20100315230605');

INSERT INTO schema_migrations (version) VALUES ('20100317083752');

INSERT INTO schema_migrations (version) VALUES ('20100323193005');

INSERT INTO schema_migrations (version) VALUES ('20100326220707');

INSERT INTO schema_migrations (version) VALUES ('20100405201921');

INSERT INTO schema_migrations (version) VALUES ('20100414191921');

INSERT INTO schema_migrations (version) VALUES ('20100419192519');

INSERT INTO schema_migrations (version) VALUES ('20100420011145');

INSERT INTO schema_migrations (version) VALUES ('20100507001639');

INSERT INTO schema_migrations (version) VALUES ('20100513191243');

INSERT INTO schema_migrations (version) VALUES ('20100513204141');

INSERT INTO schema_migrations (version) VALUES ('20100513220901');

INSERT INTO schema_migrations (version) VALUES ('20100516002048');

INSERT INTO schema_migrations (version) VALUES ('20100519173310');

INSERT INTO schema_migrations (version) VALUES ('20100519205155');

INSERT INTO schema_migrations (version) VALUES ('20100519211150');

INSERT INTO schema_migrations (version) VALUES ('20100519223249');

INSERT INTO schema_migrations (version) VALUES ('20100520224828');

INSERT INTO schema_migrations (version) VALUES ('20100521205635');

INSERT INTO schema_migrations (version) VALUES ('20100524231011');

INSERT INTO schema_migrations (version) VALUES ('20100526231658');

INSERT INTO schema_migrations (version) VALUES ('20100608230348');

INSERT INTO schema_migrations (version) VALUES ('20100609180615');

INSERT INTO schema_migrations (version) VALUES ('20100609190538');

INSERT INTO schema_migrations (version) VALUES ('20100609190539');

INSERT INTO schema_migrations (version) VALUES ('20100611200848');

INSERT INTO schema_migrations (version) VALUES ('20100615220810');

INSERT INTO schema_migrations (version) VALUES ('20100623230028');

INSERT INTO schema_migrations (version) VALUES ('20100624005830');

INSERT INTO schema_migrations (version) VALUES ('20100629184103');

INSERT INTO schema_migrations (version) VALUES ('20100629184323');

INSERT INTO schema_migrations (version) VALUES ('20100629204741');

INSERT INTO schema_migrations (version) VALUES ('20100630164852');

INSERT INTO schema_migrations (version) VALUES ('20100630222126');

INSERT INTO schema_migrations (version) VALUES ('20100707181429');

INSERT INTO schema_migrations (version) VALUES ('20100709215511');

INSERT INTO schema_migrations (version) VALUES ('20100712194600');

INSERT INTO schema_migrations (version) VALUES ('20100712201622');

INSERT INTO schema_migrations (version) VALUES ('20100715010547');

INSERT INTO schema_migrations (version) VALUES ('20100715214727');

INSERT INTO schema_migrations (version) VALUES ('20100719210642');

INSERT INTO schema_migrations (version) VALUES ('20100725185136');

INSERT INTO schema_migrations (version) VALUES ('20100725185233');

INSERT INTO schema_migrations (version) VALUES ('20100725185245');

INSERT INTO schema_migrations (version) VALUES ('20100725185301');

INSERT INTO schema_migrations (version) VALUES ('20100729204126');

INSERT INTO schema_migrations (version) VALUES ('20100730233038');

INSERT INTO schema_migrations (version) VALUES ('20100731065950');

INSERT INTO schema_migrations (version) VALUES ('20100801015214');

INSERT INTO schema_migrations (version) VALUES ('20100811214903');

INSERT INTO schema_migrations (version) VALUES ('20100823172428');

INSERT INTO schema_migrations (version) VALUES ('20100823173716');

INSERT INTO schema_migrations (version) VALUES ('20100823190356');

INSERT INTO schema_migrations (version) VALUES ('20100826201801');

INSERT INTO schema_migrations (version) VALUES ('20100907214306');

INSERT INTO schema_migrations (version) VALUES ('20100915230718');

INSERT INTO schema_migrations (version) VALUES ('20101025174437');

INSERT INTO schema_migrations (version) VALUES ('20101025175337');

INSERT INTO schema_migrations (version) VALUES ('20101027210642');

INSERT INTO schema_migrations (version) VALUES ('20101027210809');

INSERT INTO schema_migrations (version) VALUES ('20101109205202');

INSERT INTO schema_migrations (version) VALUES ('20101216230321');

INSERT INTO schema_migrations (version) VALUES ('20101218000625');

INSERT INTO schema_migrations (version) VALUES ('20101221232829');

INSERT INTO schema_migrations (version) VALUES ('20101223190321');

INSERT INTO schema_migrations (version) VALUES ('20101223233329');

INSERT INTO schema_migrations (version) VALUES ('20110107194323');

INSERT INTO schema_migrations (version) VALUES ('20110114011317');

INSERT INTO schema_migrations (version) VALUES ('20110122012647');

INSERT INTO schema_migrations (version) VALUES ('20110202235232');

INSERT INTO schema_migrations (version) VALUES ('20110204222901');

INSERT INTO schema_migrations (version) VALUES ('20110209013341');

INSERT INTO schema_migrations (version) VALUES ('20110209184821');

INSERT INTO schema_migrations (version) VALUES ('20110301231641');

INSERT INTO schema_migrations (version) VALUES ('20110302011840');

INSERT INTO schema_migrations (version) VALUES ('20110309212528');

INSERT INTO schema_migrations (version) VALUES ('20110324193416');

INSERT INTO schema_migrations (version) VALUES ('20110405193504');

INSERT INTO schema_migrations (version) VALUES ('20110525165455');

INSERT INTO schema_migrations (version) VALUES ('20110531181259');

INSERT INTO schema_migrations (version) VALUES ('20110603181934');

INSERT INTO schema_migrations (version) VALUES ('20110627220941');

INSERT INTO schema_migrations (version) VALUES ('20110811204937');

INSERT INTO schema_migrations (version) VALUES ('20110811232456');

INSERT INTO schema_migrations (version) VALUES ('20110812002233');

INSERT INTO schema_migrations (version) VALUES ('20110815184455');

INSERT INTO schema_migrations (version) VALUES ('20110817211627');

INSERT INTO schema_migrations (version) VALUES ('20110818235255');

INSERT INTO schema_migrations (version) VALUES ('20110823205401');

INSERT INTO schema_migrations (version) VALUES ('20110829232116');

INSERT INTO schema_migrations (version) VALUES ('20110908222555');

INSERT INTO schema_migrations (version) VALUES ('20110916233249');

INSERT INTO schema_migrations (version) VALUES ('20111005215423');

INSERT INTO schema_migrations (version) VALUES ('20111012215608');

INSERT INTO schema_migrations (version) VALUES ('20111018212247');

INSERT INTO schema_migrations (version) VALUES ('20111026003847');

INSERT INTO schema_migrations (version) VALUES ('20111116005258');

INSERT INTO schema_migrations (version) VALUES ('20120104022225');

INSERT INTO schema_migrations (version) VALUES ('20120116134428');