<?php
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  $wrongAnswersToBeUpdatedJSONString = $_POST["wrongAnswersToBeUpdatedJSON"];
  $decodedWrongAnswersToBeUpdated = json_decode($wrongAnswersToBeUpdatedJSONString,true);


    //file_put_contents("upload_update_test_file.txt",print_r($decodedWrongAnswersToBeUpdated,true). "\n",FILE_APPEND);
    $stmt = $pdo->prepare('UPDATE WrongAnswers SET wrongAnswer = ?, QuestionID = ? WHERE WrongAnswerID = ?');

    foreach ($decodedWrongAnswersToBeUpdated as $wrongAnswer) {
      file_put_contents("upload_update_test_file.txt",$wrongAnswer['wrongAnswer']. " | ",FILE_APPEND);
      file_put_contents("upload_update_test_file.txt",$wrongAnswer['questionID'] . " | ",FILE_APPEND);
      file_put_contents("upload_update_test_file.txt",$wrongAnswer['wrongAnswerID']. "\n",FILE_APPEND);
      //try catch
      try {
      $stmt->execute([$wrongAnswer['wrongAnswer'],$wrongAnswer['questionID'],$wrongAnswer['wrongAnswerID']]);
    }
    catch (PDOException $e) {
      $violation = array();
      $violation['table'] = "WrongAnswers";
      $violation['action'] = "update";
      $violation['unique_attribute'] = $wrongAnswer['wrongAnswer'];
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

          file_put_contents("upload_error_log.txt", 'insert of ' . $wrongAnswer['question'] . ' with code ' . $e->getCode() . ' duplicate wrong answer ' . "\n",FILE_APPEND);
          file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
      }
      else if ($e->getCode() == 22001) {
        file_put_contents("upload_error_log.txt", 'insert of ' . $wrongAnswer['question'] . ' with code ' . $e->getCode() . ' exceeded varchar limit ' . "\n",FILE_APPEND);
        file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
          $violation['reason'] = "exceeded varchar limit";
      }
      else {
        file_put_contents("upload_error_log.txt", 'insert of ' . $wrongAnswer['question'] . ' failed with error ' . $e->getMessage(). ' and the code was ' . $e->getCode() . "\n",FILE_APPEND);
        file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
        $violation['reason'] = "unknown";
        //throw $e;
      }
      array_push($databaseViolations, $violation);
    }
  }

  $stmt = null;
  $pdo = null;
?>
