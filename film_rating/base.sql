-- Création de la base de données
CREATE DATABASE IF NOT EXISTS film_rating_db;
USE film_rating_db;

-- Table des utilisateurs
CREATE TABLE IF NOT EXISTS utilisateurs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL,
    date_inscription DATETIME DEFAULT CURRENT_TIMESTAMP,
    role ENUM('utilisateur', 'administrateur')  NOT NULL DEFAULT 'utilisateur'
);

-- Table des réalisateurs
CREATE TABLE IF NOT EXISTS realisateurs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    date_naissance DATE,
    biographie TEXT
);

-- Table des films
CREATE TABLE IF NOT EXISTS films (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(100) NOT NULL,
    annee INT NOT NULL,
    synopsis TEXT,
    affiche VARCHAR(255),
    duree INT COMMENT 'Durée en minutes',
    realisateur_id INT NOT NULL,
    date_ajout DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (realisateur_id) REFERENCES realisateurs(id) ON DELETE CASCADE
);

-- Table des genres
CREATE TABLE IF NOT EXISTS genres (
    id INT AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE
);

-- Table d'association film-genre (relation N-N)
CREATE TABLE IF NOT EXISTS film_genre (
    film_id INT NOT NULL,
    genre_id INT NOT NULL,
    PRIMARY KEY (film_id, genre_id),
    FOREIGN KEY (film_id) REFERENCES films(id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genres(id) ON DELETE CASCADE
);

-- Table des notations (relation N-N avec attributs)
CREATE TABLE IF NOT EXISTS notations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    utilisateur_id INT NOT NULL,
    film_id INT NOT NULL,
    note DECIMAL(2,1) NOT NULL CHECK (note >= 0 AND note <= 10),
    commentaire TEXT,
    date_notation DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_notation (utilisateur_id, film_id),
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id) ON DELETE CASCADE,
    FOREIGN KEY (film_id) REFERENCES films(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS notation_likes (
    utilisateur_id INT NOT NULL,
    notation_id INT NOT NULL,
    date_like DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (utilisateur_id, notation_id),
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id) ON DELETE CASCADE,
    FOREIGN KEY (notation_id) REFERENCES notations(id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS acteurs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    date_naissance DATE,
    biographie TEXT
);

CREATE TABLE IF NOT EXISTS film_acteur (
    film_id INT NOT NULL,
    acteur_id INT NOT NULL,
    role VARCHAR(100) NOT NULL,
    PRIMARY KEY (film_id, acteur_id),
    FOREIGN KEY (film_id) REFERENCES films(id) ON DELETE CASCADE,
    FOREIGN KEY (acteur_id) REFERENCES acteurs(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS favoris (
    utilisateur_id INT NOT NULL,
    film_id INT NOT NULL,
    PRIMARY KEY (utilisateur_id, film_id),
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id) ON DELETE CASCADE,
    FOREIGN KEY (film_id) REFERENCES films(id) ON DELETE CASCADE
);

ALTER TABLE notations ADD COLUMN date_modification DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE utilisateurs
MODIFY COLUMN role VARCHAR(255) NOT NULL DEFAULT 'utilisateur';



INSERT INTO genres (libelle) VALUES
('Drame'),
('Thriller'),
('Comédie'),
('Science-fiction'),
('Horreur'),
('Romance'),
('Animation'),
('Musical'),
('Guerre'),
('Fantastique'),
('Aventure'),
('Historique'),
('Western');


INSERT INTO realisateurs (prenom, nom) VALUES
('David', 'Fincher'),
('Jonathan', 'Demme'),
('Damien', 'Chazelle'),
('Michel', 'Ocelot'),
('Frank', 'Capra'),
('Robert', 'Wise'),
('David', 'Lynch'),
('Stanley', 'Kubrick'),
('Bong', 'Joon-ho'),
('Sergio', 'Leone'),
('Quentin', 'Tarantino'),
('George', 'Miller'),
('William', 'Friedkin'),
('John', 'Carpenter'),
('Ridley', 'Scott'),
('Alfred', 'Hitchcock'),
('Wes', 'Anderson'),
('Stanley', 'Donen'),
('Denis', 'Villeneuve'),
('Dario', 'Argento');


INSERT INTO acteurs (prenom, nom) VALUES
('Brad', 'Pitt'),
('Morgan', 'Freeman'),
('Jodie', 'Foster'),
('Ryan', 'Gosling'),
('Emma', 'Stone'),
('James', 'Stewart'),
('Jack', 'Nicholson'),
('Tom', 'Hanks'),
('Harrison', 'Ford'),
('Sigourney', 'Weaver');

INSERT INTO films (titre, annee, synopsis, affiche, duree, realisateur_id) VALUES
('Se7en', 1995, 'Deux détectives enquêtent sur un tueur en série qui met en scène les sept péchés capitaux.', 'se7en.jpg', 127, 1),
('Le Silence des agneaux', 1991, 'Un agent du FBI doit faire équipe avec un psychopathe pour traquer un autre tueur en série.', 'silence_des_agneaux.jpg', 118, 2),
('La La Land', 2016, 'Deux artistes tentent de réaliser leurs rêves à Los Angeles tout en naviguant leur relation amoureuse.', 'la_la_land.jpg', 128, 3),
('Azur et Asmar', 2006, 'Une aventure magique et poétique de deux amis d\'enfance issus de cultures différentes.', 'azur_et_asmar.jpg', 99, 4),
('La vie est belle', 1946, 'Un homme désespéré découvre l\'impact de sa vie grâce à un ange gardien.', 'la_vie_est_belle.jpg', 130, 5),
('West Side Story', 1961, 'Un amour impossible entre deux jeunes liés à des gangs rivaux.', 'west_side_story.jpg', 152, 6),
('Mulholland Drive', 2001, 'Un thriller mystérieux et énigmatique dans les méandres de Los Angeles.', 'mulholland_drive.jpg', 147, 7),
('2001 : l\'odyssée de l\'espace', 1968, 'Une exploration épique de l\'humanité et de l\'intelligence artificielle.', '2001.jpg', 149, 8),
('Shining', 1980, 'Un homme devient fou dans un hôtel isolé et hanté.', 'shining.jpg', 146, 8),
('Full Metal Jacket', 1987, 'Un portrait saisissant des réalités brutales de la guerre du Vietnam.', 'full_metal_jacket.jpg', 116, 8),
('Parasite', 2019, 'Une famille pauvre s\'infiltre dans la vie d\'une famille riche avec des conséquences dévastatrices.', 'parasite.jpg', 132, 9),
('Et pour quelques dollars de plus', 1965, 'Deux chasseurs de primes font équipe pour traquer un bandit impitoyable.', 'quelques_dollars_de_plus.jpg', 132, 10),
('Le Bon, la Brute et le Truand', 1966, 'Trois hommes s\'affrontent pour une fortune en or pendant la guerre de Sécession.', 'bon_brute_truand.jpg', 178, 10),
('Kill Bill', 2003, 'Une femme se venge de ses anciens collègues assassins.', 'kill_bill.jpg', 111, 11),
('Mad Max : Fury Road', 2015, 'Dans un désert post-apocalyptique, une lutte pour la survie et la liberté.', 'mad_max_fury_road.jpg', 120, 12),
('L\'Exorciste', 1973, 'Une jeune fille est possédée et un prêtre tente de la sauver.', 'exorciste.jpg', 122, 13),
('The Thing', 1982, 'Une créature extraterrestre s\'infiltre dans une station en Antarctique.', 'thing.jpg', 109, 14),
('Thelma et Louise', 1991, 'Deux femmes en fuite redéfinissent leur liberté.', 'thelma_et_louise.jpg', 130, 15),
('Alien', 1979, 'Une mission spatiale tourne au cauchemar face à une créature mortelle.', 'alien.jpg', 117, 15);

INSERT INTO film_genre (film_id, genre_id) VALUES
(1, 2),
(2, 2),
(3, 6),
(3, 8),
(4, 7),
(5, 1),
(6, 8);


insert into film_acteur values 
(1,1,"David Mills"),
(1,2,"William Somerset"),
(2,3,"Clarice Starling"),
(3,4,"Sebastien Wilder"),
(3,5,"Mia"),
(5,6,"George Bailey"),
(9,7,"Jack Torrance"),
(19,10,"Ellen Ripley");


INSERT INTO utilisateurs (nom, prenom, email, mot_de_passe, role) VALUES
('Dupont', 'Jean', 'jean.dupont@example.com', 'motdepasse123', 'utilisateur');



INSERT INTO realisateurs (id, prenom, nom) VALUES
(1, 'David', 'Fincher'),
(2, 'Jonathan', 'Demme'),
(3, 'Damien', 'Chazelle'),
(4, 'Michel', 'Ocelot'),
(5, 'Frank', 'Capra'),
(6, 'Robert', 'Wise'),
(7, 'David', 'Lynch'),
(8, 'Stanley', 'Kubrick'),
(9, 'Bong', 'Joon-ho'),
(10, 'Sergio', 'Leone'),
(11, 'Quentin', 'Tarantino'),
(12, 'George', 'Miller'),
(13, 'William', 'Friedkin'),
(14, 'John', 'Carpenter'),
(15, 'Ridley', 'Scott'),
(16, 'Alfred', 'Hitchcock'),
(17, 'Wes', 'Anderson'),
(18, 'Stanley', 'Donen'),
(19, 'Denis', 'Villeneuve');



