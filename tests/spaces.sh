#! /bin/sh

# Test sur la bonne création de la galerie sachant qu'un nom d'image contient un espace.

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

rm -fr source_test dest
mkdir -p source_test dest

make-img.sh source_test/"imag e1.jpg"

galerie-shell.sh --source source_test --dest dest --open
cd source_test
for image in *jpg ; do
    if [ -e ../dest/"$image" ] ; then
	echo "L'image a bien été miniaturisée, bonne affichage même en présence d'un espace"
    else
	echo "ERROR: Vignette non générée."
	exit
    fi
done;


