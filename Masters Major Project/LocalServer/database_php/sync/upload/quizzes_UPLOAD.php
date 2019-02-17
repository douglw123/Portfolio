<?php
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  $quizzesJSONString = $_POST["quizzesJSON"];
  $decodedQuizzes = json_decode($quizzesJSONString,true);
  //$decodedPoints = json_decode($decodedQuizzes['0']['pointsOfInterest'],true);

    file_put_contents("upload_test_file.txt",print_r($decodedQuizzes,true). "\n",FILE_APPEND);
    //file_put_contents("upload_test_file.txt","json decode of points = " . print_r($decodedPoints,true) . "\n \n",FILE_APPEND);
    $stmt = $pdo->prepare('INSERT INTO Quizzes (userid,name,dateCreatedOnDeviceTimestamp) VALUES (?,?,?)');
    $stmt2 = $pdo->prepare('SELECT PointOfInterestID FROM PointsOfInterest where isDeleted = ? and title = ?;');
    $stmt3 = $pdo->prepare('INSERT INTO PointsOfInterestQuizzes (PointOfInterestID,QuizID) VALUES (?,?)');

    //$databaseViolations = array();

    foreach ($decodedQuizzes as $quiz) {
      // file_put_contents("upload_test_file.txt",$pointOfInterest['title']. " | ",FILE_APPEND);
      // file_put_contents("upload_test_file.txt",$pointOfInterest['latitude']. " | ",FILE_APPEND);
      // file_put_contents("upload_test_file.txt",$pointOfInterest['longitude']. "\n",FILE_APPEND);

      //try catch
      try {
      $decodedPointsForQuiz = json_decode($quiz['pointsOfInterest'],true);
      //$dateOfQuizCreation = DateTime::createFromFormat('d-m-Y H:i:s.u', $quiz['dateCreated']);
      $stmt->execute([$quiz['userID'],$quiz['name'],$quiz['dateCreated']]);
      //(to_timestamp($quiz['dateCreated'], 'dd-mm-yyyy|HH24:MI:ss.MS'))

      $quizID = $pdo->lastInsertId();
      file_put_contents("upload_test_file.txt", 'the last id inserted was ' . $quizID . "\n",FILE_APPEND);
      foreach ($decodedPointsForQuiz as $point) {

        $stmt2->execute(["false",$point['title']]);

        $pointOfInterestReturned = $stmt2->fetch();
        $pointsOfInterestID =(int)reset($pointOfInterestReturned);

        $stmt3->execute([$pointsOfInterestID,$quizID]);
      }


    }
    catch (PDOException $e) {
      $violation = array();
      $violation['table'] = "Quizzes";
      $violation['action'] = "insert";
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

          file_put_contents("upload_error_log.txt", 'insert of ' . $quiz['name'] . ' with code ' . $e->getCode() . ' duplicate name ' . "\n",FILE_APPEND);
          file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
      }
      else if ($e->getCode() == 22001) {
        file_put_contents("upload_error_log.txt", 'insert of ' . $quiz['name'] . ' with code ' . $e->getCode() . ' exceeded varchar limit ' . "\n",FILE_APPEND);
        file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
          $violation['reason'] = "exceeded varchar limit";
      }
      else {
        file_put_contents("upload_error_log.txt", 'insert of ' . $quiz['name'] . ' failed with error ' . $e->getMessage(). ' and the code was ' . $e->getCode() . "\n",FILE_APPEND);
        file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
        $violation['reason'] = "unknown";
        //throw $e;
      }
      array_push($databaseViolations, $violation);
    }
    catch (Exception $e) {
      file_put_contents("upload_error_log.txt", 'insert of ' . $quiz['name'] . ' failed with error ' . $e->getMessage(). ' and the code was ' . $e->getCode() . "\n",FILE_APPEND);
      $violation['reason'] = "general unknown error";
      array_push($databaseViolations, $violation);
    }
  }

  $stmt = null;
  $stmt2 = null;
  $stmt3 = null;
  $pdo = null;
?>
