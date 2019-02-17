<?php
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  /*
  Quiz Change Request
  */

  $stmt = $pdo->prepare('SELECT max(QuestionsChangeRequestTombstoneID) FROM QuestionsChangeRequestsTombstone;');
  $stmt->execute();
  $questionChangeRequestTombstoneWithMaxIDDatabase = $stmt->fetch();
  $questionChangeRequestTombstoneMaxIDDatabase = (int)reset($questionChangeRequestTombstoneWithMaxIDDatabase);

  $questionChangeRequestTombstoneMaxIDLocal = (is_numeric($_POST["questionChangeRequestTombstoneMaxIDLocal"]) ? (int)$_POST["questionChangeRequestTombstoneMaxIDLocal"] : 0);
  $questionChangeRequestTombstoneResultArray = array();

  file_put_contents("php_log_file.txt","Question Change Request tombstone local max was -> localMax: ". $questionChangeRequestTombstoneMaxIDLocal . " database max was -> databaseMax: ". $questionChangeRequestTombstoneMaxIDDatabase ."\n",FILE_APPEND);

  if ($questionChangeRequestTombstoneMaxIDLocal < $questionChangeRequestTombstoneMaxIDDatabase) {
    $stmt = $pdo->prepare('SELECT * FROM QuestionsChangeRequestsTombstone where QuestionsChangeRequestTombstoneID > ?;');
    $stmt->execute([$questionChangeRequestTombstoneMaxIDLocal]);
    while ($row = $stmt->fetch()){
      array_push($questionChangeRequestTombstoneResultArray, $row);
    }
  }

  $stmt = null;
  $pdo = null;
?>
