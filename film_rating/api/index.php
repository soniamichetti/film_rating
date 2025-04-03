<?php
// Activer CORS pour permettre les requêtes depuis le frontend
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

// Inclure la configuration
require_once "./config/database.php";

// Récupérer la méthode et l'URL de la requête
$method = $_SERVER['REQUEST_METHOD'];
$request = explode('/', trim($_SERVER['PATH_INFO'] ?? '', '/'));

// Déterminer le contrôleur à utiliser
$controller = $request[0] ?? 'home';
$action = $request[1] ?? 'index';
$id = $request[2] ?? null;

// Inclure le contrôleur approprié
$controllerFile = "./controllers/{$controller}.php";
if (file_exists($controllerFile)) {
    require_once $controllerFile;
    
    // Appeler la fonction correspondante
    $functionName = $action . ucfirst(strtolower($method));
    if (function_exists($functionName)) {
        $response = $functionName($id);
        echo json_encode($response);
    } else {
        http_response_code(404);
        echo json_encode(["error" => "Action non trouvée"]);
    }
} else {
    http_response_code(404);
    echo json_encode(["error" => "Contrôleur non trouvé"]);
}
?>