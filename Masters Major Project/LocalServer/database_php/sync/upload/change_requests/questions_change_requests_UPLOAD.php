<?php
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  $changeRequestsQuestionsJSONString = $_POST["changeRequestsQuestionsJSON"];
  $changeRequestsDecoded = json_decode($changeRequestsQuestionsJSONString,true);


    file_put_contents("upload_test_file.txt","questions change requests => " .print_r($changeRequestsDecoded,true). "\n",FILE_APPEND);
    $stmt = $pdo->prepare('INSERT INTO QuestionsChangeRequests (userid, questionid, message, datecreatedondevicetimestamp) VALUES (?,?,?,?)');
    //basic user
    $stmt2 = $pdo->prepare('INSERT INTO QuestionsChangeRequests (questionid, message, datecreatedondevicetimestamp) VALUES (?,?,?)');

    foreach ($changeRequestsDecoded as $questionChangeRequest) {
      file_put_contents("upload_test_file.txt",$questionChangeRequest['userID']. " | ",FILE_APPEND);
      file_put_contents("upload_test_file.txt",$questionChangeRequest['questionID']. " | ",FILE_APPEND);
      file_put_contents("upload_test_file.txt",$questionChangeRequest['message']. "\n",FILE_APPEND);

      //try catch

      try {
        if ($questionChangeRequest['userID'] != '0') {
          file_put_contents("upload_test_file.txt", "the user id was not 0 for the question change request". "\n",FILE_APPEND);
          $stmt->execute([$questionChangeRequest['userID'],$questionChangeRequest['questionID'],$questionChangeRequest['message'],$questionChangeRequest['dateCreated']]);
        }
        else {
          file_put_contents("upload_test_file.txt", "the user id was 0 (BASIC USER) for the question change requests". "\n",FILE_APPEND);
          $stmt2->execute([$questionChangeRequest['questionID'],$questionChangeRequest['message'],$questionChangeRequest['dateCreated']]);
        }
    }
    catch (PDOException $e) {
      $violation = array();
      $violation['table'] = "QuestionsChangeRequests";
      $violation['action'] = "insert";
      $violation['unique_attribute'] = $questionChangeRequest['message'];
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

          file_put_contents("upload_error_log.txt", 'insert of ' . $questionChangeRequest['message'] . ' with code ' . $e->getCode() . ' duplicate ' . "\n",FILE_APPEND);
          file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
      }
      else if ($e->getCode() == 22001) {
        file_put_contents("upload_error_log.txt", 'insert of ' . $questionChangeRequest['message'] . ' with code ' . $e->getCode() . ' exceeded varchar limit ' . "\n",FILE_APPEND);
        file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
          $violation['reason'] = "exceeded varchar limit";
      }
      else {
        file_put_contents("upload_error_log.txt", 'insert of ' . $questionChangeRequest['message'] . ' failed with error ' . $e->getMessage(). ' and the code was ' . $e->getCode() . "\n",FILE_APPEND);
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
