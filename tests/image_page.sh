#! /bin/sh

# Test sur la bonne création des differentes pages html dédié à chaque vignette du rep dest.

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

rm -fr source_test dest
mkdir -p source_test dest

make-img.sh source_test/image1.jpg
make-img.sh source_test/image2.jpg

galerie-shell.sh --source source_test --dest dest
cd source_test
for image in *jpg ; do
    if [ -e ../dest/"$image".html ] ; then
	echo "Bonne création de la page web asscoiée à la vignette $image, dans le fichier dest."
    else
	echo "ERROR: Page web non générée."
	exit
    fi
    done;
