<?php
  require 'get_db_handle.php';
  $pdo = get_db_handle();

  if (isset($_POST["adminUser"])){

    $adminUserJSONString = $_POST["adminUser"];
    $decodedAdminUser = json_decode($adminUserJSONString,true);

    file_put_contents("php_log_file.txt","adminUser set with username: " . $decodedAdminUser['username'] . "\n",FILE_APPEND);
    $userResultArray = array();
    $stmt = $pdo->prepare('SELECT * FROM Users WHERE username = ? AND password = crypt(?, password) AND isBanned = ? AND isAdministrator = ?;');
    $stmt2 = $pdo->prepare('UPDATE Users SET isBanned = ? WHERE username = ?;');

    $stmt->execute([$decodedAdminUser['username'],$decodedAdminUser['password'],'false','true']);
    while ($row = $stmt->fetch()){
      array_push($userResultArray, $row);
    }

    if (count($userResultArray) != 0) {
      $userJSONString = $_POST["user"];
      $decodedUser = json_decode($userJSONString,true);

      $stmt2->execute([$decodedUser['isBanned'],$decodedUser['username']]);
      $status = new \stdClass();
      $status->isbanned = $decodedUser['isBanned'];
      echo json_encode($status);
    }

  }
  else {
    file_put_contents("php_log_file.txt","adminUser post data was not set\n",FILE_APPEND);
  }

  $stmt = null;
  $stmt2 = null;
  $pdo = null;
?>
