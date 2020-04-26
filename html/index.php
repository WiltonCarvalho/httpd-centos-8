<?php

$host = getenv('HOST');
$ip = $_SERVER['SERVER_ADDR'];

echo "<div style ='font:111px/121px Arial,tahoma,sans-serif;color:orange'> <div style ='text-align:center'> $host </div>";
echo "<div style ='font:111px/121px Arial,tahoma,sans-serif;color:orange'> <div style ='text-align:center'> $ip </div>";

if ( getenv('HOST') == "inside1" ) {
echo "<body style='background-color:red'>";
}

if ( getenv('HOST') == "inside2" ) {
echo "<body style='background-color:green'>";
}

if ( getenv('HOST') == "inside3" ) {
echo "<body style='background-color:blue'>";
}

?>
