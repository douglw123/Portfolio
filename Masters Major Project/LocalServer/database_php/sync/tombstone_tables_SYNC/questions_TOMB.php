<?php
  //require 'get_db_handle.php';
  //require GET_DB_HANDLE_PATH."/get_db_handle.php";
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  /*
  Questions
  */

  $stmt = $pdo->prepare('SELECT max(QuestionTombstoneID) FROM QuestionsTombstone;');
  $stmt->execute();
  $questionTombstoneWithMaxIDDatabase = $stmt->fetch();
  $questionTombstoneMaxIDDatabase = (int)reset($questionTombstoneWithMaxIDDatabase);

  $questionTombstoneMaxIDLocal = (is_numeric($_POST["questionTombstoneMaxIDLocal"]) ? (int)$_POST["questionTombstoneMaxIDLocal"] : 0);
  $questionTombstoneResultArray = array();

  file_put_contents("php_log_file.txt","question tombstone local max was -> localMax: ". $questionTombstoneMaxIDLocal . " database max was -> databaseMax: ". $questionTombstoneMaxIDDatabase ."\n",FILE_APPEND);

  if ($questionTombstoneMaxIDLocal < $questionTombstoneMaxIDDatabase) {
    $stmt = $pdo->prepare('SELECT * FROM QuestionsTombstone where QuestionTombstoneID > ?;');
    $stmt->execute([$questionTombstoneMaxIDLocal]);
    while ($row = $stmt->fetch()){
      array_push($questionTombstoneResultArray, $row);
    }
  }

  $stmt = null;
  $pdo = null;
?>
