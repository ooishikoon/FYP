<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$email = $_POST['email'];
$password = sha1($_POST['password']);
$na = "na";

// Check whether the email already exists
$sqlcheck = "SELECT * FROM tbl_user WHERE user_email = '$email'";
$resultcheck = $conn->query($sqlcheck);

if ($resultcheck->num_rows > 0) {
    // Email already exists, return error response
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>