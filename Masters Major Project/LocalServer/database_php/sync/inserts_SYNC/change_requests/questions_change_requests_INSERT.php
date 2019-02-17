<?php
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  /*
  Questions change requests
  */
      $stmt = $pdo->prepare('SELECT max(QuestionChangeRequestID) FROM QuestionsChangeRequests where isDeleted = ?;');
      $stmt->execute(["false"]);
      $questionChangeRequestWithMaxIDDatabase = $stmt->fetch();
      $questionChangeRequestsMaxIDDatabase = (int)reset($questionChangeRequestWithMaxIDDatabase);

      $questionChangeRequestsMaxIDLocal = (is_numeric($_POST["questionChangeRequestsIDLocal"]) ? (int)$_POST["questionChangeRequestsIDLocal"] : 0);
      $questionChangeRequestsResultArray = array();

      file_put_contents("php_log_file.txt","question Change Requests local max was -> localMax: ". $questionChangeRequestsMaxIDLocal . " database max was -> databaseMax: ". $questionChangeRequestsMaxIDDatabase ."\n",FILE_APPEND);

      if ($questionChangeRequestsMaxIDLocal < $questionChangeRequestsMaxIDDatabase) {
          $stmt2 = $pdo->prepare('SELECT questionchangerequestid, userid, questionid, message, datecreatedondevicetimestamp FROM QuestionsChangeRequests where QuestionChangeRequestID > ? and isDeleted = ?;');
          $stmt2->execute([$questionChangeRequestsMaxIDLocal,"false"]);
          while ($row = $stmt2->fetch()){
            array_push($questionChangeRequestsResultArray, $row);
          }
        }

  $stmt = null;
  $stmt2 = null;
  $pdo = null;
?>
