const mysql = require('mysql2/promise');

// Configuration de la base de données
const pool = mysql.createPool({
    host: 'localhost',
    user: 'root', // Ton nom d'utilisateur MySQL
    password: '', // Ton mot de passe MySQL
    database: 'film_rating_db'
});

module.exports = pool; // Exporte la connexion pour l'utiliser dans le projet
