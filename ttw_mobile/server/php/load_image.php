<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$user_email = $_POST['email'];
$sqlloadfile = "SELECT * FROM tbl_image WHERE tbl_image.user_email = '$user_email'";

$result = $conn->query($sqlloadfile);
$number_of_result = $result->num_rows;
if ($result->num_rows > 0) {
    $images["images"] = array();
    while ($row = $result->fetch_assoc()) {
        $imageList = array();
        $imageList['image_id'] = $row['image_id'];
        $imageList['image_name'] = $row['image_name'];
        $imageList['user_email'] = $row['user_email'];
        array_push($images["images"],$imageList);
    }
    $response = array('status' => 'success', 'data' => $images);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>