const express = require('express');
const cors = require('cors'); // Si tu utilises CORS
const bcrypt = require('bcrypt');
const pool = require('./config/database');
const jwt = require('jsonwebtoken');


const app = express(); // Initialisation de l'application Express

app.use(cors()); // Activer CORS pour éviter des problèmes avec le frontend
app.use(express.json()); // Parse le JSON envoyé dans les requêtes


app.get('/films', async (req, res) => {
    try {
      // Requête pour récupérer tous les films avec leurs réalisateurs
      const [rows] = await pool.query(`
        SELECT 
          f.id, f.titre, f.annee, f.synopsis, f.affiche, f.duree,
          r.nom AS realisateur_nom, r.prenom AS realisateur_prenom,
          GROUP_CONCAT(g.libelle SEPARATOR ', ') AS genres
        FROM films f
        JOIN realisateurs r ON f.realisateur_id = r.id
        LEFT JOIN film_genre fg ON f.id = fg.film_id
        LEFT JOIN genres g ON fg.genre_id = g.id
        GROUP BY f.id;
      `);
      res.json(rows); // Envoie la liste des films au frontend
    } catch (error) {
      console.error('Erreur lors de la récupération des films :', error.message);
      res.status(500).json({ message: 'Erreur serveur' });
    }
  });
  


  // Endpoint pour l'inscription
  app.post('/register', async (req, res) => {
    const { nom, prenom, email, mot_de_passe } = req.body;
  
    try {
      // Vérifie si l'email existe déjà
      const [existingUser] = await pool.query('SELECT * FROM utilisateurs WHERE email = ?', [email]);
      if (existingUser.length > 0) {
        return res.status(400).json({ message: 'Cet email est déjà utilisé.' });
      }
  
      // Hachage du mot de passe
      const hashedPassword = await bcrypt.hash(mot_de_passe, 10);
  
      // Insère un nouvel utilisateur dans la base de données
      const result = await pool.query(
        'INSERT INTO utilisateurs (nom, prenom, email, mot_de_passe) VALUES (?, ?, ?, ?)',
        [nom, prenom, email, hashedPassword]
      );
  
      // Réponse réussie
      res.status(201).json({ message: 'Utilisateur inscrit avec succès.' });
    } catch (error) {
      console.error('Erreur lors de l\'inscription :', error.message);
      res.status(500).json({ message: 'Erreur serveur.' });
    }
  });
  
  app.post('/login', async (req, res) => {
    const { email, mot_de_passe } = req.body;
  
    try {
      // Vérification des champs obligatoires
      if (!email || !mot_de_passe) {
        return res.status(400).json({ message: 'Email et mot de passe sont requis.' });
      }
  
      // Récupération de l'utilisateur dans la base de données
      const [rows] = await pool.query('SELECT * FROM utilisateurs WHERE email = ?', [email]);
      if (rows.length === 0) {
        return res.status(404).json({ message: 'Utilisateur non trouvé.' });
      }
  
      const utilisateur = rows[0];
      console.log('Utilisateur trouvé :', utilisateur); // Log utile pour vérifier les données récupérées
  
      // Vérification du mot de passe haché
      if (!utilisateur.mot_de_passe) {
        console.error('Mot de passe non défini pour cet utilisateur dans la base de données.');
        return res.status(500).json({ message: 'Erreur serveur. Mot de passe manquant.' });
      }
  
      const isPasswordValid = await bcrypt.compare(mot_de_passe, utilisateur.mot_de_passe);
      if (!isPasswordValid) {
        return res.status(401).json({ message: 'Mot de passe incorrect.' });
      }
  
      // Génération du token JWT
      const token = jwt.sign(
        { id: utilisateur.id, role: utilisateur.role }, // Charge utile
        process.env.JWT_SECRET || 'SECRET_KEY', // Clé secrète sécurisée depuis un fichier `.env`
        { expiresIn: '1h' }
      );
  
      // Réponse avec le token et l'id de l'utilisateur
      res.json({ token, userId: utilisateur.id, message: 'Connexion réussie.' });
    } catch (error) {
      console.error('Erreur lors de la connexion :', error.message);
      res.status(500).json({ message: 'Erreur serveur.' });
    }
  });
  
  
  app.put('/profil', async (req, res) => {
    try {
      const authHeader = req.headers.authorization;
      if (!authHeader) {
        return res.status(401).json({ message: 'Non autorisé.' });
      }
  
      const token = authHeader.split(' ')[1];
      const decoded = jwt.verify(token, 'SECRET_KEY'); // Décoder le token pour récupérer l'ID
  
      const { prenom, nom, password, email } = req.body; // Récupère l'email en plus des autres champs
  
      // Hachage du mot de passe si modifié
      let updateFields = { prenom, nom, email }; // Inclut l'email dans les champs à mettre à jour
      if (password) {
        const bcrypt = require('bcrypt');
        const hashedPassword = await bcrypt.hash(password, 10);
        updateFields.mot_de_passe = hashedPassword;
      }
  
      // Mise à jour dans la base
      await pool.query(
        'UPDATE utilisateurs SET ? WHERE id = ?',
        [updateFields, decoded.id]
      );
  
      res.json({ message: 'Profil mis à jour avec succès.' });
    } catch (error) {
      console.error('Erreur lors de la mise à jour du profil :', error.message);
      res.status(500).json({ message: 'Erreur serveur.' });
    }
  });
  
  

app.get('/profil', async (req, res) => {
  console.log('Requête reçue pour /profil');
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader) {
      return res.status(401).json({ message: 'Non autorisé.' });
    }

    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, 'SECRET_KEY');
    const [rows] = await pool.query(
      'SELECT nom, prenom, email, date_inscription FROM utilisateurs WHERE id = ?',
      [decoded.id]
    );

    if (rows.length === 0) {
      return res.status(404).json({ message: 'Utilisateur non trouvé.' });
    }

    res.json(rows[0]);
  } catch (error) {
    console.error('Erreur backend :', error.message);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
});




app.get('/films/:id', async (req, res) => {
  try {
    const filmId = req.params.id; // ID récupéré depuis l'URL

    const [film] = await pool.query(`
      SELECT f.id, f.titre, f.annee, f.synopsis, f.affiche, f.duree,
             r.prenom AS realisateur_prenom, r.nom AS realisateur_nom,
             GROUP_CONCAT(g.libelle) AS genres
      FROM films f
      JOIN realisateurs r ON f.realisateur_id = r.id
      JOIN film_genre fg ON f.id = fg.film_id
      JOIN genres g ON fg.genre_id = g.id
      WHERE f.id = ?
      GROUP BY f.id
    `, [filmId]);

    if (!film.length) {
      return res.status(404).json({ message: 'Film non trouvé.' });
    }

    const [acteurs] = await pool.query(`
      SELECT a.id, a.prenom, a.nom
      FROM film_acteur fa
      JOIN acteurs a ON fa.acteur_id = a.id
      WHERE fa.film_id = ?
    `, [filmId]);
    film[0].acteurs = acteurs.map(a => `${a.prenom} ${a.nom}`); // Transforme en un tableau de noms complets
    console.log('Acteurs récupérés :', acteurs);

    res.json(film[0]);
  } catch (error) {
    console.error('Erreur backend :', error.message);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
});

app.post('/notations', async (req, res) => {
  try {
    const { utilisateur_id, film_id, note, commentaire } = req.body;

    // Log pour confirmer les données reçues
    console.log('Données reçues par le backend :', { utilisateur_id, film_id, note, commentaire });

    if (!utilisateur_id || !film_id || !note) {
      return res.status(400).json({ message: 'Les champs utilisateur_id, film_id et note sont obligatoires.' });
    }

    // Ajout ou mise à jour de la notation
    const [existingNotation] = await pool.query(
      'SELECT * FROM notations WHERE utilisateur_id = ? AND film_id = ?',
      [utilisateur_id, film_id]
    );

    if (existingNotation.length) {
      await pool.query(
        'UPDATE notations SET note = ?, commentaire = ?, date_notation = CURRENT_TIMESTAMP WHERE utilisateur_id = ? AND film_id = ?',
        [note, commentaire, utilisateur_id, film_id]
      );
      return res.json({ message: 'Notation mise à jour avec succès.' });
    }

    await pool.query(
      'INSERT INTO notations (utilisateur_id, film_id, note, commentaire) VALUES (?, ?, ?, ?)',
      [utilisateur_id, film_id, note, commentaire]
    );
    res.json({ message: 'Notation ajoutée avec succès.' });
  } catch (error) {
    console.error('Erreur lors de l\'ajout ou la modification de la notation :', error.message);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
});





app.get('/films/:id/notations', async (req, res) => {
  try {
    const filmId = req.params.id; // Récupère l'id du film dans l'URL

    // Récupère toutes les notations pour le film
    const [notations] = await pool.query(
      'SELECT n.note, n.commentaire, u.prenom, u.nom FROM notations n JOIN utilisateurs u ON n.utilisateur_id = u.id WHERE n.film_id = ?',
      [filmId]
    );

    // Calcule la note moyenne et le nombre de commentaires
    const [average] = await pool.query(
      'SELECT AVG(note) AS moyenne, COUNT(*) AS nombre FROM notations WHERE film_id = ?',
      [filmId]
    );

    res.json({
      notations,
      moyenne: average[0]?.moyenne || 0,
      nombre: average[0]?.nombre || 0
    });
  } catch (error) {
    console.error('Erreur lors de la récupération des notations :', error.message);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
});

app.post('/films', async (req, res) => {
  const { titre, annee, synopsis, affiche, duree, realisateur_id, genres, acteurs } = req.body;

  try {
    console.log('Données reçues pour le film :', req.body);

    // Insère le film dans la table `films`
    const [result] = await pool.query(
      'INSERT INTO films (titre, annee, synopsis, affiche, duree, realisateur_id) VALUES (?, ?, ?, ?, ?, ?)',
      [titre, annee, synopsis, affiche, duree, realisateur_id]
    );
    console.log('Film inséré avec succès, ID :', result.insertId);

    const filmId = result.insertId;

    // Insère les genres associés
    if (genres && genres.length > 0) {
      for (const genreId of genres) {
        console.log(`Ajout du genre ID : ${genreId}`);
        await pool.query(
          'INSERT INTO film_genre (film_id, genre_id) VALUES (?, ?)',
          [filmId, genreId]
        );
      }
    }

    // Insère les acteurs associés
    if (acteurs && acteurs.length > 0) {
      for (const acteur of acteurs) {
        console.log(`Insertion de la relation film_acteur : film_id=${filmId}, acteur_id=${acteur.id}`);
        await pool.query(
          'INSERT INTO film_acteur (film_id, acteur_id) VALUES (?, ?)', // Retiré "role"
          [filmId, acteur.id]
        );
      }
    }

    res.json({ message: 'Film ajouté avec succès', filmId });
  } catch (error) {
    console.error('Erreur lors de l\'ajout du film :', error.message);
    res.status(500).json({ message: 'Erreur serveur : ' + error.message });
  }
});










app.post('/favoris', async (req, res) => {
  const { utilisateur_id, film_id } = req.body;

  try {
    if (!utilisateur_id || !film_id) {
      return res.status(400).json({ message: 'Utilisateur et film requis.' });
    }

    // Vérifie si le film est déjà dans les favoris
    const [rows] = await pool.query(
      'SELECT * FROM favoris WHERE utilisateur_id = ? AND film_id = ?',
      [utilisateur_id, film_id]
    );

    if (rows.length > 0) {
      // Supprime le favori s'il existe déjà
      await pool.query('DELETE FROM favoris WHERE utilisateur_id = ? AND film_id = ?', [utilisateur_id, film_id]);
      return res.json({ message: 'Film retiré des favoris.' });
    } else {
      // Ajoute le film en tant que favori
      await pool.query('INSERT INTO favoris (utilisateur_id, film_id) VALUES (?, ?)', [utilisateur_id, film_id]);
      return res.json({ message: 'Film ajouté aux favoris.' });
    }
  } catch (error) {
    console.error('Erreur lors de la gestion des favoris :', error.message);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
});




app.get('/favoris/:utilisateur_id', async (req, res) => {
  const { utilisateur_id } = req.params; // Récupère l'ID utilisateur depuis l'URL

  try {
    const [favoris] = await pool.query(
      `SELECT f.* FROM films f
       JOIN favoris fav ON f.id = fav.film_id
       WHERE fav.utilisateur_id = ?`,
      [utilisateur_id]
    );

    res.json(favoris); // Retourne la liste des films favoris
  } catch (error) {
    console.error('Erreur lors de la récupération des favoris :', error.message);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
});


app.delete('/films/:id', async (req, res) => {
  const { id } = req.params;

  try {
    // Supprime le film et ses associations
    await pool.query('DELETE FROM films WHERE id = ?', [id]);
    res.json({ message: 'Film supprimé avec succès' });
  } catch (error) {
    console.error('Erreur lors de la suppression du film :', error.message);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
});

app.get('/utilisateurs/:id', async (req, res) => {
  const { id } = req.params;

  try {
    // Requête pour récupérer l'utilisateur
    const [utilisateur] = await pool.query(
      'SELECT id, nom, prenom, email, role FROM utilisateurs WHERE id = ?',
      [id]
    );

    if (utilisateur.length === 0) {
      return res.status(404).json({ message: 'Utilisateur non trouvé.' });
    }

    // Retourne les données de l'utilisateur
    res.json(utilisateur[0]);
  } catch (error) {
    console.error('Erreur lors de la récupération de l\'utilisateur :', error.message);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
});


app.get('/genres', async (req, res) => {
  try {
    const [genres] = await pool.query('SELECT * FROM genres');
    res.json(genres);
  } catch (error) {
    console.error('Erreur lors de la récupération des genres :', error.message);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
});


app.get('/acteurs', async (req, res) => {
  try {
    const [acteurs] = await pool.query('SELECT * FROM acteurs');
    res.json(acteurs);
  } catch (error) {
    console.error('Erreur lors de la récupération des acteurs :', error.message);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
});



app.get('/realisateurs', async (req, res) => {
  try {
    const [realisateurs] = await pool.query('SELECT * FROM realisateurs');
    res.json(realisateurs);
  } catch (error) {
    console.error('Erreur lors de la récupération des réalisateurs :', error.message);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
});



const PORT = 3000; // Définit le port sur lequel le serveur sera accessible
app.listen(PORT, () => {
  console.log(`Serveur démarré sur http://localhost:${PORT}`);
});



