<?php
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  $quizIDsJSONString = $_POST["quizIDsToBeDeletedJSON"];
  $quizIDToBeDeletedIDsdecoded = json_decode($quizIDsJSONString,true);


    file_put_contents("upload_test_file.txt","quizzes to be deleted -> " . print_r($quizIDToBeDeletedIDsdecoded,true). "\n",FILE_APPEND);
    $stmt = $pdo->prepare('INSERT INTO QuizzesTombstone (quizid) VALUES (?)');

    foreach ($quizIDToBeDeletedIDsdecoded as $quizIDToBeDeleted) {
      file_put_contents("upload_test_file.txt",$quizIDToBeDeleted,FILE_APPEND);

      //try catch
      try {
      $stmt->execute([$quizIDToBeDeleted]);
    }
    catch (PDOException $e) {
      $violation = array();
      $violation['table'] = "QuizzesTombstone";
      $violation['action'] = "delete";
      $violation['unique_attribute'] = $quizIDToBeDeleted;
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

          file_put_contents("upload_error_log.txt", 'insert of ' . $quizIDToBeDeleted . ' with code ' . $e->getCode() . ' duplicate ' . "\n",FILE_APPEND);
          file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
      }
      else if ($e->getCode() == 22001) {
        file_put_contents("upload_error_log.txt", 'insert of ' . $quizIDToBeDeleted . ' with code ' . $e->getCode() . ' exceeded varchar limit ' . "\n",FILE_APPEND);
        file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
          $violation['reason'] = "exceeded varchar limit";
      }
      else {
        file_put_contents("upload_error_log.txt", 'insert of ' . $quizIDToBeDeleted . ' failed with error ' . $e->getMessage(). ' and the code was ' . $e->getCode() . "\n",FILE_APPEND);
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
