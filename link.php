<?php

error_reporting(0);
// on se connect à localhost au port 3307
//$link = mysqli_connect('localhost:3306', 'user', 'oc', 'oc_pizza');
$adress = $_POST['adress'];
$user = $_POST['user'];
$pwd = $_POST['pwd'];
$db = $_POST['db'];

$response = array();

$link = mysqli_connect($adress, $user, $pwd, $db);

if (!$link) {
    array_push($response, 'Connexion impossible');
    echo json_encode($response);
    //die ('Connexion impossible');
}
 



array_push($response, 'Vous êtes connecté à oc_pizza');

$sql = $link->query("SHOW TABLES");
$nbr_table = $sql->num_rows;
array_push($response, 'cette base de données est composée de ' . strval($nbr_table) . ' table(s)');
    

//$sql = "SELECT name FROM ingredient";
//$result = $link->query($sql);

/* Récupère un tableau d'objets */
/*
while ($row = $result->fetch_row()) {
    array_push($response, $row[0]);
    
}
 */

echo json_encode($response);

mysqli_close($link);
?>
