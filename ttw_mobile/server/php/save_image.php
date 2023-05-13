<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

// Get the user email and image data from the POST request
$user_email = $_POST['email'];
$image_name = $_POST['imagename'];
$image_data = $_POST['image'];
$image_text = $_POST['imagetext'];

// Prepare the SQL statement
$stmt = mysqli_prepare($conn, 'INSERT INTO tbl_image (image_id, image_name, image, image_text, user_email) VALUES (?, ?, ?, ?, ?)');

// Set the parameters and bind them to the statement
$image_id = null; // file_id is auto-incremented
mysqli_stmt_bind_param($stmt, 'issss', $image_id, $image_name, $image_data, $image_text, $user_email);

// Execute the statement and check for errors
if (!mysqli_stmt_execute($stmt)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

// Get the ID of the inserted row
$image_id = mysqli_insert_id($conn);

// Save the file to a folder
$uploads_dir = __DIR__ . '/../assets/image/';
if (!file_exists($uploads_dir)) {
    mkdir($uploads_dir, 0777, true);
}
$file_path = $uploads_dir . $image_id . '.jpg';
$image_data = base64_decode($image_data);
if (!file_put_contents($file_path, $image_data)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

// Close the statement and the database connection
mysqli_stmt_close($stmt);
mysqli_close($conn);

// Return a JSON response
$response = array('status' => 'success');
sendJsonResponse($response);

function sendJsonResponse($response) {
    header('Content-Type: application/json');
    echo json_encode($response);
}
?>
