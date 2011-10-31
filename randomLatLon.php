<?php
header('Cache-Control: no-cache, must-revalidate');
header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
header('Content-type: application/json');

if(isset($_GET["nb"])){
	$nbPoint = $_GET['nb'];
}
else{
	$nbPoint = 100;	
	}
$return = array();

for ($counter = 1; $counter <= $nbPoint; $counter++){
	//random latitude (between quebec and montreal)
	$latitude = rand(4550, 4680)/100;
	//random longitude (between quebec and montreal)
	$longitude = rand(-7122, -7400)/100;
	$return[] = array('id'=>"point" . $counter, 'lat'=>$latitude, 'lon'=>$longitude, 'description'=>'blablabla'.$counter);
}
echo json_encode($return);