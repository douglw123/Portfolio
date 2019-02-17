<?php
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  $quizChangeRequestsIDsJSONString = $_POST["quizChangeRequestIDsToBeDeletedJSON"];
  $quizChangeRequestIDsToBeDeletedDecoded = json_decode($quizChangeRequestsIDsJSONString,true);


    file_put_contents("upload_test_file.txt","quiz change requests to be deleted -> " . print_r($quizChangeRequestIDsToBeDeletedDecoded,true). "\n",FILE_APPEND);
    $stmt = $pdo->prepare('INSERT INTO QuizzesChangeRequestsTombstone (quizchangeRequestid) VALUES (?)');

    foreach ($quizChangeRequestIDsToBeDeletedDecoded as $quizChangeRequestIDToBeDeleted) {
      file_put_contents("upload_test_file.txt",$quizChangeRequestIDToBeDeleted,FILE_APPEND);

      //try catch
      try {
      $stmt->execute([$quizChangeRequestIDToBeDeleted]);
    }
    catch (PDOException $e) {
      $violation = array();
      $violation['table'] = "QuizzesChangeRequestsTombstone";
      $violation['action'] = "delete";
      $violation['unique_attribute'] = $quizChangeRequestIDToBeDeleted;
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

          file_put_contents("upload_error_log.txt", 'insert of ' . $quizChangeRequestIDToBeDeleted . ' with code ' . $e->getCode() . ' duplicate ' . "\n",FILE_APPEND);
          file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
      }
      else if ($e->getCode() == 22001) {
        file_put_contents("upload_error_log.txt", 'insert of ' . $quizChangeRequestIDToBeDeleted . ' with code ' . $e->getCode() . ' exceeded varchar limit ' . "\n",FILE_APPEND);
        file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
          $violation['reason'] = "exceeded varchar limit";
      }
      else {
        file_put_contents("upload_error_log.txt", 'insert of ' . $quizChangeRequestIDToBeDeleted . ' failed with error ' . $e->getMessage(). ' and the code was ' . $e->getCode() . "\n",FILE_APPEND);
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
