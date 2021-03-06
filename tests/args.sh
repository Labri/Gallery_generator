#! /bin/sh

# Test sur la bonne interprétation des differents mode d'activation.

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

rm -fr source_test dest
mkdir -p source_test dest

make-img.sh ./tests/source_test/image1.jpg

echo -e "Test mode verbueux:\n"
galerie-shell.sh --source source_test --dest dest --verb
echo -e "Test Force\n"
galerie-shell.sh --source source_test --dest dest --verb --force
echo -e "Test Index\n"
galerie-shell.sh --source source_test --dest dest --verb --force --index test.html
echo -e "Test Open\n"
galerie-shell.sh --source source_test --dest dest --verb --force --index test.html --open
echo -e "Test Help\n"
galerie-shell.sh --source source_test --dest dest --verb --force --index test.html --open --help
echo -e "Test para\n"
galerie-shell.sh --source source_test --dest dest --verb --force --index test.html --para 0



