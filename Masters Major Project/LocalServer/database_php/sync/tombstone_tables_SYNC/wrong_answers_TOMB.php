<?php
  //require 'get_db_handle.php';
  //require GET_DB_HANDLE_PATH."/get_db_handle.php";
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  /*
  Wrong Answers
  */

  $stmt = $pdo->prepare('SELECT max(WrongAnswerTombstoneID) FROM WrongAnswersTombstone;');
  $stmt->execute();
  $wrongAnswerTombstoneWithMaxIDDatabase = $stmt->fetch();
  $wrongAnswerTombstoneMaxIDDatabase = (int)reset($wrongAnswerTombstoneWithMaxIDDatabase);

  $wrongAnswerTombstoneMaxIDLocal = (is_numeric($_POST["wrongAnswerTombstoneMaxIDLocal"]) ? (int)$_POST["wrongAnswerTombstoneMaxIDLocal"] : 0);
  $wrongAnswerTombstoneResultArray = array();

  file_put_contents("php_log_file.txt","wrong answer tombstone local max was -> localMax: ". $wrongAnswerTombstoneMaxIDLocal . " database max was -> databaseMax: ". $wrongAnswerTombstoneMaxIDDatabase ."\n",FILE_APPEND);

  if ($wrongAnswerTombstoneMaxIDLocal < $wrongAnswerTombstoneMaxIDDatabase) {
    $stmt = $pdo->prepare('SELECT * FROM WrongAnswersTombstone where WrongAnswerTombstoneID > ?;');
    $stmt->execute([$wrongAnswerTombstoneMaxIDLocal]);
    while ($row = $stmt->fetch()){
      array_push($wrongAnswerTombstoneResultArray, $row);
    }
  }

  $stmt = null;
  $pdo = null;
?>
