<?php
  //require 'get_db_handle.php';
  //require GET_DB_HANDLE_PATH."/get_db_handle.php";
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  /*
  Quizzes
  */

  $stmt = $pdo->prepare('SELECT * FROM Quizzes where updatetimestamp > ?  and isDeleted = ?;');
  $stmt->execute([$lastConnectionTimestampLocal,"false"]);

  while ($row = $stmt->fetch()){
      array_push($updateQuizzesResultArray, $row);
    }

  $stmt = null;
  $pdo = null;
?>
