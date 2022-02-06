<?php

$conn = new mysqli("db", "app", "app", "app");

if ($conn->connect_error) {
    echo $conn->connect_error;
} else {
    echo "\nConnection succeeded";
}