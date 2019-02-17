<?php
  //require 'get_db_handle.php';
  //require GET_DB_HANDLE_PATH."/get_db_handle.php";
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  /*
  Points Of Interest
  */
    $stmt = $pdo->prepare('SELECT * FROM PointsOfInterest where updatetimestamp > ? and isDeleted = ?;');
    $stmt->execute([$lastConnectionTimestampLocal,"false"]);
    while ($row = $stmt->fetch()){
        array_push($updatePointsOfInterestResultArray, $row);
      }
  $stmt = null;
  $pdo = null;
?>
