drop database formation_restaurant;
create database if not exists formation_restaurant;
use formation_restaurant;
create table commande(
idCommande INT primary key NOT NULL AUTO_INCREMENT,
total NUMERIC(9,2) NOT NULL,
date DATE NOT NULL
);
create table plat(
idPlat INT primary key NOT NULL AUTO_INCREMENT,
nomPlat VARCHAR(45) NOT NULL,
prix NUMERIC(9,2) NOT NULL
);
create table plat_commande(
idPlat_Commande INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
idCommande INT NOT NULL,
idPlat INT NOT NULL
);
create table ingredient(
idIngredient INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
nomIngredient VARCHAR(45) NOT NULL
);
create table ingredient_plat(
idIngredient_Plat INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
idIngredient INT NOT NULL,
idPlat INT NOT NULL,
quantite INT NOT NULL DEFAULT 0
);
alter table plat_commande 
add constraint fk_platCmd_idPlat foreign key(idPlat) references plat(idPlat),
add constraint fk_platCmd_idIngr foreign key(idCommande) references ingredient(idIngredient);
alter table ingredient_plat
add constraint fk_ingrPlat_idIngr foreign key(idIngredient) references ingredient(idIngredient),
add constraint fk_ingPlat_idPlat foreign key(idPlat) references plat(idPlat);
insert into ingredient(nomIngredient) values("poivron"),("piment"),("oignon"),("boeuf"),("poulet"),("oueuf"),("tortilla");
insert into plat(nomPlat,prix) values("boeuf au oignon",5.50),("chili",6.80),("tacos",8.00);
insert into commande(total,date) values(12.3,sysdate()),(14.80,sysdate()),(24.00,sysdate());
insert into plat_commande(idcommande,idplat) values(1,1),(1,2),(2,2),(2,3),(3,3),(3,3),(3,3);
insert into ingredient_plat(idingredient,idplat) values(3,1),(4,1),(1,2),(2,2),(3,2),(4,2),(1,3),(2,3),(3,3),(5,3),(6,3);

