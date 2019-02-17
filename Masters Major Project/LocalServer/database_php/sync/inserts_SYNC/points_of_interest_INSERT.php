<?php
  //require 'get_db_handle.php';
  //require GET_DB_HANDLE_PATH."/get_db_handle.php";
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  /*
  Points of interest
  */
      $stmt = $pdo->prepare('SELECT max(PointOfInterestID) FROM PointsOfInterest where isDeleted = ?;');
      $stmt->execute(["false"]);
      // $pointsOfInterestMaxIDDatabase = (int)reset($stmt->fetch());
      $pointOfInterestWithMaxIDDatabase = $stmt->fetch();
      $pointsOfInterestMaxIDDatabase =(int)reset($pointOfInterestWithMaxIDDatabase);

      $pointsOfInterestMaxIDLocal = (is_numeric($_POST["pointsOfInterestMaxIDLocal"]) ? (int)$_POST["pointsOfInterestMaxIDLocal"] : 0);
      $pointsOfInterestResultArray = array();

      file_put_contents("php_log_file.txt","point of interest local max was -> localMax: ". $pointsOfInterestMaxIDLocal . " database max was -> databaseMax: ". $pointsOfInterestMaxIDDatabase ."\n",FILE_APPEND);

      if ($pointsOfInterestMaxIDLocal < $pointsOfInterestMaxIDDatabase) {
          $stmt = $pdo->prepare('SELECT pointofinterestid,title,latitude,longitude,userid FROM PointsOfInterest where PointOfInterestID > ? and isDeleted = ?;');
          $stmt->execute([$pointsOfInterestMaxIDLocal,"false"]);
          while ($row = $stmt->fetch()){
            array_push($pointsOfInterestResultArray, $row);
            // file_put_contents("upload_test_file.txt",$row . " || ",FILE_APPEND);
            // file_put_contents("upload_test_file.txt",$row . "\n",FILE_APPEND);
          }
      }

  $stmt = null;
  $pdo = null;
?>
