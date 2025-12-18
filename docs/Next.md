# Next 

## Button 4 et 5 problème potentiel

### Boutton press boutton release 

Est ce que cela est bien géré meme à une intervalle lente ?

### Mode Adaptive 

si le boutton est préssé, on va considéré les prochains tic comme inactive, alors que s'il est press le boutton, il faut que ce soit réactif quand il lache. et actuellement meme sans tester je peux affirmer que le state TO_IDLE va s'enclencher.


## Idée v 1.1 Started in branch test_dynamic_scroll
Utilisé bit restant pour  deux possibilités

### Dynamic Wheel bit 2 ou bit 3 (celui qui nous laisse le plus de possibilité)

sur le meme concept de delta global entre début wheel et fin wheel et adapter un multiplilcateur dynamic. 

Exemple: je suis dans DirectoryOpus avec une longue liste de fichier ou dans un Editeur de fichier avec une long liste de lignes, pour décendre au bottom, je dois donner presque autant de coup de wheel que il y a d'elément, alors que si je scroll scroll scroll scroll, ca devrait dynamiquemeent s'accélérer pour arriver au bottom vite fait.

## Analyse

Faire une analyse complete des documentation technique (.md), github (.md), release (.guide, .readme),  du fichier Install. 

Y a - t - il des choses a corrigé ?

## Release XMouseD.lha via .\scripts\build-release.ps1

Structure de l'archive finale :

```
XMouseD.lha
  + XMouseD-<version>
     - "Install XMouseD"
     - "Install XMouseD.info"
     - XMouseD
     - XMouseD.guide
     - XMouseD.guide.info
  - XMouseD-<version>.info
  - XMouseD-<version>.readme
  - XMouseD-<version>.readme.info
```

## Documentation - Actions restantes

### Placeholders à remplacer
Exécuter `.\scripts\env-replace.ps1` sur tous les fichiers de documentation avant release :
- README.md
- XMouseD.guide
- XMouseD.readme
- CHANGELOG.md
- Install

Format : `~ VALUE [VAR_ENV_NAME]~` sera remplacé par la valeur de l'environnement.

### ROADMAP.md
Supprimer ou archiver - obsolète maintenant que v1.0 est sortie.



