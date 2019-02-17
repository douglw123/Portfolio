<?php
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  $quizzesToBeUpdatedJSONString = $_POST["quizzesToBeUpdatedJSON"];
  $decodedQuizzesToBeUpdated = json_decode($quizzesToBeUpdatedJSONString,true);


    //file_put_contents("upload_update_test_file.txt",print_r($decodedQuizzesToBeUpdated,true). "\n",FILE_APPEND);
    $stmt = $pdo->prepare('UPDATE Quizzes SET name = ? WHERE QuizID = ?');
    $stmt2 = $pdo->prepare('DELETE FROM PointsOfInterestQuizzes WHERE QuizID = ?');
    $stmt3 = $pdo->prepare('INSERT INTO PointsOfInterestQuizzes (PointOfInterestID,QuizID) VALUES (?,?)');

    foreach ($decodedQuizzesToBeUpdated as $quiz) {
      file_put_contents("upload_update_test_file.txt",$quiz['name']. " | ",FILE_APPEND);
      file_put_contents("upload_update_test_file.txt",$quiz['quizID'] . " | ",FILE_APPEND);
      file_put_contents("upload_update_test_file.txt",$quiz['pointsOfInterest'] . "\n",FILE_APPEND);


      //try catch
      try {
      $decodedPointsForQuiz = json_decode($quiz['pointsOfInterest'],true);
      $stmt->execute([$quiz['name'],$quiz['quizID']]);

      $stmt2->execute([$quiz['quizID']]);
      foreach ($decodedPointsForQuiz as $point) {
        $stmt3->execute([$point['pointOfInterestID'],$quiz['quizID']]);
      }
    }
    catch (PDOException $e) {
      $violation = array();
      $violation['table'] = "Quizzes";
      $violation['action'] = "update";
      $violation['unique_attribute'] = $quiz['name'];
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

          file_put_contents("upload_error_log.txt", 'insert of ' . $quiz['title'] . ' with code ' . $e->getCode() . ' duplicate name ' . "\n",FILE_APPEND);
          file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
      }
      else if ($e->getCode() == 22001) {
        file_put_contents("upload_error_log.txt", 'insert of ' . $quiz['title'] . ' with code ' . $e->getCode() . ' exceeded varchar limit ' . "\n",FILE_APPEND);
        file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
          $violation['reason'] = "exceeded varchar limit";
      }
      else {
        file_put_contents("upload_error_log.txt", 'insert of ' . $quiz['title'] . ' failed with error ' . $e->getMessage(). ' and the code was ' . $e->getCode() . "\n",FILE_APPEND);
        file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
        $violation['reason'] = "unknown";
        //throw $e;
      }
      array_push($databaseViolations, $violation);
    }
  }

  $stmt = null;
  $stmt2 = null;
  $stmt3 = null;
  $pdo = null;
?>
