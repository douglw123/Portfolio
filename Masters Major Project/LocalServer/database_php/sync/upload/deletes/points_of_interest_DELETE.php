<?php
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  $pointsOfInterestIDsJSONString = $_POST["pointOfInterestIDsToBeDeletedJSON"];
  $pointOfInterestIDToBeDeletedIDsdecoded = json_decode($pointsOfInterestIDsJSONString,true);


    file_put_contents("upload_test_file.txt","points of interest to be deleted -> " . print_r($pointOfInterestIDToBeDeletedIDsdecoded,true). "\n",FILE_APPEND);
    $stmt = $pdo->prepare('INSERT INTO PointsOfInterestTombstone (pointofinterestid) VALUES (?)');

    foreach ($pointOfInterestIDToBeDeletedIDsdecoded as $pointOfInterestIDToBeDeleted) {
      file_put_contents("upload_test_file.txt",$pointOfInterestIDToBeDeleted,FILE_APPEND);

      //try catch
      try {
      $stmt->execute([$pointOfInterestIDToBeDeleted]);
    }
    catch (PDOException $e) {
      $violation = array();
      $violation['table'] = "PointsOfInterestTombstone";
      $violation['action'] = "delete";
      $violation['unique_attribute'] = $pointOfInterestIDToBeDeleted;
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

          file_put_contents("upload_error_log.txt", 'insert of ' . $pointOfInterestIDToBeDeleted . ' with code ' . $e->getCode() . ' duplicate ' . "\n",FILE_APPEND);
          file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
      }
      else if ($e->getCode() == 22001) {
        file_put_contents("upload_error_log.txt", 'insert of ' . $pointOfInterestIDToBeDeleted . ' with code ' . $e->getCode() . ' exceeded varchar limit ' . "\n",FILE_APPEND);
        file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
          $violation['reason'] = "exceeded varchar limit";
      }
      else {
        file_put_contents("upload_error_log.txt", 'insert of ' . $pointOfInterestIDToBeDeleted . ' failed with error ' . $e->getMessage(). ' and the code was ' . $e->getCode() . "\n",FILE_APPEND);
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
