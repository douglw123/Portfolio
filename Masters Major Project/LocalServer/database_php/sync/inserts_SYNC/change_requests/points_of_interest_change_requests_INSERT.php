<?php
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  /*
  Points of Interest change requests
  */
      $stmt = $pdo->prepare('SELECT max(PointOfInterestChangeRequestID) FROM PointsOfInterestChangeRequests where isDeleted = ?;');
      $stmt->execute(["false"]);
      $pointOfInterestChangeRequestWithMaxIDDatabase = $stmt->fetch();
      $pointOfInterestChangeRequestsMaxIDDatabase = (int)reset($pointOfInterestChangeRequestWithMaxIDDatabase);

      $pointOfInterestChangeRequestsMaxIDLocal = (is_numeric($_POST["pointOfInterestChangeRequestsIDLocal"]) ? (int)$_POST["pointOfInterestChangeRequestsIDLocal"] : 0);
      $pointOfInterestChangeRequestsResultArray = array();

      file_put_contents("php_log_file.txt","pointOfInterestChangeRequests local max was -> localMax: ". $pointOfInterestChangeRequestsMaxIDLocal . " database max was -> databaseMax: ". $pointOfInterestChangeRequestsMaxIDDatabase ."\n",FILE_APPEND);

      if ($pointOfInterestChangeRequestsMaxIDLocal < $pointOfInterestChangeRequestsMaxIDDatabase) {
          $stmt2 = $pdo->prepare('SELECT pointofinterestchangerequestid, userid, pointofinterestid, message, datecreatedondevicetimestamp FROM PointsOfInterestChangeRequests where PointOfInterestChangeRequestID > ? and isDeleted = ?;');
          $stmt2->execute([$pointOfInterestChangeRequestsMaxIDLocal,"false"]);
          while ($row = $stmt2->fetch()){
            array_push($pointOfInterestChangeRequestsResultArray, $row);
          }
        }

  $stmt = null;
  $stmt2 = null;
  $pdo = null;
?>
