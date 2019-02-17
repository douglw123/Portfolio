<?php
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  /*
  Quizzes change requests
  */
      $stmt = $pdo->prepare('SELECT max(QuizChangeRequestID) FROM QuizzesChangeRequests where isDeleted = ?;');
      $stmt->execute(["false"]);
      $quizChangeRequestWithMaxIDDatabase = $stmt->fetch();
      $quizChangeRequestsMaxIDDatabase = (int)reset($quizChangeRequestWithMaxIDDatabase);

      $quizChangeRequestsMaxIDLocal = (is_numeric($_POST["quizChangeRequestsIDLocal"]) ? (int)$_POST["quizChangeRequestsIDLocal"] : 0);
      $quizChangeRequestsResultArray = array();

      file_put_contents("php_log_file.txt","quizChangeRequests local max was -> localMax: ". $quizChangeRequestsMaxIDLocal . " database max was -> databaseMax: ". $quizChangeRequestsMaxIDDatabase ."\n",FILE_APPEND);

      if ($quizChangeRequestsMaxIDLocal < $quizChangeRequestsMaxIDDatabase) {
          $stmt2 = $pdo->prepare('SELECT quizchangerequestid, userid, quizid, message, datecreatedondevicetimestamp FROM QuizzesChangeRequests where QuizChangeRequestID > ? and isDeleted = ?;');
          $stmt2->execute([$quizChangeRequestsMaxIDLocal,"false"]);
          while ($row = $stmt2->fetch()){
            array_push($quizChangeRequestsResultArray, $row);
          }
        }

  $stmt = null;
  $stmt2 = null;
  $pdo = null;
?>
