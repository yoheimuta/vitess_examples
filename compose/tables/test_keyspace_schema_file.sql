CREATE TABLE messages (
  page BIGINT(20) UNSIGNED,
  time_created_ns BIGINT(20) UNSIGNED,
  message VARCHAR(10000),
  PRIMARY KEY (page, time_created_ns)
) ENGINE=InnoDB;

CREATE TABLE tokens (
  page BIGINT(20) UNSIGNED,
  time_created_ns BIGINT(20) UNSIGNED,
  token VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (page, time_created_ns)
) ENGINE=InnoDB;

