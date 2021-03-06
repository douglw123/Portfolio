<?php
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  $pointOfInterestJSONString = $_POST["pointOfInterestJSON"];
  $decoded = json_decode($pointOfInterestJSONString,true);


    //file_put_contents("upload_test_file.txt",print_r($decoded,true). "\n",FILE_APPEND);
    $stmt = $pdo->prepare('INSERT INTO PointsOfInterest (userid,title,latitude,longitude) VALUES (?,?,?,?)');
    $databaseViolations = array();

    foreach ($decoded as $pointOfInterest) {
      file_put_contents("upload_test_file.txt",$pointOfInterest['title']. " | ",FILE_APPEND);
      file_put_contents("upload_test_file.txt",$pointOfInterest['latitude']. " | ",FILE_APPEND);
      file_put_contents("upload_test_file.txt",$pointOfInterest['longitude']. "\n",FILE_APPEND);

      //try catch
      try {
      $stmt->execute([$pointOfInterest['userID'],$pointOfInterest['title'],$pointOfInterest['latitude'],$pointOfInterest['longitude']]);
    }
    catch (PDOException $e) {
      $violation = array();
      $violation['table'] = "PointsOfInterest";
      $violation['action'] = "insert";
      $violation['unique_attribute'] = $pointOfInterest['title'];
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

          file_put_contents("upload_error_log.txt", 'insert of ' . $pointOfInterest['title'] . ' with code ' . $e->getCode() . ' duplicate name ' . "\n",FILE_APPEND);
          file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
      }
      else if ($e->getCode() == 22001) {
        file_put_contents("upload_error_log.txt", 'insert of ' . $pointOfInterest['title'] . ' with code ' . $e->getCode() . ' exceeded varchar limit ' . "\n",FILE_APPEND);
        file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
          $violation['reason'] = "exceeded varchar limit";
      }
      else {
        file_put_contents("upload_error_log.txt", 'insert of ' . $pointOfInterest['title'] . ' failed with error ' . $e->getMessage(). ' and the code was ' . $e->getCode() . "\n",FILE_APPEND);
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
