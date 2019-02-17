<?php
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  $wrongAnswersJSONString = $_POST["wrongAnswersJSON"];
  $decodedWrongAnswers = json_decode($wrongAnswersJSONString,true);


    file_put_contents("upload_test_file.txt",print_r($decodedWrongAnswers,true). "\n",FILE_APPEND);
    $stmt = $pdo->prepare('INSERT INTO WrongAnswers (userid,questionid,wronganswer,dateCreatedOnDeviceTimestamp) VALUES (?,?,?,?)');
    $stmt2 = $pdo->prepare('SELECT questionid FROM Questions where question = ? and dateCreatedOnDeviceTimestamp = ?;');

    foreach ($decodedWrongAnswers as $wrongAnswer) {
      file_put_contents("upload_test_file.txt",$wrongAnswer['wrongAnswer']. " | ",FILE_APPEND);
      file_put_contents("upload_test_file.txt",$wrongAnswer['dateCreated']. " | ",FILE_APPEND);
      file_put_contents("upload_test_file.txt",$wrongAnswer['questionString']. "\n",FILE_APPEND);

      //try catch need to add if id is 0
      try {
        if ($wrongAnswer['questionID'] == '0') {
          file_put_contents("upload_test_file.txt",$wrongAnswer['questionString'] . 'the id was 0' . "\n",FILE_APPEND);
          $stmt2->execute([$wrongAnswer['questionString'],$wrongAnswer['questionDateCreated']]);
          $questionWithID = $stmt2->fetch();

          file_put_contents("upload_test_file.txt",'printr of retirved question' . "\n" . print_r($questionWithID,true). "\n",FILE_APPEND);

          $wrongAnswer['questionID'] = (int)reset($questionWithID);
          file_put_contents("upload_test_file.txt",'the id retrived was ' . (int)reset($questionWithID) . "\n",FILE_APPEND);

        }

      $stmt->execute([$wrongAnswer['userID'],$wrongAnswer['questionID'],$wrongAnswer['wrongAnswer'],$wrongAnswer['dateCreated']]);
    }
    catch (PDOException $e) {
      $violation = array();
      $violation['table'] = "WrongAnswers";
      $violation['action'] = "insert";
      $violation['unique_attribute'] = $wrongAnswer['wrongAnswer'];
      $violation['unique_attribute_date_created'] = $wrongAnswer['dateCreatedOnDeviceTimestamp'];
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

          file_put_contents("upload_error_log.txt", 'insert of ' . $wrongAnswer['wrongAnswer'] . ' with code ' . $e->getCode() . ' duplicate question ' . "\n",FILE_APPEND);
          file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
      }
      else if ($e->getCode() == 22001) {
        file_put_contents("upload_error_log.txt", 'insert of ' . $wrongAnswer['wrongAnswer'] . ' with code ' . $e->getCode() . ' exceeded varchar limit ' . "\n",FILE_APPEND);
        file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
          $violation['reason'] = "exceeded varchar limit";
      }
      else {
        file_put_contents("upload_error_log.txt", 'insert of ' . $wrongAnswer['wrongAnswer'] . ' failed with error ' . $e->getMessage(). ' and the code was ' . $e->getCode() . "\n",FILE_APPEND);
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
