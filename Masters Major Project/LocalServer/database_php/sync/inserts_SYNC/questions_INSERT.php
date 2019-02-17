<?php
  //require 'get_db_handle.php';
  //require GET_DB_HANDLE_PATH."/get_db_handle.php";
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  /*
  Questions
  */
      $stmt = $pdo->prepare('SELECT max(QuestionID) FROM Questions where isDeleted = ?;');
      $stmt->execute(["false"]);
      $questionWithMaxIDDatabase = $stmt->fetch();
      $questionsMaxIDDatabase = (int)reset($questionWithMaxIDDatabase);

      $questionsMaxIDLocal = (is_numeric($_POST["questionsMaxIDLocal"]) ? (int)$_POST["questionsMaxIDLocal"] : 0);
      $questionsResultArray = array();

      file_put_contents("php_log_file.txt","question local max was -> localMax: ". $questionsMaxIDLocal . " database max was -> databaseMax: ". $questionsMaxIDDatabase ."\n",FILE_APPEND);

      if ($questionsMaxIDLocal < $questionsMaxIDDatabase) {
          $stmt = $pdo->prepare('SELECT questionid,quizid,question,answer,userid,datecreatedondevicetimestamp FROM Questions where QuestionID > ? and isDeleted = ?;');
          $stmt->execute([$questionsMaxIDLocal,"false"]);
          while ($row = $stmt->fetch()){
            array_push($questionsResultArray, $row);
          }
        }

  $stmt = null;
  $pdo = null;
?>
