<?php
  //require 'get_db_handle.php';
  //require GET_DB_HANDLE_PATH."/get_db_handle.php";

  require_once 'get_db_handle.php';
  $pdo = get_db_handle();

  /*
  Quizzes
  */

      $stmt = $pdo->prepare('SELECT max(QuizID) FROM Quizzes where isDeleted = ?;');
      $stmt->execute(["false"]);
      $quizWithMaxIDDatabase = $stmt->fetch();
      $quizzesMaxIDDatabase = (int)reset($quizWithMaxIDDatabase);
      $quizzesMaxIDLocal = (is_numeric($_POST["quizzesMaxIDLocal"]) ? (int)$_POST["quizzesMaxIDLocal"] : 0);
      $quizzesResultArray = array();

      file_put_contents("php_log_file.txt","quiz local max was -> localMax: ". $quizzesMaxIDLocal . " database max was -> databaseMax: ". $quizzesMaxIDDatabase ."\n",FILE_APPEND);

      if ($quizzesMaxIDLocal < $quizzesMaxIDDatabase) {
        //file_put_contents("problem.txt","quiz local was less than quiz database "."\n",FILE_APPEND);
          $stmt = $pdo->prepare('SELECT quizid,name,userid,updateTimestamp,dateCreatedOnDeviceTimestamp FROM Quizzes where QuizID > ? and isDeleted = ?;');
          $stmt->execute([$quizzesMaxIDLocal,"false"]);
          while ($row = $stmt->fetch()){
            array_push($quizzesResultArray, $row);
          }
          //file_put_contents("problem.txt","quiz results array size is ". sizeof($quizzesResultArray) ."\n",FILE_APPEND);
      }

      $pointsOfInterestQuizzesResultArray = array();
      if ($quizzesMaxIDLocal < $quizzesMaxIDDatabase or $pointsOfInterestMaxIDLocal < $pointsOfInterestMaxIDDatabase) {
        $stmt2 = $pdo->prepare('SELECT pointOfinterestid,quizid FROM PointsOfInterestQuizzes where QuizID > ? or PointOfInterestID > ?;');
        $stmt2->execute([$quizzesMaxIDLocal,$pointsOfInterestMaxIDLocal]);
        while ($row = $stmt2->fetch()){
          array_push($pointsOfInterestQuizzesResultArray, $row);
        }
      }

  $stmt = null;
  $stmt2 = null;
  $pdo = null;
?>
