-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:3306
-- Généré le : mar. 25 mars 2025 à 10:54
-- Version du serveur : 8.0.30
-- Version de PHP : 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `film_rating_db`
--

-- --------------------------------------------------------

--
-- Structure de la table `acteurs`
--

CREATE TABLE `acteurs` (
  `id` int NOT NULL,
  `nom` varchar(50) NOT NULL,
  `prenom` varchar(50) NOT NULL,
  `date_naissance` date DEFAULT NULL,
  `biographie` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `acteurs`
--

INSERT INTO `acteurs` (`id`, `nom`, `prenom`, `date_naissance`, `biographie`) VALUES
(4, 'Pitt', 'Brad', NULL, NULL),
(5, 'Freeman', 'Morgan', NULL, NULL),
(6, 'Foster', 'Jodie', NULL, NULL),
(7, 'Gosling', 'Ryan', NULL, NULL),
(8, 'Stone', 'Emma', NULL, NULL),
(9, 'Stewart', 'James', NULL, NULL),
(10, 'Nicholson', 'Jack', NULL, NULL),
(11, 'Hanks', 'Tom', NULL, NULL),
(12, 'Ford', 'Harrison', NULL, NULL),
(13, 'Weaver', 'Sigourney', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `favoris`
--

CREATE TABLE `favoris` (
  `utilisateur_id` int NOT NULL,
  `film_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `favoris`
--

INSERT INTO `favoris` (`utilisateur_id`, `film_id`) VALUES
(2, 76),
(2, 83),
(2, 89);

-- --------------------------------------------------------

--
-- Structure de la table `films`
--

CREATE TABLE `films` (
  `id` int NOT NULL,
  `titre` varchar(100) NOT NULL,
  `annee` int NOT NULL,
  `synopsis` text,
  `affiche` varchar(255) DEFAULT NULL,
  `duree` int DEFAULT NULL COMMENT 'Dur├®e en minutes',
  `realisateur_id` int NOT NULL,
  `date_ajout` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `films`
--

INSERT INTO `films` (`id`, `titre`, `annee`, `synopsis`, `affiche`, `duree`, `realisateur_id`, `date_ajout`) VALUES
(76, 'Se7en', 1995, 'Deux détectives enquêtent sur un tueur en série qui met en scène les sept péchés capitaux.', 'se7en.jpg', 127, 1, '2025-03-23 14:54:42'),
(77, 'Le Silence des agneaux', 1991, 'Un agent du FBI doit faire équipe avec un psychopathe pour traquer un autre tueur en série.', 'silence_des_agneaux.jpg', 118, 2, '2025-03-23 14:54:42'),
(78, 'La La Land', 2016, 'Deux artistes tentent de réaliser leurs rêves à Los Angeles tout en naviguant leur relation amoureuse.', 'la_la_land.jpg', 128, 3, '2025-03-23 14:54:42'),
(79, 'Azur et Asmar', 2006, 'Une aventure magique et poétique de deux amis d\'enfance issus de cultures différentes.', 'azur_et_asmar.jpg', 99, 4, '2025-03-23 14:54:42'),
(80, 'La vie est belle', 1946, 'Un homme désespéré découvre l\'impact de sa vie grâce à un ange gardien.', 'la_vie_est_belle.jpg', 130, 5, '2025-03-23 14:54:42'),
(81, 'West Side Story', 1961, 'Un amour impossible entre deux jeunes liés à des gangs rivaux.', 'west_side_story.jpg', 152, 6, '2025-03-23 14:54:42'),
(82, 'Mulholland Drive', 2001, 'Un thriller mystérieux et énigmatique dans les méandres de Los Angeles.', 'mulholland_drive.jpg', 147, 7, '2025-03-23 14:54:42'),
(83, '2001 : l\'odyssée de l\'espace', 1968, 'Une exploration épique de l\'humanité et de l\'intelligence artificielle.', '2001.jpg', 149, 8, '2025-03-23 14:54:42'),
(84, 'Shining', 1980, 'Un homme devient fou dans un hôtel isolé et hanté.', 'shining.jpg', 146, 8, '2025-03-23 14:54:42'),
(85, 'Full Metal Jacket', 1987, 'Un portrait saisissant des réalités brutales de la guerre du Vietnam.', 'full_metal_jacket.jpg', 116, 8, '2025-03-23 14:54:42'),
(86, 'Parasite', 2019, 'Une famille pauvre s\'infiltre dans la vie d\'une famille riche avec des conséquences dévastatrices.', 'parasite.jpg', 132, 9, '2025-03-23 14:54:42'),
(87, 'Et pour quelques dollars de plus', 1965, 'Deux chasseurs de primes font équipe pour traquer un bandit impitoyable.', 'quelques_dollars_de_plus.jpg', 132, 10, '2025-03-23 14:54:42'),
(88, 'Le Bon, la Brute et le Truand', 1966, 'Trois hommes s\'affrontent pour une fortune en or pendant la guerre de Sécession.', 'bon_brute_truand.jpg', 178, 10, '2025-03-23 14:54:42'),
(89, 'Kill Bill', 2003, 'Une femme se venge de ses anciens collègues assassins.', 'kill_bill.jpg', 111, 11, '2025-03-23 14:54:42'),
(90, 'Mad Max : Fury Road', 2015, 'Dans un désert post-apocalyptique, une lutte pour la survie et la liberté.', 'mad_max_fury_road.jpg', 120, 12, '2025-03-23 14:54:42'),
(91, 'L\'Exorciste', 1973, 'Une jeune fille est possédée et un prêtre tente de la sauver.', 'exorciste.jpg', 122, 13, '2025-03-23 14:54:42'),
(92, 'The Thing', 1982, 'Une créature extraterrestre s\'infiltre dans une station en Antarctique.', 'thing.jpg', 109, 14, '2025-03-23 14:54:42'),
(93, 'Thelma et Louise', 1991, 'Deux femmes en fuite redéfinissent leur liberté.', 'thelma_et_louise.jpg', 130, 15, '2025-03-23 14:54:42'),
(94, 'Alien', 1979, 'Une mission spatiale tourne au cauchemar face à une créature mortelle.', 'alien.jpg', 117, 15, '2025-03-23 14:54:42'),
(95, 'Le Prestige', 2006, 'Deux magiciens du 19e siècle s\'engagent dans une lutte sans merci non seulement pour se surpasser l\'un l\'autre, mais pour détruire l\'adversaire. L\'un deux est accusé du meurtre de son rival qui s\'est noyé au cours d\'un tour de magie, après être tombé d\'une trappe dans une cuve remplie d\'eau et verrouillée, l\'exécution du tour ayant apparemment mal tourné.', 'le_prestige.jpg', 130, 16, '2025-03-25 00:00:18');

-- --------------------------------------------------------

--
-- Structure de la table `film_acteur`
--

CREATE TABLE `film_acteur` (
  `film_id` int NOT NULL,
  `acteur_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `film_acteur`
--

INSERT INTO `film_acteur` (`film_id`, `acteur_id`) VALUES
(76, 4),
(76, 5),
(77, 6),
(78, 7),
(78, 8),
(80, 9),
(84, 10),
(94, 13);

-- --------------------------------------------------------

--
-- Structure de la table `film_genre`
--

CREATE TABLE `film_genre` (
  `film_id` int NOT NULL,
  `genre_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `film_genre`
--

INSERT INTO `film_genre` (`film_id`, `genre_id`) VALUES
(78, 30),
(76, 31),
(77, 31),
(89, 31),
(95, 31),
(86, 32),
(83, 33),
(90, 33),
(94, 33),
(84, 34),
(91, 34),
(92, 34),
(80, 35),
(79, 36),
(78, 37),
(81, 37),
(93, 40),
(82, 41),
(85, 42),
(87, 42),
(88, 42);

-- --------------------------------------------------------

--
-- Structure de la table `genres`
--

CREATE TABLE `genres` (
  `id` int NOT NULL,
  `libelle` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `genres`
--

INSERT INTO `genres` (`id`, `libelle`) VALUES
(36, 'Animation'),
(40, 'Aventure'),
(32, 'Comédie'),
(30, 'Drame'),
(39, 'Fantastique'),
(38, 'Guerre'),
(41, 'Historique'),
(34, 'Horreur'),
(37, 'Musical'),
(35, 'Romance'),
(33, 'Science-fiction'),
(31, 'Thriller'),
(42, 'Western');

-- --------------------------------------------------------

--
-- Structure de la table `notations`
--

CREATE TABLE `notations` (
  `id` int NOT NULL,
  `utilisateur_id` int NOT NULL,
  `film_id` int NOT NULL,
  `note` decimal(2,1) NOT NULL,
  `commentaire` text,
  `date_notation` datetime DEFAULT CURRENT_TIMESTAMP,
  `date_modification` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `notation_likes`
--

CREATE TABLE `notation_likes` (
  `utilisateur_id` int NOT NULL,
  `notation_id` int NOT NULL,
  `date_like` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `realisateurs`
--

CREATE TABLE `realisateurs` (
  `id` int NOT NULL,
  `nom` varchar(50) NOT NULL,
  `prenom` varchar(50) NOT NULL,
  `date_naissance` date DEFAULT NULL,
  `biographie` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `realisateurs`
--

INSERT INTO `realisateurs` (`id`, `nom`, `prenom`, `date_naissance`, `biographie`) VALUES
(1, 'Fincher', 'David', NULL, NULL),
(2, 'Demme', 'Jonathan', NULL, NULL),
(3, 'Chazelle', 'Damien', NULL, NULL),
(4, 'Ocelot', 'Michel', NULL, NULL),
(5, 'Capra', 'Frank', NULL, NULL),
(6, 'Wise', 'Robert', NULL, NULL),
(7, 'Lynch', 'David', NULL, NULL),
(8, 'Kubrick', 'Stanley', NULL, NULL),
(9, 'Joon-ho', 'Bong', NULL, NULL),
(10, 'Leone', 'Sergio', NULL, NULL),
(11, 'Tarantino', 'Quentin', NULL, NULL),
(12, 'Miller', 'George', NULL, NULL),
(13, 'Friedkin', 'William', NULL, NULL),
(14, 'Carpenter', 'John', NULL, NULL),
(15, 'Scott', 'Ridley', NULL, NULL),
(16, 'Hitchcock', 'Alfred', NULL, NULL),
(17, 'Anderson', 'Wes', NULL, NULL),
(18, 'Donen', 'Stanley', NULL, NULL),
(19, 'Villeneuve', 'Denis', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `utilisateurs`
--

CREATE TABLE `utilisateurs` (
  `id` int NOT NULL,
  `nom` varchar(50) NOT NULL,
  `prenom` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `mot_de_passe` varchar(255) NOT NULL,
  `date_inscription` datetime DEFAULT CURRENT_TIMESTAMP,
  `role` varchar(255) NOT NULL DEFAULT 'utilisateur'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `utilisateurs`
--

INSERT INTO `utilisateurs` (`id`, `nom`, `prenom`, `email`, `mot_de_passe`, `date_inscription`, `role`) VALUES
(1, 'Admin', 'admin', 'admin@gmail.com', '$2b$10$BEiedYU4Mk6iHLJhyKnzTeb19YzK1WplB058E3m5HPH2Ya7HLuJxG', '2025-03-25 11:12:48', 'administrateur'),
(2, 'sonia', 'sonia', 'sonia@gmail.com', '$2b$10$M.Y9U/kIPCGIvuv2M8NBju9bABbihxJjzFJEJ0GMPJCcbQrFKIopK', '2025-03-22 12:56:59', 'administrateur'),
(3, 'dzad', 'azdazd', 'test@gmail.com', '$2b$10$AYkvxeTQu1pTeLPRgjubZuXCpmHcN.xs5RHD4UraKyAUNQQyvOEO2', '2025-03-22 13:04:14', 'utilisateur'),
(4, 'zd', 'sonia', 'zd@gmail.com', '$2b$10$0ydQjIlb1LXi12S4w0EEQugRR4UUQfHAgDyLN8F/DXjrCADncgCz.', '2025-03-23 12:36:49', 'utilisateur');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `acteurs`
--
ALTER TABLE `acteurs`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `favoris`
--
ALTER TABLE `favoris`
  ADD PRIMARY KEY (`utilisateur_id`,`film_id`),
  ADD KEY `film_id` (`film_id`);

--
-- Index pour la table `films`
--
ALTER TABLE `films`
  ADD PRIMARY KEY (`id`),
  ADD KEY `realisateur_id` (`realisateur_id`);

--
-- Index pour la table `film_acteur`
--
ALTER TABLE `film_acteur`
  ADD PRIMARY KEY (`film_id`,`acteur_id`),
  ADD KEY `acteur_id` (`acteur_id`);

--
-- Index pour la table `film_genre`
--
ALTER TABLE `film_genre`
  ADD PRIMARY KEY (`film_id`,`genre_id`),
  ADD KEY `genre_id` (`genre_id`);

--
-- Index pour la table `genres`
--
ALTER TABLE `genres`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `libelle` (`libelle`);

--
-- Index pour la table `notations`
--
ALTER TABLE `notations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_notation` (`utilisateur_id`,`film_id`),
  ADD KEY `film_id` (`film_id`);

--
-- Index pour la table `notation_likes`
--
ALTER TABLE `notation_likes`
  ADD PRIMARY KEY (`utilisateur_id`,`notation_id`),
  ADD KEY `notation_id` (`notation_id`);

--
-- Index pour la table `realisateurs`
--
ALTER TABLE `realisateurs`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `utilisateurs`
--
ALTER TABLE `utilisateurs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `acteurs`
--
ALTER TABLE `acteurs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT pour la table `films`
--
ALTER TABLE `films`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=133;

--
-- AUTO_INCREMENT pour la table `genres`
--
ALTER TABLE `genres`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT pour la table `notations`
--
ALTER TABLE `notations`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT pour la table `realisateurs`
--
ALTER TABLE `realisateurs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT pour la table `utilisateurs`
--
ALTER TABLE `utilisateurs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `favoris`
--
ALTER TABLE `favoris`
  ADD CONSTRAINT `favoris_ibfk_1` FOREIGN KEY (`utilisateur_id`) REFERENCES `utilisateurs` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `favoris_ibfk_2` FOREIGN KEY (`film_id`) REFERENCES `films` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `films`
--
ALTER TABLE `films`
  ADD CONSTRAINT `films_ibfk_1` FOREIGN KEY (`realisateur_id`) REFERENCES `realisateurs` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `film_acteur`
--
ALTER TABLE `film_acteur`
  ADD CONSTRAINT `film_acteur_ibfk_1` FOREIGN KEY (`film_id`) REFERENCES `films` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `film_acteur_ibfk_2` FOREIGN KEY (`acteur_id`) REFERENCES `acteurs` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `film_genre`
--
ALTER TABLE `film_genre`
  ADD CONSTRAINT `film_genre_ibfk_1` FOREIGN KEY (`film_id`) REFERENCES `films` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `film_genre_ibfk_2` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `notations`
--
ALTER TABLE `notations`
  ADD CONSTRAINT `notations_ibfk_1` FOREIGN KEY (`utilisateur_id`) REFERENCES `utilisateurs` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notations_ibfk_2` FOREIGN KEY (`film_id`) REFERENCES `films` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `notation_likes`
--
ALTER TABLE `notation_likes`
  ADD CONSTRAINT `notation_likes_ibfk_1` FOREIGN KEY (`utilisateur_id`) REFERENCES `utilisateurs` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notation_likes_ibfk_2` FOREIGN KEY (`notation_id`) REFERENCES `notations` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
