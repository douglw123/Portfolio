<?php
  /*
  Updates
  */

  //$lastConnectionTimestampLocal = date('Y-m-d G:i:s.v', strtotime($_POST["lastConnectionTimestampLocal"]));
  $updatePointsOfInterestResultArray = array();
  $updateQuizzesResultArray = array();
  $updateQuestionsResultArray = array();
  $updateWrongAnswersResultArray = array();
  if ($_POST["lastConnectionTimestampLocal"] != '0') {
    $lastConnectionTimestampLocalTimeObject = new DateTime($_POST["lastConnectionTimestampLocal"]);
    $lastConnectionTimestampLocal = $lastConnectionTimestampLocalTimeObject->format('Y-m-d G:i:s.v');
    file_put_contents("php_log_file.txt","last local connection timestamp was ". $lastConnectionTimestampLocal ."\n",FILE_APPEND);

    // if ($lastConnectionTimestampLocal != "1970-01-01 1:00:00") {
      require_once 'points_of_interest_UPDATES.php';
      require_once 'quizzes_UPDATES.php';
      require_once 'questions_UPDATES.php';
      require_once 'wrong_answers_UPDATES.php';
    // }
    // else {
    //   $lastConnectionTimestampLocal = "never";
    // }
  }
  else {
    //used in log file
    $lastConnectionTimestampLocal = 'never';
  }
?>
