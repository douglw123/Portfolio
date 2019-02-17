<?php
  //require 'get_db_handle.php';
  //require GET_DB_HANDLE_PATH."/get_db_handle.php";
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  /*
  Tombstone tables
  ----------------
  Point of interest
  */
      $stmt = $pdo->prepare('SELECT max(PointOfInterestTombstoneID) FROM PointsOfInterestTombstone;');
      $stmt->execute();
      $pointOfInterestTombstoneWithMaxIDDatabase = $stmt->fetch();
      $pointOfInterestTombstoneMaxIDDatabase = (int)reset($pointOfInterestTombstoneWithMaxIDDatabase);

      $pointOfInterestTombstoneMaxIDLocal = (is_numeric($_POST["pointOfInterestTombstoneMaxIDLocal"]) ? (int)$_POST["pointOfInterestTombstoneMaxIDLocal"] : 0);
      $pointOfInterestTombstoneResultArray = array();

      file_put_contents("php_log_file.txt","point of interest Tombstone local max was -> localMax: ". $pointOfInterestTombstoneMaxIDLocal . " database max was -> databaseMax: ". $pointOfInterestTombstoneMaxIDDatabase ."\n",FILE_APPEND);

      if ($pointOfInterestTombstoneMaxIDLocal < $pointOfInterestTombstoneMaxIDDatabase) {
            $stmt = $pdo->prepare('SELECT pointofinteresttombstoneid,pointofinterestid FROM PointsOfInterestTombstone where PointOfInterestTombstoneID > ?;');
            $stmt->execute([$pointOfInterestTombstoneMaxIDLocal]);
            while ($row = $stmt->fetch()){
              array_push($pointOfInterestTombstoneResultArray, $row);
            }
          }

  $stmt = null;
  $pdo = null;
?>
