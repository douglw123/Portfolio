<?php
  //require 'get_db_handle.php';
  //require GET_DB_HANDLE_PATH."/get_db_handle.php";
  require 'get_db_handle.php';
  $pdo = get_db_handle();

  if (isset($_POST["username"]) && isset($_POST["password"])){
    $username = $_POST["username"];
    $password = $_POST["password"];
    file_put_contents("php_log_file.txt","password and username both set -> username: " . $username . "password: " . $password . "\n",FILE_APPEND);
    $userResultArray = array();
    $stmt = $pdo->prepare('SELECT * FROM Users WHERE username = ? AND password = crypt(?, password) AND isBanned = ?;');
    $stmt->execute([$username,$password,'false']);
    while ($row = $stmt->fetch()){
      array_push($userResultArray, $row);
    }
   //file_put_contents("output.txt","\n" . json_encode(array('user' => $userResultArray)),FILE_APPEND);
   file_put_contents("php_log_file.txt","json_encode of user data returned" . "\n",FILE_APPEND);
   echo json_encode(array('user' => $userResultArray));
  }
  else {
    file_put_contents("php_log_file.txt","username and password post data were not set\n",FILE_APPEND);
  }

  //return user results here or in other file?

  $stmt = null;
  $conn = null;
?>
