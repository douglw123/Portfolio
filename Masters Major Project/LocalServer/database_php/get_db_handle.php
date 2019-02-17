<?php
    // NB This file should be stored OUTSIDE the server document tree
    function get_db_handle() {
      date_default_timezone_set('Europe/London');
      $host = 'localhost';
      $db   = 'Doug';
      $port = 5432;
      $user = 'Doug';
      $pass = '';
      //$charset = 'utf8';
      $driver = 'pgsql';
      //$sockt = '/Applications/MAMP/tmp/mysql/mysql.sock'; unix_socket=$sockt

      $dsn = "$driver:host=$host;dbname=$db;port=$port;";//charset=$charset";
      $opt = [
          PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
          PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
          PDO::ATTR_EMULATE_PREPARES   => false,
      ];
        try {

            return new PDO($dsn, $user, $pass, $opt);

        } catch (PDOException $e) {
            // could do something more useful here
            file_put_contents("php_log_file.txt","Database connection failed\n",FILE_APPEND);
            exit('Database connection could not be made'."\n");
            return NULL;
        }
    }
?>
