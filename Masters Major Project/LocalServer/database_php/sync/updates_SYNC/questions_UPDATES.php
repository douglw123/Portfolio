<?php
  //require 'get_db_handle.php';
  //require GET_DB_HANDLE_PATH."/get_db_handle.php";
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  /*
  Questions
  */

  $stmt = $pdo->prepare('SELECT * FROM Questions where updatetimestamp > ? and isDeleted = ?;');
  $stmt->execute([$lastConnectionTimestampLocal,"false"]);

  while ($row = $stmt->fetch()){
      array_push($updateQuestionsResultArray, $row);
    }

  $stmt = null;
  $pdo = null;
?>
