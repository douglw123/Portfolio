<?php
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  $questionChangeRequestsIDsJSONString = $_POST["questionChangeRequestIDsToBeDeletedJSON"];
  $questionChangeRequestIDsToBeDeletedDecoded = json_decode($questionChangeRequestsIDsJSONString,true);


    file_put_contents("upload_test_file.txt","question change requests to be deleted -> " . print_r($questionChangeRequestIDsToBeDeletedDecoded,true). "\n",FILE_APPEND);
    $stmt = $pdo->prepare('INSERT INTO QuestionsChangeRequestsTombstone (questionchangerequestid) VALUES (?)');

    foreach ($questionChangeRequestIDsToBeDeletedDecoded as $questionChangeRequestIDToBeDeleted) {
      file_put_contents("upload_test_file.txt",$questionChangeRequestIDToBeDeleted,FILE_APPEND);

      //try catch
      try {
      $stmt->execute([$questionChangeRequestIDToBeDeleted]);
    }
    catch (PDOException $e) {
      $violation = array();
      $violation['table'] = "QuestionsChangeRequestsTombstone";
      $violation['action'] = "delete";
      $violation['unique_attribute'] = $questionChangeRequestIDToBeDeleted;
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

          file_put_contents("upload_error_log.txt", 'insert of ' . $questionChangeRequestIDToBeDeleted . ' with code ' . $e->getCode() . ' duplicate ' . "\n",FILE_APPEND);
          file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
      }
      else if ($e->getCode() == 22001) {
        file_put_contents("upload_error_log.txt", 'insert of ' . $questionChangeRequestIDToBeDeleted . ' with code ' . $e->getCode() . ' exceeded varchar limit ' . "\n",FILE_APPEND);
        file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
          $violation['reason'] = "exceeded varchar limit";
      }
      else {
        file_put_contents("upload_error_log.txt", 'insert of ' . $questionChangeRequestIDToBeDeleted . ' failed with error ' . $e->getMessage(). ' and the code was ' . $e->getCode() . "\n",FILE_APPEND);
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
