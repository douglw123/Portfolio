<?php
  require_once 'get_db_handle.php';

  $pdo = get_db_handle();

  $newUserJSONString = $_POST["newUserJSON"];
  $newUserDecoded = json_decode($newUserJSONString,true);


    file_put_contents("register_test_file.txt",print_r($newUserDecoded,true). "\n",FILE_APPEND);
    $stmt = $pdo->prepare('INSERT INTO Users (username,password,firstName,lastName,email) VALUES (?,?,?,?,?)');
    $databaseViolations = array();

    $userRegisterArray = array();
    // foreach ($newUserDecoded as $newUser) {
    $newUser = $newUserDecoded;
      file_put_contents("register_test_file.txt",$newUser['firstName']. " | ",FILE_APPEND);
      file_put_contents("register_test_file.txt",$newUser['lastName']. " | ",FILE_APPEND);
      file_put_contents("register_test_file.txt",$newUser['username']. "\n",FILE_APPEND);

      //try catch
      try {
      $stmt->execute([$newUser['username'],$newUser['password'],$newUser['firstName'],$newUser['lastName'],$newUser['email']]);
      //$stmt->execute([$newUser['username'],crypt($newUser['password'], gen_salt('bf', 8)),$newUser['firstName'],$newUser['lastName'],$newUser['email']]);
      $userID = $pdo->lastInsertId();
      file_put_contents("register_test_file.txt",$userID. "\n",FILE_APPEND);
      $newUserArray = array();
      $newUserArray['userID'] = $userID;
      $newUserArray['username'] = $newUser['username'];
      array_push($userRegisterArray, $newUserArray);
    }
    catch (PDOException $e) {
      $violation = array();
      $violation['table'] = "Users";
      $violation['action'] = "insert";
      $violation['unique_attribute'] = $newUser['username'];
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

          file_put_contents("upload_error_log.txt", 'insert of ' . $newUser['username'] . ' with code ' . $e->getCode() . ' duplicate username ' . "\n",FILE_APPEND);
          file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
      }
      else if ($e->getCode() == 22001) {
        file_put_contents("upload_error_log.txt", 'insert of ' . $newUser['username'] . ' with code ' . $e->getCode() . ' exceeded varchar limit ' . "\n",FILE_APPEND);
        file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
          $violation['reason'] = "exceeded varchar limit";
      }
      else {
        file_put_contents("upload_error_log.txt", 'insert of ' . $$newUser['username'] . ' failed with error ' . $e->getMessage(). ' and the code was ' . $e->getCode() . "\n",FILE_APPEND);
        file_put_contents("upload_error_log.txt", 'info for error is ' . print_r($stmt->errorInfo(),true) . "\n \n",FILE_APPEND);
        $violation['reason'] = "unknown";
        //throw $e;
      }
      array_push($databaseViolations, $violation);
    }
  // }

  $stmt = null;
  $pdo = null;
?>
