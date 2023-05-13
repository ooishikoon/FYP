<?php

if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$user_email = $_POST['email'];
$sqlloadfile = "SELECT * FROM tbl_pdf WHERE tbl_pdf.user_email = '$user_email'";

$result = $conn->query($sqlloadfile);
$number_of_result = $result->num_rows;
if ($result->num_rows > 0) {
    $pdf["pdf"] = array();
    while ($row = $result->fetch_assoc()) {
        $pdfList = array();
        $pdfList['pdf_id'] = $row['pdf_id'];
        $pdfList['pdf_name'] = $row['pdf_name'];
        // $pdfList['pdf'] = $row['pdf'];
        $pdfList['pdf_text'] = $row['pdf_text'];
        $pdfList['user_email'] = $row['user_email'];
        array_push($pdf["pdf"],$pdfList);
    }
    $response = array('status' => 'success', 'data' => $pdf);
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