#!/bin/bash

databaseName='drupal'
mysqlRootPass='Test12345'

mysql -uroot -p${mysqlRootPass} << EOF
CREATE TABLE IF NOT EXISTS $databaseName.Users (
  id int(11) unsigned NOT NULL AUTO_INCREMENT,
  name varchar(50) NOT NULL DEFAULT '',
  email varchar(120) NOT NULL DEFAULT '',
  country varchar(50) DEFAULT 'USA',
  password varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (id)
) AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
EOF