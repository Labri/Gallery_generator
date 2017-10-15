#! /bin/sh                                             

# Test sur un répertoire source dont l'un des fichiers contient une étoile.      

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

rm -fr source_test dest
mkdir -p source_test dest
compteur=0
while [ $compteur -lt $1 ] ; do
    make-img.sh source_test/"image$compteur.jpg"
    compteur=$((compteur+1))
done;
