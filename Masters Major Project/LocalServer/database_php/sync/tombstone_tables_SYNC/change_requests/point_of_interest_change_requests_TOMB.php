<?php
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  /*
  point Of Interest Change Request
  */

  $stmt = $pdo->prepare('SELECT max(PointOfInterestChangeRequestTombstoneID) FROM PointsOfInterestChangeRequestsTombstone;');
  $stmt->execute();
  $pointOfInterestChangeRequestTombstoneWithMaxIDDatabase = $stmt->fetch();
  $pointOfInterestChangeRequestTombstoneMaxIDDatabase = (int)reset($pointOfInterestChangeRequestTombstoneWithMaxIDDatabase);

  $pointOfInterestChangeRequestTombstoneMaxIDLocal = (is_numeric($_POST["pointOfInterestChangeRequestTombstoneMaxIDLocal"]) ? (int)$_POST["pointOfInterestChangeRequestTombstoneMaxIDLocal"] : 0);
  $pointOfInterestChangeRequestTombstoneResultArray = array();

  file_put_contents("php_log_file.txt","point Of Interest Change Request tombstone local max was -> localMax: ". $pointOfInterestChangeRequestTombstoneMaxIDLocal . " database max was -> databaseMax: ". $pointOfInterestChangeRequestTombstoneMaxIDDatabase ."\n",FILE_APPEND);

  if ($pointOfInterestChangeRequestTombstoneMaxIDLocal < $pointOfInterestChangeRequestTombstoneMaxIDDatabase) {
    $stmt = $pdo->prepare('SELECT * FROM PointsOfInterestChangeRequestsTombstone where PointOfInterestChangeRequestTombstoneID > ?;');
    $stmt->execute([$pointOfInterestChangeRequestTombstoneMaxIDLocal]);
    while ($row = $stmt->fetch()){
      array_push($pointOfInterestChangeRequestTombstoneResultArray, $row);
    }
  }

  $stmt = null;
  $pdo = null;
?>
