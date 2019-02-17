<?php
if (isset($_POST["type"])) {
  //curl --data "username=testUserName3&password=password3" http://localhost:8888/HistoricalQuizzesServerSidePDO.php
  $type = $_POST["type"];
  file_put_contents("php_log_file.txt","type was set -> type:". $type ."\n",FILE_APPEND);

  if ($type == "user") {
    require_once 'login_check.php';
  }
  elseif ($type == "register") {
    require_once 'register_user.php';
    $registerAndExceptionArray = array('userRegister' => $userRegisterArray,'databaseViolations'=> $databaseViolations);
    echo json_encode($registerAndExceptionArray);
  }
  elseif ($type == "getAllUsers") {
    require_once 'get_all_users.php';
  }
  elseif ($type == "changeBanStatus") {
    require_once 'change_ban_status_for_user.php';
  }
  elseif ($type == "sync") {
      require_once 'sync/upload/points_of_interest_UPLOAD.php';
      require_once 'sync/upload/quizzes_UPLOAD.php';
      require_once 'sync/upload/questions_UPLOAD.php';
      require_once 'sync/upload/wrong_answers_UPLOAD.php';

      require_once 'sync/upload/change_requests/points_of_interest_change_requests_UPLOAD.php';
      require_once 'sync/upload/change_requests/quizzes_change_requests_UPLOAD.php';
      require_once 'sync/upload/change_requests/questions_change_requests_UPLOAD.php';

      require_once 'sync/upload/deletes/points_of_interest_DELETE.php';
      require_once 'sync/upload/deletes/quizzes_DELETE.php';
      require_once 'sync/upload/deletes/questions_DELETE.php';

      require_once 'sync/upload/deletes/change_requests/point_of_interest_change_requests_DELETE.php';
      require_once 'sync/upload/deletes/change_requests/quiz_change_requests_DELETE.php';
      require_once 'sync/upload/deletes/change_requests/question_change_requests_DELETE.php';

      require_once 'sync/upload/updates/points_of_interest_UPDATES.php';
      require_once 'sync/upload/updates/quizzes_UPDATES.php';
      require_once 'sync/upload/updates/questions_UPDATES.php';
      require_once 'sync/upload/updates/wrong_answers_UPDATES.php';

      require_once 'sync/inserts_SYNC/points_of_interest_INSERT.php';
      require_once 'sync/inserts_SYNC/quizzes_INSERT.php';
      require_once 'sync/inserts_SYNC/questions_INSERT.php';
      require_once 'sync/inserts_SYNC/wrong_answers_INSERT.php';

      require_once 'sync/inserts_SYNC/change_requests/points_of_interest_change_requests_INSERT.php';
      require_once 'sync/inserts_SYNC/change_requests/quizzes_change_requests_INSERT.php';
      require_once 'sync/inserts_SYNC/change_requests/questions_change_requests_INSERT.php';

      require_once 'sync/tombstone_tables_SYNC/points_of_interst_TOMB.php';
      require_once 'sync/tombstone_tables_SYNC/quizzes_TOMB.php';
      require_once 'sync/tombstone_tables_SYNC/questions_TOMB.php';
      require_once 'sync/tombstone_tables_SYNC/wrong_answers_TOMB.php';

      require_once 'sync/tombstone_tables_SYNC/change_requests/point_of_interest_change_requests_TOMB.php';
      require_once 'sync/tombstone_tables_SYNC/change_requests/quiz_change_requests_TOMB.php';
      require_once 'sync/tombstone_tables_SYNC/change_requests/question_change_requests_TOMB.php';

      require_once 'sync/updates_SYNC/main_UPDATES.php';

      require_once 'sync/log_connection.php';
      //$currentDataAndTime = date('Y-m-d G:i:s');
      $currentDataAndTime = new DateTime();
      // file_put_contents("php_log_file.txt","sync completed at ". $currentDataAndTime ."\n",FILE_APPEND);
      file_put_contents("php_log_file.txt","sync completed at ". $currentDataAndTime->format('Y-m-d G:i:s.v') ."\n",FILE_APPEND);

      $newInsertsArray = array('pointsOfInterest' => $pointsOfInterestResultArray,'quizzes'=> $quizzesResultArray,'pointsOfInterestQuizzes' => $pointsOfInterestQuizzesResultArray,'questions' => $questionsResultArray,'pointsOfInterestTombstone' => $pointOfInterestTombstoneResultArray,'questionsTombstone' => $questionTombstoneResultArray,'quizTombstone' => $quizTombstoneResultArray,'updatePointsOfInterest' => $updatePointsOfInterestResultArray,'lastConnectionTimestampLocal' => $currentDataAndTime->format('Y-m-d G:i:s.v'),'updateQuizzes' => $updateQuizzesResultArray);
      $newInsertsArray += ['updateQuestions' => $updateQuestionsResultArray,'updateWrongAnswers' => $updateWrongAnswersResultArray,'wrongAnswersTombstone' => $wrongAnswerTombstoneResultArray,'wrongAnswers' => $wrongAnswerResultArray];

      $newInsertsArray += ['pointsOfInterestChangeRequests' => $pointOfInterestChangeRequestsResultArray];
      $newInsertsArray += ['quizzesChangeRequests' => $quizChangeRequestsResultArray];
      $newInsertsArray += ['questionsChangeRequests' => $questionChangeRequestsResultArray];

      $newInsertsArray += ['pointOfInterestChangeRequestsTombstone' => $pointOfInterestChangeRequestTombstoneResultArray];
      $newInsertsArray += ['quizChangeRequestsTombstone' => $quizChangeRequestTombstoneResultArray];
      $newInsertsArray += ['questionChangeRequestsTombstone' => $questionChangeRequestTombstoneResultArray];

      $newInsertsArray += ['databaseViolations' => $databaseViolations];

      file_put_contents("upload_error_log.txt", 'databaseViolations array = ' . print_r($databaseViolations,true) . "\n \n",FILE_APPEND);
      echo json_encode($newInsertsArray);
    }
}
else {
    file_put_contents("php_log_file.txt","type post data was not set\n",FILE_APPEND);
}
file_put_contents("php_log_file.txt","------------------------------------------------------------\n",FILE_APPEND);
?>
