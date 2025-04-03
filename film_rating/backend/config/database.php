<?
// Configuration de la base de données
define('DB_HOST', 'localhost');
define('DB_NAME', 'film_rating_db');
define('DB_USER', 'root');
define('DB_PASS', ''); // Mot de passe par défaut de Laragon

// Fonction de connexion
function getConnection() {
    try {
        $conn = new PDO("mysql:host=".DB_HOST.";dbname=".DB_NAME, DB_USER, DB_PASS);
        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        return $conn;
    } catch(PDOException $e) {
        echo "Erreur de connexion: " . $e->getMessage();
        exit;
    }
}
?>