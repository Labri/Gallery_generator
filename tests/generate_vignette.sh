#! /bin/sh

# Test sur la bonne création des vignettes dans le rep dest.

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

rm -fr source_test dest
mkdir -p source_test dest

make-img.sh source_test/image1.jpg
make-img.sh source_test/image2.jpg

galerie-shell.sh --source source_test --dest dest
cd source_test
for image in *jpg ; do
    if [ -e ../dest/"$image" ] ; then
	echo "Bonne création de la vignette $image dans le fichier dest"
    else
	echo "ERROR: Vignette non générée."
	exit
    fi
done;


