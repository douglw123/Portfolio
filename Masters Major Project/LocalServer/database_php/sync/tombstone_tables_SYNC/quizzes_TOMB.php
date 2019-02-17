<?php
  //require 'get_db_handle.php';
  //require GET_DB_HANDLE_PATH."/get_db_handle.php";
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  /*
  Quizzes
  */

  $stmt = $pdo->prepare('SELECT max(QuizTombstoneID) FROM QuizzesTombstone;');
  $stmt->execute();
  $quizTombstoneWithMaxIDDatabase = $stmt->fetch();
  $quizTombstoneMaxIDDatabase = (int)reset($quizTombstoneWithMaxIDDatabase);

  $quizTombstoneMaxIDLocal = (is_numeric($_POST["quizTombstoneMaxIDLocal"]) ? (int)$_POST["quizTombstoneMaxIDLocal"] : 0);
  $quizTombstoneResultArray = array();

  file_put_contents("php_log_file.txt","quiz tombstone local max was -> localMax: ". $quizTombstoneMaxIDLocal . " database max was -> databaseMax: ". $quizTombstoneMaxIDDatabase ."\n",FILE_APPEND);

  if ($quizTombstoneMaxIDLocal < $quizTombstoneMaxIDDatabase) {
    $stmt = $pdo->prepare('SELECT * FROM QuizzesTombstone where QuizTombstoneID > ?;');
    $stmt->execute([$quizTombstoneMaxIDLocal]);
    while ($row = $stmt->fetch()){
      array_push($quizTombstoneResultArray, $row);
    }
  }

  $stmt = null;
  $pdo = null;
?>
