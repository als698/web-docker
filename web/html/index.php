<?php

$conn = new mysqli("localhost", "dbus3r", "dbpas", "app");

if ($conn->connect_error) {
    echo $conn->connect_error;
} else {
    echo "\nConnection succeeded";
}