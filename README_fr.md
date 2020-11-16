# Classe ABAP ZCL_LOG_UTIL

Dans le cadre de développements de programme d'interfaces
ABAP exécuté par batch , nous avons été confronté à plusieurs 
reprise à des sujets autours des logs d'erreurs.
D'abord nous avons eu des soucis quant à leur affichage entre la 
zone du protocole d'exécution du job et ceux à afficher dans le 
spool pour envoyer un mail. Plus tard, nous avons eu une demande 
de gestion des messages d'erreur standard des BAPI étant considérable 
comme faux positif. Enfin pour un suivis avancé pour des éventuels 
analyse d'anomalie en prod, l'utilisation de l'application peu être 
une aide précieuse.

L'ensemble de ses sujets sont au niveau ABAP très proche 
(gestion des messages) mais l'implémentation varie grandement en 
fonction de la nature du sujet. La réutilisation des codes est très 
complexe du fait de son implémentation processif.

Le besoin de développement d'une classe conçue pour couvrir l'intégralité 
des besoins, sans modifier la façon de logguer dans le programme et de 
laisser le coeur du programe lisible est devenue une évidence. C'est pour 
cette raison que j'ai décidé de développer la classe ZCL_LOG_UTIL. Elle se 
veut simple d'utilisation (configuration minimale) tout en offrant un éventail 
de fonctionnalités (nécessite davantage de configuration, mais se voulant 
toujours le plus simple possible). Suite à cette complexité, veuillez trouver 
la documentation détaillée de la classe et de son utilisation.




## Summary

[](MakeSummary)



## Getting Start

Le projet ZCL_LOG_UTIL est fournis d'un programme d'exemples qui contient 
et utilise l'intégralité des fonctionnalités proposée par la classe. 
Son but est de permettre à tous les utilisateurs d'avoir un exemple 
d'utilisation précis, 
d'appel de méthode ou d'implémentation d'une fonctionnalité pour ses projets. 
Il n'y à rien de pire que d'avoir les méthode sans comprendre comment 
l'employer.

Suivez d'abord le guide pour comprendre son emploi dans sa forme la plus simple 
avant d'utilise le programme d'example ZCL_LOG_UTIL_EXAMPLE (SE38 / SE80).




### Initialization & Configuration



### Logging & Display



### Default Values & Behavior






## Detailed guide & Features


### Handle custom (or unknown standard) log table


### Application Log (SLG)


### Message Overloading







````plaintext
- gérer les messages custo & standard
- Savoir gérer une log et une table
- faire du SLG en //
- gérer l'affichage
- savoir gardé les version d'origine
- Prévoir les structures standard, mais permettre un mapping de zones pour une structure différente (entrée et sortie)
- Notion start spot, endspot



Phase initialisation :
	- définit si SLG oui non
		- Objet
		- Sous objet
		- External ref
		- Retention
	- définition mapping entrée et sortie
		- structure name IN :
			- xxx <= msgid
			- yyy <= msgno
			- zzz <= msgty 
			(...)
		- structure name OUT :
			- msgid => xxx
			(...)
		- table standard (BAPIRET2 et PROTT enregistré on construct)
		- Gérer la surchages :
			- définir table de parametrage
				- définir role des zones :
					- spot 
					- inputs
					- outputs
		- Configuration affichage
			- allSpool
			- allProt
			- setTypeToSpool
			- setTypeToPrott
		- setColumnName pour l'ALV
		
		
Phase utilisation
	- instanciation
	- [startSpot()
	- log() (le plus simple possible) :
		- Enregistrement
			- stocker la version originale
	- [endSpot()
	- display()
		- batch :
			- separation spool prot
		- Afficher info technique : OUI / NON
			- Afficher orignaux : OUI / NON
````
