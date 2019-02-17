<?php
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  /*
  Quiz Change Request
  */

  $stmt = $pdo->prepare('SELECT max(QuizChangeRequestTombstoneID) FROM QuizzesChangeRequestsTombstone;');
  $stmt->execute();
  $quizChangeRequestTombstoneWithMaxIDDatabase = $stmt->fetch();
  $quizChangeRequestTombstoneMaxIDDatabase = (int)reset($quizChangeRequestTombstoneWithMaxIDDatabase);

  $quizChangeRequestTombstoneMaxIDLocal = (is_numeric($_POST["quizChangeRequestTombstoneMaxIDLocal"]) ? (int)$_POST["quizChangeRequestTombstoneMaxIDLocal"] : 0);
  $quizChangeRequestTombstoneResultArray = array();

  file_put_contents("php_log_file.txt","Quiz Change Request tombstone local max was -> localMax: ". $quizChangeRequestTombstoneMaxIDLocal . " database max was -> databaseMax: ". $quizChangeRequestTombstoneMaxIDDatabase ."\n",FILE_APPEND);

  if ($quizChangeRequestTombstoneMaxIDLocal < $quizChangeRequestTombstoneMaxIDDatabase) {
    $stmt = $pdo->prepare('SELECT * FROM QuizzesChangeRequestsTombstone where QuizChangeRequestTombstoneID > ?;');
    $stmt->execute([$quizChangeRequestTombstoneMaxIDLocal]);
    while ($row = $stmt->fetch()){
      array_push($quizChangeRequestTombstoneResultArray, $row);
    }
  }

  $stmt = null;
  $pdo = null;
?>
