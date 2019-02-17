<?php
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  $questionsToBeUpdatedJSONString = $_POST["questionsToBeUpdatedJSON"];
  $decodedQuestionsToBeUpdated = json_decode($questionsToBeUpdatedJSONString,true);


    //file_put_contents("upload_update_test_file.txt",print_r($decodedQuestionsToBeUpdated,true). "\n",FILE_APPEND);
    $stmt = $pdo->prepare('UPDATE Questions SET question = ?, answer = ?, QuizID = ? WHERE QuestionID = ?');

    foreach ($decodedQuestionsToBeUpdated as $question) {
      file_put_contents("upload_update_test_file.txt",$question['question']. " | ",FILE_APPEND);
      file_put_contents("upload_update_test_file.txt",$question['answer']. " | ",FILE_APPEND);
      file_put_contents("upload_update_test_file.txt",$question['quizID'] . " | ",FILE_APPEND);
      file_put_contents("upload_update_test_file.txt",$question['questionID']. "\n",FILE_APPEND);
      //try catch
      try {
      $stmt->execute([$question['question'],$question['answer'],$question['quizID'],$question['questionID']]);
    }
    catch (PDOException $e) {
      $violation = array();
      $violation['table'] = "Questions";
      $violation['action'] = "update";
      $violation['unique_attribute'] = $question['question'];
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

          file_put_contents("upload_error_log.txt", 'insert of ' . $question['question'] . ' with code ' . $e->getCode() . ' duplicate question ' . "\n",FILE_APPEND);
          file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
      }
      else if ($e->getCode() == 22001) {
        file_put_contents("upload_error_log.txt", 'insert of ' . $question['question'] . ' with code ' . $e->getCode() . ' exceeded varchar limit ' . "\n",FILE_APPEND);
        file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
          $violation['reason'] = "exceeded varchar limit";
      }
      else {
        file_put_contents("upload_error_log.txt", 'insert of ' . $question['question'] . ' failed with error ' . $e->getMessage(). ' and the code was ' . $e->getCode() . "\n",FILE_APPEND);
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
