#!/bin/bash

DIR_TOOLS=$(cd "$(dirname "$0")"/tools && pwd)

. "$DIR_TOOLS"/utilities.sh

rep=""
dest="dest"
verb=0
force=0
help=0
open=0
fichier="index.html"
title="Ma galerie"
para=4
while [ $# -gt 0 ]; do
    case $1 in
	"--source") shift; rep=$1;
		    if [ ! -d "./$rep" ] ; then
			echo "Le répertoire source n'existe pas"
			exit
		    fi;
		    shift;;
	"--dest") shift; dest=$1; shift;;
	"--verb") verb=1; shift;;
	"--force") force=1; shift;;
	"--help") help=1; shift;;
	"--index") shift; if [ "$1" == "" ]; then
		echo "aucun nom rentré, le fichier final sera donc nommé index.html">&2
	    else
		fichier=$1; shift;
	    fi;;
	"--open") open=1; shift;;
	"--title") shift; title=$1; shift;;
	"--para") shift;  if  [ "$(echo "$1" | grep -v "[a-Z]" -c)" -eq 0 ] || [ "$1" == "" ]; then
			      echo "Erreur valeur de Para non entière positive ou nulle">&2
			      exit
			  else
			      para=$1; shift;
			  fi;;
	*)echo "problème lors de la saisie des arguments, rentrer --help pour plus d'informations.";exit;;
    esac;
done;

#*********************************************************

fichier=${fichier%.*l}
fichier="$fichier".html

#***********************************************************
if [ "$rep" != "" ] ; then
    galerie_main "$rep" "$dest" "$verb" "$force" "$fichier" "$help" "$open" "$title" "$para"
else
    "Veuillez rentrer un répertoire source, pour plus d'informations, rentrer --help"
fi;
