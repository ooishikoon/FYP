<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

// Get POST data
$user_email = $_POST['email'];
$file_name = $_POST['filename'];
$file = $_POST['file_data'];

// Decode base64 data
$pdf_data = base64_decode($file);

// Prepare the SQL statement
$stmt = mysqli_prepare($conn, 'INSERT INTO tbl_file (file_id, file_name, file, user_email) VALUES (?, ?, ?, ?)');

// Set the parameters and bind them to the statement
mysqli_stmt_bind_param($stmt, 'ssss', $file_id, $file_name, $pdf_data, $user_email);

// Execute SQL statement
if ($stmt->execute()) {
  // Return success message
  echo "PDF saved successfully.";
} else {
  // Return error message
  echo "Failed to save PDF.";
}

?>