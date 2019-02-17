<?php
  file_put_contents("php_log_file.txt","size of point of interest array -> size: ". sizeof($pointsOfInterestResultArray) ."\n",FILE_APPEND);
  file_put_contents("php_log_file.txt","size of quiz array -> size: ". sizeof($quizzesResultArray) ."\n",FILE_APPEND);
  file_put_contents("php_log_file.txt","size of point of interest quiz link array -> size: ". sizeof($pointsOfInterestQuizzesResultArray) ."\n",FILE_APPEND);
  file_put_contents("php_log_file.txt","size of question array -> size: ". sizeof($questionsResultArray) ."\n",FILE_APPEND);
  file_put_contents("php_log_file.txt","size of point of interest tombstone array -> size: ". sizeof($pointOfInterestTombstoneResultArray) ."\n",FILE_APPEND);
  file_put_contents("php_log_file.txt","size of quiz tombstone array -> size: ". sizeof($quizTombstoneResultArray) ."\n",FILE_APPEND);
  file_put_contents("php_log_file.txt","size of question tombstone array -> size: ". sizeof($questionTombstoneResultArray) ."\n",FILE_APPEND);

  file_put_contents("php_log_file.txt","Last connection time of device -> time: " . $lastConnectionTimestampLocal . ", size of update arrays -> point of interest size: " . sizeof($updatePointsOfInterestResultArray) . ", Quizzes size: ". sizeof($updateQuizzesResultArray) . ", Questions size: " . sizeof($updateQuestionsResultArray) . "\n",FILE_APPEND);
?>
