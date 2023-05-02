<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

// Get the user email and image data from the POST request
$user_email = $_POST['email'];
$file_name = $_POST['filename'];
$image_data = base64_decode($_POST['image']);

// Prepare the SQL statement
$stmt = mysqli_prepare($conn, 'INSERT INTO tbl_file (file_id, file_name, file, user_email) VALUES (?, ?, ?, ?)');

// Set the parameters and bind them to the statement
mysqli_stmt_bind_param($stmt, 'ssss', $file_id, $file_name, $image_data, $user_email);

// Execute the statement
mysqli_stmt_execute($stmt);

// Close the statement and the database connection
mysqli_stmt_close($stmt);
mysqli_close($conn);

// Return a JSON response
$response = array('status' => 'success');
echo json_encode($response);
?>