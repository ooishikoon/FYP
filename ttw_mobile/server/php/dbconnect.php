<?php
$servername = "localhost";
$username = "moneymon_277290_fyp_ttw_admin";
$password = "9MGxE;h#uxYD";
$dbname = "moneymon_277290_fyp_ttw";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error){
    die("Connection failed: " . $conn->connect_error);
}
?>