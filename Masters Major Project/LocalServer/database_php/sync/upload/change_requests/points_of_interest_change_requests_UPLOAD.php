<?php
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  $changeRequestsPointOfInterestJSONString = $_POST["changeRequestsPointOfInterestJSON"];
  $changeRequestsDecoded = json_decode($changeRequestsPointOfInterestJSONString,true);


    file_put_contents("upload_test_file.txt","point of interest change request => " .print_r($changeRequestsDecoded,true). "\n",FILE_APPEND);
    $stmt = $pdo->prepare('INSERT INTO PointsOfInterestChangeRequests (userid, pointofinterestid, message, datecreatedondevicetimestamp) VALUES (?,?,?,?)');
    //basic user
    $stmt2 = $pdo->prepare('INSERT INTO PointsOfInterestChangeRequests (pointofinterestid, message, datecreatedondevicetimestamp) VALUES (?,?,?)');

    foreach ($changeRequestsDecoded as $pointOfInterestChangeRequest) {
      file_put_contents("upload_test_file.txt",$pointOfInterestChangeRequest['userID']. " | ",FILE_APPEND);
      file_put_contents("upload_test_file.txt",$pointOfInterestChangeRequest['pointOfInterestID']. " | ",FILE_APPEND);
      file_put_contents("upload_test_file.txt",$pointOfInterestChangeRequest['message']. "\n",FILE_APPEND);

      //try catch

      try {
        if ($pointOfInterestChangeRequest['userID'] != '0') {
          file_put_contents("upload_test_file.txt", "the user id was not 0 for the point of interest change request". "\n",FILE_APPEND);
          $stmt->execute([$pointOfInterestChangeRequest['userID'],$pointOfInterestChangeRequest['pointOfInterestID'],$pointOfInterestChangeRequest['message'],$pointOfInterestChangeRequest['dateCreated']]);
        }
        else {
          file_put_contents("upload_test_file.txt", "the user id was 0 (BASIC USER) for the point of interest change requests". "\n",FILE_APPEND);
          $stmt2->execute([$pointOfInterestChangeRequest['pointOfInterestID'],$pointOfInterestChangeRequest['message'],$pointOfInterestChangeRequest['dateCreated']]);
        }
    }
    catch (PDOException $e) {
      $violation = array();
      $violation['table'] = "PointsOfInterestChangeRequests";
      $violation['action'] = "insert";
      $violation['unique_attribute'] = $pointOfInterestChangeRequest['message'];
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

          file_put_contents("upload_error_log.txt", 'insert of ' . $pointOfInterestChangeRequest['message'] . ' with code ' . $e->getCode() . ' duplicate name ' . "\n",FILE_APPEND);
          file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
      }
      else if ($e->getCode() == 22001) {
        file_put_contents("upload_error_log.txt", 'insert of ' . $pointOfInterestChangeRequest['message'] . ' with code ' . $e->getCode() . ' exceeded varchar limit ' . "\n",FILE_APPEND);
        file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
          $violation['reason'] = "exceeded varchar limit";
      }
      else {
        file_put_contents("upload_error_log.txt", 'insert of ' . $pointOfInterestChangeRequest['message'] . ' failed with error ' . $e->getMessage(). ' and the code was ' . $e->getCode() . "\n",FILE_APPEND);
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
