# Présentation du projet

- Le jeu consiste en la construction et gestion **d’un réseau de transport ferroviaire**. L’objectif du joueur est que l’acheminement des passagers vers leurs destinations soit optimal. Plusieurs stations qu’il faudra relier entre elles apparaissent au fil de la partie. Les passagers apparaîtront à côté de leur station de départ et emprunteront la ou les lignes qui desservent leur station afin d’atteindre leur destination. Certaines cartes pourront contenir des fleuves dès le début de la partie. L’identité graphique du jeu s’apparentera aux cartes de réseaux disponibles dans les transports en commun. 

- Les lignes reliant les stations seront de différentes couleurs, elles sont semblables à celles que l'on voit sur les vraies cartes de transport en commun. Lorsqu’une ligne est créée, un véhicule apparaîtra sur cette dernière et y fera des allers-retours. Il est possible de librement supprimer ou réorganiser les lignes à tout moment de la partie.

- Les réseaux deviennent de plus en plus complexes au fur et à mesure de la partie, le joueur pourra recevoir des objets (items cités dans les fonctionnalités) à différents moments de la partie afin de l’aider dans la gestion des réseaux.

- Enfin, le joueur perd lorsque son réseau n’est plus efficace. C’est-à-dire lorsqu’une station accueille un nombre de passagers supérieur à sa capacité pendant un certain temps.

# Fonctionnalités

# Interface graphique

L’interface graphique comportera les éléments suivants : 

- **Menu de démarrage :** Il permettra de commencer une partie, de sélectionner un niveau de difficulté, de choisir une carte, de paramétrer l'échelle de l'interface graphique, de charger une partie à partir d’un fichier et également de changer le niveau du son. Il comprendra également un onglet “à propos” comprenant des crédits ainsi que des explications sur le jeu etc.

- **Terrain de jeu :** Une fois que le joueur a lancé une partie, un terrain de jeu occupant tout l’écran sera présenté au joueur. C’est ici que les différentes entités apparaîtront au fur et à mesure. Un inventaire (interactif) et des indicateurs (statistiques de partie) sont affichés par superposition.

- **Echelle :** Les coordonnées ainsi que la taille des différents objets graphiques seront relatives à la taille de l’écran (la proportion de l’écran occupée par l’objet). Cela permettra de rendre automatique la mise à l’échelle des éléments graphiques pour différentes configurations d’écran.

- **Bilan :** A la fin de la partie, un écran de fin s’affiche présentant le score du joueur (calculé sur la base du nombre de semaines où le réseau était efficace et de voyageurs transportés).

- **Couleurs :** L’interface graphique sera le plus épuré possible avec des couleurs simples et contrastées et le minimum de couleurs possibles. L’interface graphique disposera d’un mode sombre où les gammes de couleurs claires sont remplacées par des nuances plus sombres. 

## Autre

- Temps : Le temps sera organisé en jours et semaines (jour : ~20 secondes, 1 semaine : ~140 secondes). Ce système servira à déterminer en partie le score final du joueur. Il sera possible de stopper, d'accélérer ou de reprendre le temps.

- Bilan : Un bilan sera aussi proposé au joueur (comprenant des graphiques, cartes de fréquentation...) pour que le joueur puisse analyser ses performances.

- Son : Le jeu comprendra une musique de fond apaisante ainsi que des effets sonores pour mettre le joueur dans l’ambiance du jeu.

## Objets

Les objets sont les éléments que le joueur pourra disposer librement sur le terrain de jeu. Tous les objets seront présents en début de partie en quantité limitée et stockés dans un inventaire. A chaque semaine passée, le joueur obtiendra des récompenses qu'il pourra choisir entre 2 ou 3 objets proposés aléatoirement. Les objets seront les suivants : 

- **Locomotives :** Les locomotives sont les véhicules permettant aux voyageurs de se déplacer entre les différentes stations. Elles seront affectées par le joueur à une ligne en particulier et effectueront des allers-retours sur cette dernière.

- **Lignes :** Les lignes seront les infrastructures permettant aux locomotives de circuler de station en station. Elles seront dessinées par le joueur et pourront être modifiées au fur et à mesure de la partie. Les lignes seront représentées à la manière d’un plan de métro, c’est-à-dire en utilisant des lignes horizontales et verticales ainsi que des angles à 45° pour les virages.

- **Wagons :** Les wagons sont des véhicules pouvant être ajoutés à une locomotive afin d’augmenter le nombre de passagers qu’elle peut transporter en une seule fois. o Ponts : En cas d’implémentation de topologie (ex : cours d’eau) sur la carte, ils seront utiles pour les franchissements d’obstacle.

- **Technicien :** Si implémentation d’une fonctionnalité de détérioration des lignes, le technicien permet de restaurer l'état de la ligne.

- **Sur-dimensionnement de la gare :** Les rames passant par une gare surdimensionnée passeront moins de temps à quai. Ces gares ont également une plus grande capacité d’accueil des passagers (peut accueillir 12 passagers au lieu de 6).

## Entités

Les entités sont les éléments qui seront disposés sur le terrain de jeu par le programme. Le joueur ne pourra pas interagir de manière directe avec les entités, c’est-à-dire qu’elles ne seront pas modifiables par le joueur. Les entités seront les suivantes :

- **Stations :** Les stations sont de différentes formes géométriques et sont générées de manière aléatoire. Elles apparaîtront à des instants t déterminés par une fonction (linéaire puis éventuellement logarithmique/polynomiale). Elles seront disposées sur le terrain de jeu de manière homogène, c'est-à-dire en évitant les stations superposées ou trop proches et de même type (utilisation d'une carte de fréquentation).

- **Passagers :** Les passagers seront également de différentes formes géométriques (correspondant à leur station d'arrivée) à côté des stations à des instants t déterminés par une fonction (linéaire puis éventuellement logarithmique/polynomiale). Ces passagers disparaissent une fois arrivés à destination. Un algorithme de résolution des graphes (pondéré en fonction de l’occupation des lignes et du temps de transit entre les stations) sera utilisé afin de calculer l’itinéraire des passagers.

- **Fleuves :** Les différentes cartes comprendront un ou plusieurs fleuves qui feront office d’obstacle naturel et devront être contournés par le joueur en utilisant les objets qu’il a à sa disposition.

## Autre

## Difficulté

La difficulté du jeu se trouvera dans le fait de devoir fluidifier au maximum le trafic et d’adapter le réseau en fonction des nouvelles stations qui apparaissent, le flux de passagers ainsi que des différents aléas. o Niveaux de difficulté : Le joueur aura le choix entre 3 niveaux de difficulté (facile, moyen, difficile).

- **Détérioration des lignes :** Les lignes auront une durée de vie limitée (en fonction du nombre de rames les parcourant) et pourront être sous la contrainte d’aléas naturels (feu, inondation etc.). Le joueur pourra alors les restaurer à l’aide de l’objet “Technicien”.

- **Fin de partie :** La partie prend fin une fois qu’une station est engorgée (quand plus de 6 passagers s’y trouvent) pendant un temps qui dépendra de la difficulté choisie. Un chronomètre apparaîtra à côté de la/des stations surchargée(s) pour indiquer le temps restant au joueur. Si ce temps est dépassé (environ 30 secondes ; varie selon la difficulté) alors que la station est encore encombrée, le joueur perd.

## Autre

- **Enregistrement et chargement de parties :** Le joueur pourra enregistrer ses parties dans des fichiers de sauvegarde ainsi que les charger. Cela contribuera également à la démonstration finale du jeu afin de charger une partie en cours et de faire la démonstration.

- **Fonctionnalités cachées :** Dans ce jeu, cela pourrait être une gare qui n’apparait que dans certaines circonstances, une blague accessible à certains joueurs chanceux...

# Outils utilisés

En plus du compilateur Free Pascal FPC, nous avons fait appel à d'autres outils afin de nous faciliter le développement. 

> [!Info]
> Tous les outils utilisé pour le projet sont **tous gratuits** et pour la plupart **libre de droit** et/ou **open source**.

## Microsoft Visual Studio Code

- Lien : https://code.visualstudio.com/
- Licence : MIT

Comme éditeur de code, nous avons choisi Visual Studio Code de chez Microsoft car c'est un éditeur simple, très modulaire et personnalisable. 

Les extensions qui ont été utilisés au sein de Visual Studio Code sont :
- Live share (Microsoft): Extension permetant de collaborer "en direct" sur un même répertoire de code.
- Pascal & Pascal Formatter (Alessandro Fragnani) : Extensions permetant la coloration syntaxique, l'auto-complétion ainsi que le formatage automatique du code.

## Git

- Lien : https://git-scm.com/
- Licence : GPLv2

Afin de pouvoir gérer le répertoire de code facilement et enregistrer chaques modifications apportés au code, un logiciel de gestion de version. Le plus populaire étant Git, c'est cette solution que nous avons utilisé.

## GitHub

- Lien : https://github.com
- Licence : Propriétaire.

Afin de pouvoir collaborer sur le même répertoire de code, nous avons herbagée le répertoire sur GitHub.

## PasDoc

- Lien : https://github.com/pasdoc/pasdoc
- Licence : GPLv2

Afin de pouvoir générer automatiquement de la documentation pour le code, nous avons utilisé le logiciel PasDoc. Ainsi, à partir de balises placés dans les commentaires, il nous à été possible de documentater les fonctions, structures, variables, constantes etc. directement dans le code. Les fichiers html généré par l'outil ont ensuite été intégrés directement dans ce documen


## Obsidian

- Lien : https://obsidian.md/
- Licence : Propriétaire

Afin de créer la documentation, 

## Inkscape

- Lien :
- Licence :

Pour la création des formes géométriques pour les graphismes, nous avons opté pour Inkscape qui est un logiciel de dessin vectoriel.



