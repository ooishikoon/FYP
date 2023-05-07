<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

// Get the user email and image data from the POST request
$user_email = $_POST['email'];
$pdf_name = $_POST['pdfname'];
$pdf = $_POST['pdf_file'];

// Decode base64 data
$pdf_data = base64_decode($pdf);

// Prepare the SQL statement
$stmt = mysqli_prepare($conn, 'INSERT INTO tbl_pdf (pdf_id, pdf_name, pdf, user_email) VALUES (?, ?, ?, ?)');

// Set the parameters and bind them to the statement
$pdf_id = null; // file_id is auto-incremented
mysqli_stmt_bind_param($stmt, 'ssss', $pdf_id, $pdf_name, $pdf_data, $user_email);

// Execute the statement and check for errors
if (!mysqli_stmt_execute($stmt)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

// Get the ID of the inserted row
$pdf_id = mysqli_insert_id($conn);

// Save the file to a folder
$uploads_dir = __DIR__ . '/../assets/pdf/';
if (!file_exists($uploads_dir)) {
    mkdir($uploads_dir, 0777, true);
}
$file_path = $uploads_dir . $pdf_id . '.pdf';
if (!file_put_contents($file_path, $pdf_data)) {
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