#! /bin/sh                                                                       

# Test sur la bonne création du dossier dest si celui ci nexiste pas lors de l'appel de notre script. 
HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

rm -fr source_test dest
mkdir -p source_test 

make-img.sh source_test/"image1.jpg"

galerie-shell.sh --source source_test --dest dest
if [ -d "dest" ] ; then
    echo "Bonne création du répertoire dest."
else
    echo "Répertoire dest non généré."
    exit
fi;
