#! /bin/sh

# Test sur un répertoire source dont l'un des fichiers contient une étoile.

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

rm -fr source_test dest
mkdir -p source_test dest

make-img.sh source_test/image1.jpg
make-img.sh source_test/image2.jpg

galerie-shell.sh --source source_test --dest dest

for image in source_test/*jpg; do
    if [ -f dest/"$image" ] ; then
	echo "Bonne création de la vignette $image"
    else
	echo "ERROR: Vignette non générée."
	exit
    fi
done;
