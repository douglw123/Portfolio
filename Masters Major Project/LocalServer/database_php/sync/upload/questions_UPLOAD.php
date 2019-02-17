<?php
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  $questionsJSONString = $_POST["questionsJSON"];
  $decodedQuestions = json_decode($questionsJSONString,true);


    file_put_contents("upload_test_file.txt",print_r($decodedQuestions,true). "\n",FILE_APPEND);
    $stmt = $pdo->prepare('INSERT INTO Questions (userid,quizid,question,answer,dateCreatedOnDeviceTimestamp) VALUES (?,?,?,?,?)');
    $stmt2 = $pdo->prepare('SELECT quizid FROM Quizzes where name = ? and dateCreatedOnDeviceTimestamp = ?;');

    foreach ($decodedQuestions as $question) {
      file_put_contents("upload_test_file.txt",$question['question']. " | ",FILE_APPEND);
      file_put_contents("upload_test_file.txt",$question['answer']. " | ",FILE_APPEND);
      file_put_contents("upload_test_file.txt",$question['quizID']. "\n",FILE_APPEND);

      //try catch need to add if id is 0
      try {
        if ($question['quizID'] == '0') {
          file_put_contents("upload_test_file.txt",$question['question'] . ' the quizID for this question was 0' . "\n",FILE_APPEND);
          $stmt2->execute([$question['quizName'],$question['quizDateCreatedOnDevice']]);
          $quizWithID = $stmt2->fetch();

          file_put_contents("upload_test_file.txt",'printr of retirved quiz' . "\n" . print_r($quizWithID,true). "\n",FILE_APPEND);

          $question['quizID'] = (int)reset($quizWithID);
          file_put_contents("upload_test_file.txt",'the id retrived was ' . $question['quizID'] . "\n",FILE_APPEND);

        }


      $stmt->execute([$question['userID'],$question['quizID'],$question['question'],$question['answer'],$question['dateCreated']]);
    }
    catch (PDOException $e) {
      $violation = array();
      $violation['table'] = "Questions";
      $violation['action'] = "insert";
      $violation['unique_attribute'] = $question['question'];
      $violation['unique_attribute_date_created'] = $question['dateCreatedOnDeviceTimestamp'];
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

          file_put_contents("upload_error_log.txt", 'insert of ' . $question['question'] . ' with code ' . $e->getCode() . ' duplicate question ' . "\n",FILE_APPEND);
          file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
      }
      else if ($e->getCode() == 22001) {
        file_put_contents("upload_error_log.txt", 'insert of ' . $question['question'] . ' with code ' . $e->getCode() . ' exceeded varchar limit ' . "\n",FILE_APPEND);
        file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
          $violation['reason'] = "exceeded varchar limit";
      }
      else {
        file_put_contents("upload_error_log.txt", 'insert of ' . $question['question'] . ' failed with error ' . $e->getMessage(). ' and the code was ' . $e->getCode() . "\n",FILE_APPEND);
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
