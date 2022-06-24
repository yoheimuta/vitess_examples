CREATE TABLE tokens_token_lookup (
  page BIGINT UNSIGNED,
  token VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (page),
  UNIQUE KEY idx_token_page (`token`, `page`)
) ENGINE=InnoDB;

CREATE TABLE messages_message_lookup (
  message VARCHAR(1000),
  page BIGINT UNSIGNED,
  PRIMARY KEY (message, page)
) ENGINE=InnoDB;

