<?php
  //require 'get_db_handle.php';
  //require GET_DB_HANDLE_PATH."/get_db_handle.php";
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  /*
  Wrong Answers
  */
    $stmt = $pdo->prepare('SELECT max(WrongAnswerID) FROM WrongAnswers where isDeleted = ?;');
    $stmt->execute(["false"]);
    $wrongAnswerWithMaxIDDatabase = $stmt->fetch();
    $wrongAnswerMaxIDDatabase = (int)reset($wrongAnswerWithMaxIDDatabase);

    $wrongAnswerMaxIDLocal = (is_numeric($_POST["wrongAnswerMaxIDLocal"]) ? (int)$_POST["wrongAnswerMaxIDLocal"] : 0);
    $wrongAnswerResultArray = array();

    file_put_contents("php_log_file.txt","wrong answer local max was -> localMax: ". $wrongAnswerMaxIDLocal . " database max was -> databaseMax: ". $wrongAnswerMaxIDDatabase ."\n",FILE_APPEND);

    if ($wrongAnswerMaxIDLocal < $wrongAnswerMaxIDDatabase) {
      $stmt = $pdo->prepare('SELECT * FROM WrongAnswers where WrongAnswerID > ? and isDeleted = ?;');
      $stmt->execute([$wrongAnswerMaxIDLocal,"false"]);
      while ($row = $stmt->fetch()){
        array_push($wrongAnswerResultArray, $row);
      }
    }

  $stmt = null;
  $pdo = null;
?>
