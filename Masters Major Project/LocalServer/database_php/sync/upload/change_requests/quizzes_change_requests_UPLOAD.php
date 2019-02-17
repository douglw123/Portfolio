<?php
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  $changeRequestsQuizzesJSONString = $_POST["changeRequestsQuizzesJSON"];
  $changeRequestsDecoded = json_decode($changeRequestsQuizzesJSONString,true);


    file_put_contents("upload_test_file.txt","quizzes change requests => " .print_r($changeRequestsDecoded,true). "\n",FILE_APPEND);
    $stmt = $pdo->prepare('INSERT INTO QuizzesChangeRequests (userid, quizid, message, datecreatedondevicetimestamp) VALUES (?,?,?,?)');
    //basic user
    $stmt2 = $pdo->prepare('INSERT INTO QuizzesChangeRequests (quizid, message, datecreatedondevicetimestamp) VALUES (?,?,?)');

    foreach ($changeRequestsDecoded as $quizChangeRequest) {
      file_put_contents("upload_test_file.txt",$quizChangeRequest['userID']. " | ",FILE_APPEND);
      file_put_contents("upload_test_file.txt",$quizChangeRequest['quizID']. " | ",FILE_APPEND);
      file_put_contents("upload_test_file.txt",$quizChangeRequest['message']. "\n",FILE_APPEND);

      //try catch

      try {
        if ($quizChangeRequest['userID'] != '0') {
          file_put_contents("upload_test_file.txt", "the user id was not 0 for the quiz change request". "\n",FILE_APPEND);
          $stmt->execute([$quizChangeRequest['userID'],$quizChangeRequest['quizID'],$quizChangeRequest['message'],$quizChangeRequest['dateCreated']]);
        }
        else {
          file_put_contents("upload_test_file.txt", "the user id was 0 (BASIC USER) for the quiz change requests". "\n",FILE_APPEND);
          $stmt2->execute([$quizChangeRequest['quizID'],$quizChangeRequest['message'],$quizChangeRequest['dateCreated']]);
        }
    }
    catch (PDOException $e) {
      $violation = array();
      $violation['table'] = "QuizzesChangeRequests";
      $violation['action'] = "insert";
      $violation['unique_attribute'] = $quizChangeRequest['message'];
      if ($e->getCode() == 23505) {
          // duplicate name
          /*
          database_violations
          table
          action
          unique_attribute
          reason
          */

          $violation['reason'] = "duplicate";

          file_put_contents("upload_error_log.txt", 'insert of ' . $quizChangeRequest['message'] . ' with code ' . $e->getCode() . ' duplicate ' . "\n",FILE_APPEND);
          file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
      }
      else if ($e->getCode() == 22001) {
        file_put_contents("upload_error_log.txt", 'insert of ' . $quizChangeRequest['message'] . ' with code ' . $e->getCode() . ' exceeded varchar limit ' . "\n",FILE_APPEND);
        file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
          $violation['reason'] = "exceeded varchar limit";
      }
      else {
        file_put_contents("upload_error_log.txt", 'insert of ' . $quizChangeRequest['message'] . ' failed with error ' . $e->getMessage(). ' and the code was ' . $e->getCode() . "\n",FILE_APPEND);
        file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
        $violation['reason'] = "unknown";
        //throw $e;
      }
      array_push($databaseViolations, $violation);
    }
  }

  $stmt = null;
  $stmt2 = null;
  $pdo = null;
?>
