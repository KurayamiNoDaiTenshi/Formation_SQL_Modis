USE immobilier;

-- Question 1 : Affichez le nom des agences

SELECT nom
FROM agence;

-- Question 2 : Affichez le numéro de l’agence « Orpi »

SELECT idAgence
FROM agence
WHERE nom = "Orpi";

-- Question 3 : Affichez le premier enregistrement de la table logement

SELECT *
FROM logement
ORDER BY idLogement
LIMIT 1;

-- Question 4 : Affichez le nombre de logements (Alias : Nombre_de_logements)

SELECT count(*) Nombre_de_logements
FROM logement;

-- Question 5 : Affichez les logements à vendre à moins de 150 000 € dans l’ordre croissant des prix.

SELECT *
FROM logement
WHERE categorie = "vente"
  AND prix <= 150000
ORDER BY prix;

-- Question 6 : Affichez le nombre de logements à la location (alias : nombre)

SELECT count(*) nombre
FROM logement
WHERE categorie = "location";

-- Question 7 : Affichez les villes différentes recherchées par les personnes demandeuses d'un logement

SELECT DISTINCT ville
FROM demande;

-- Question 8 : Affichez le nombre de biens à vendre par ville

SELECT ville,
       count(*)
FROM logement
WHERE categorie = "vente"
GROUP BY ville;

-- Question 9 : Quelles sont les id des logements destinés à la location ?

SELECT idLogement
FROM logement
WHERE categorie = "location";

-- Question 10 : Quels sont les id des logements entre 20 et 30m² ?

SELECT idLogement
FROM logement
WHERE superficie BETWEEN 20 AND 30;

-- Question 11 : Quel est le prix vendeur (hors commission) du logement le moins cher à vendre ? (Alias : prix minimum)

SELECT min(prix) AS 'prix minimum'
FROM logement
WHERE categorie = "vente";

-- Question 12 : Dans quelle ville se trouve les maisons à vendre ?

SELECT DISTINCT ville
FROM logement
WHERE genre = "maison";

-- Question 13 : L’agence Orpi souhaite diminuer les frais qu’elle applique sur le logement ayant l'id « 5246 ». Passer les frais de ce logement de 800 à 730€

UPDATE logement_agence
SET frais = 730
WHERE idLogement = 5246;

-- Question 14 : Quels sont les logements gérés par l’agence « laforet »

SELECT l.*
FROM logement l
JOIN logement_agence la ON l.idLogement = la.idLogement
JOIN agence a ON la.idAgence = a.idAgence
WHERE a.nom = "laforet";

-- Question 15 : Affichez le nombre de propriétaires dans la ville de Paris (Alias : Nombre)

SELECT count(DISTINCT idPersonne) Nombre
FROM logement_personne
WHERE idLogement IN
    (SELECT idLogement
     FROM logement
     WHERE ville = "Paris");

-- Question 16 : Affichez les informations des trois premieres personnes souhaitant acheter un logement

SELECT *
FROM personne
WHERE idPersonne IN
    (SELECT idPersonne
     FROM demande
     WHERE categorie = "vente")
ORDER BY idPersonne
LIMIT 3;

-- Question 17 : Affichez le prénom du vendeur pour le logement ayant la référence « 5770 »

SELECT prenom
FROM personne
WHERE idPersonne =
    (SELECT idPersonne
     FROM logement_personne
     WHERE idLogement = 5770);

-- Question 18 : Affichez les prénoms des personnes souhaitant accéder à un logement sur la ville de Lyon

SELECT prenom
FROM personne
WHERE idPersonne IN
    (SELECT idPersonne
     FROM demande
     WHERE ville = "Lyon");

-- Question 19 : Affichez les prénoms des personnes souhaitant accéder à un logement en location sur la ville de Paris

SELECT prenom
FROM personne
WHERE idPersonne IN
    (SELECT idPersonne
     FROM demande
     WHERE ville = "Paris"
       AND categorie = "location");

-- Question 20 : Affichez les prénoms des personnes souhaitant acheter un logement de la plus grande à la plus petite superficie

SELECT prenom
FROM personne
WHERE idPersonne IN
    (SELECT idPersonne
     FROM demande
     ORDER BY superficie);

-- Question 21 : Quel sont les prix finaux proposés par les agences pour la maison à la vente ayant la référence « 5091 » ? (Alias : prix frais d'agence inclus)

SELECT (l.prix+la.frais) AS 'prix frais d''agence inclus'
FROM logement l
JOIN logement_agence la ON l.idLogement = la.idLogement
WHERE l.idLogement = 5091; -- Question 23 : Si l’ensemble des logements étaient vendus ou loués demain, quel serait le bénéfice généré grâce aux frais d’agence et pour chaque agence (Alias : benefice, classement : par ordre croissant des gains)

SELECT a.nom,
       sum(la.frais) AS 'benefice'
FROM agence a
JOIN logement_agence la ON a.idAgence = la.idAgence
GROUP BY a.nom
ORDER BY sum(la.frais);

-- Question 24 : Affichez les id des biens en location, les prix, suivis des frais d’agence (classement : dans l’ordre croissant des prix)

SELECT l.idLogement,
       l.prix,
       la.frais
FROM logement l
JOIN logement_agence la ON l.idLogement = la.idLogement
WHERE l.categorie = "location"
ORDER BY l.prix;

-- Question 25 : Quel est le prénom du propriétaire proposant le logement le moins cher à louer ?

SELECT p.prenom
FROM personne p
JOIN logement_personne lp ON p.idPersonne = lp.idPersonne
WHERE lp.idLogement =
    (SELECT idLogement
     FROM logement
     WHERE categorie = "location"
       AND prix =
         (SELECT min(prix)
          FROM logement)); -- Question 26 : Affichez le prénom et la ville où se trouve le logement de chaque propriétaire

SELECT p.prenom,
       l.ville
FROM personne p
JOIN logement_personne lp ON p.idPersonne = lp.idPersonne
JOIN logement l ON lp.idLogement = l.idLogement;

-- Question 27 : Quel est l’agence immobilière s’occupant de la plus grande gestion de logements répertoriés à Paris ? (alias : nombre, classement : trié par ordre décroissant)

SELECT a.nom,
       COUNT(la.idAgence) nombre
FROM logement_agence la
JOIN logement l ON l.idLogement = la.idLogement
JOIN agence a ON a.idAgence = la.idAgence
WHERE l.ville = "Paris"
GROUP BY la.idAgence
ORDER BY 2 DESC;

-- Question 28 : Affichez le prix et le prénom des vendeurs dont les logements sont proposés à 130000 € ou moins en prix final avec frais appliqués par les agences (alias : prix final, classement : ordre croissant des prix finaux) :

SELECT p.prenom,
       (l.prix+la.frais) AS 'prix final'
FROM personne p
JOIN logement_personne lp ON lp.idPersonne = p.idPersonne
JOIN logement_agence la ON lp.idLogement = la.idLogement
JOIN logement l ON la.idLogement = l.idLogement
WHERE (l.prix+la.frais) <= 130000;

-- Question 29 : Afficher toutes les demandes enregistrées avec la personne à l'origine de la demande (Afficher également les demandes d'anciennes personnes n'existant plus dans notre base de données).

SELECT d.*,
       p.prenom
FROM demande d
LEFT JOIN personne p ON d.idPersonne = p.idPersonne;

-- Question 30 : Afficher toutes les personnes enregistrées avec leur demandes correspondantes (Afficher également les personnes n'ayant pas formulé de demandes).

SELECT d.*,
       p.prenom
FROM demande d
RIGHT JOIN personne p ON d.idPersonne = p.idPersonne;