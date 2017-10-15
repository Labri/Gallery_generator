#!/bin/bash
html_head(){
    #echo "Entrez le titre de la page"                                                               
    #read reponse                    

    echo "<!DOCTYPE html>"
    echo "<head><title>$1</title>" 
    echo "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">"
    echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"$2/tools/style.css\" />"
    echo "</head><body>"

}

html_tail(){
    echo 
    echo "<footer><div>"
    echo "<a href=\"http://validator.w3.org/check?uri=referer\"><img src=\"$1/tools/HTML5.png\" alt=\"Valid Html\"></a><br>"
    echo "Script développé par Stenzel Cackowski et César Dumas.<br>"
    echo "<a href=\"../rapport/rapport.html\" target=\"_blank\">Visionner notre rapport</a></div></footer></body></html>"
}
html_title() {
    echo "<h1>$1</h1>"
}



generate_img_fragment_para() {
    #Déclaration des variable**************************************
    source="$PWD"
    rep=$1
    dest=$2
    verb=$3
    force=$4
    para=$5
    column=1 #nous servira lors de la création du tableau dimage
    #Debut script***********************************************
    
    cd "$rep" || exit 
    echo "<div><table><tr>"
    chaine=''
    for image in *.jpg ; do
	if [ ! -e "$source/$dest/$image" ] || [ "$force" -eq 1 ] ; then
	    longueur=$(echo $chaine | wc -w)
	    if [ "$longueur" -lt $((7*$para)) ] ; then
		if [ "$verb" -eq "1" ] ; then
                    echo -e "\tConversion de $para images en miniature 200x200 " >&2
                    if [ "$force" -eq 1 ]; then
			echo -e "\t\ton recréé les anciennes vignettes, car le mode forcage est activé" >&2
		    else
			echo -e "\t\tcréation de ces miniatures dans le fichier $dest" >&2
		    fi;
		fi;
		chaine=$chaine"$image -cubism , -resize 200,200 -output $source/$dest/$image "
	    else
		echo "$chaine" | xargs -n 7 -P "$para" gmic 2>/dev/null
		chaine="$image -cubism , -resize 200,200 -output $source/$dest/$image "
	    fi;
	else
	    if [ "$verb" -eq 1 ] ; then
		echo "Pas de conversion car la vignette $image est déjà présente dans $dest. " >&2
	    fi;
	fi;
    done;
    if [ "$chaine" != "" ] ; then
	if [ "$verb" -eq 1 ] ; then
                echo -e "\tConversion des dernières images. " >&2
        fi;
	echo "$chaine" | xargs -n 7 -P "$para" gmic 2>/dev/null
    fi;
    cd "$source/$dest" || exit
    for image in *.jpg ; do
	if [ -e "$source/$rep/$image" ] ; then
	    if [ "$column" -eq 5 ] ; then
		echo "</tr><tr>"
		column=1
	    fi;
	    affiche_img "$image" "$verb"
	    column=$((column+1))
	fi;
    done;
    echo "</tr></table>"
    echo "Cliquez sur les images pour les visualiser en taille réelle.</div>"
    cd "$source" || exit
}    


generate_img_fragment(){
    #Déclaration des variable**************************************
    source="$PWD"
    rep=$1
    dest=$2
    verb=$3
    force=$4
    para=$5
    column=1 #nous servira lors de la création du tableau dimage
    #Debut script***********************************************
	
    cd "$rep" || exit
    echo "<div align=center><table><tr>"

    for image in *.jpg ; do
	if [ ! -e "$source/$dest/$image" ] || [ "$force" -eq 1 ] ; then
	    gmic "$image" -cubism , -resize 200,200 -output "$source"/"$dest"/"$image" 2>/dev/null
	    if [ "$verb" -eq "1" ] ; then
		echo -e "\tConversion de $image en miniature 200x200 " >&2
		if [ "$force" -eq 1 ]; then
	            echo -e "\t\ton remplace lancienne vignette $image par la nouvelle, car le mode forcage est activé" >&2
		else
		    echo -e "\t\tcréation de cette miniature $image dans le fichier $dest" >&2
		fi;
	   fi;
	else
	    if [ "$verb" -eq 1 ] ; then
		echo -e "\tPas de conversion car la vignette $image est déjà présente dans $dest. " >&2
	    fi;
	fi;
	if [ "$column" -eq 5 ] ; then
	    echo "</tr><tr>"
	    column=1
	fi;
        affiche_img "$image" "$verb"
	column=$((column+1))
    done;
    echo "</tr></table>"
    echo "Cliquez sur les images pour les visualiser en taille réelle.</div>"
    cd "$source" || exit
}

affiche_img(){
    image=$1
    verb=$2
    if [ "$verb" -eq 1 ] ; then
	echo -e "\tAffichage de $image, de son nom et date de prise de vue en légende sur notre page web. " >&2
    fi;
    echo "<td><figure>"
    image=${image%.*g}
    echo "<a href=\"$image.html\"><img class=\"image\" src=\"$image.jpg\"></a>"
    prise_vue=$(identify -verbose "$image".jpg | grep "exif:DateTimeOriginal:")

    if [ "$verb" -eq 1 ] ; then
	echo -e "\t\tRécupération de la date de prise de vue de l'image et ajout à la légende" >&2
    fi;
    if [ "$prise_vue" = '' ] ; then
	echo " <figcaption>$image</figcaption></figure></td>"
    else
	prise_vue=${prise_vue:26}
	echo " <figcaption>$image datant du $prise_vue </figcaption></figure></td>"
    fi;
}

navigateur(){
    source="$PWD"
    dest=$1
    rep=$2
    index=$3
    verb=$4
    cd "$source/$rep" || exit
    if [ "$verb" -eq 1 ] ; then
	echo "Création des différentes pages contenant une image en taille réelle.">&2
    fi;
    for image in *.jpg ; do
	image=${image%.*g}
	(
	    html_head "$image" "$source"
	    html_title "$image"
	    echo "<div align=center>"
	    echo "<img class=\"image_2\" src=\"$source/$rep/$image.jpg\">"
	    echo "<p>Naviguer vers : </p>"
	    echo "<FORM><SELECT onChange=\"document.location=this.options[this.selectedIndex].value\">"
	    echo "<OPTION>Menu</OPTION>"
	    for lien in *.jpg ; do
		lien=${lien%.*g}
		if [ "$lien" != "$image" ] ; then
		    echo "<OPTION class=\"Button\" VALUE=\"$lien.html\"> $lien</OPTION>"
		fi;
	    done;
	    echo "<OPTION class=\"Button\" VALUE=\"$index\">Retour Galerie</OPTION>"
	    echo "</SELECT></FORM></div>"
	    html_tail "$source"
	) > "$source/$dest/$image.html"
    done;
}

help(){
    echo -e "Utilisation du script :"
    echo -e  "\t--source REP\t\tRépertoire contenant les images JPEG à miniaturiser,"
    echo -e  "\t--dest REP\t\tRépertoire cible, où l'on va générer les vignettes et la galerie HTML. Par défaut il s'appellera 'Dest',"
    echo -e "\t--verb \t\t\tsi vous désirez executer le script en mode verbueux,"
    echo -e "\t--force \t\tForce la création des vignettes, même si elles existent déja,"
    echo -e "\t--index NAME \t\tNom du fichier html généré, par défaut : index.html"
    echo -e "\t--open\t\t\tOuvre la galerie dans firefox à la fin du script,"
    echo -e "\t--help\t\t\tAffiche ce message et quitte le programme,"
    echo -e "\t--title TITLE\t\tTitre de la page html générée, par défaut : Ma belle galerie,"
    echo -e "\t--para NOMBRE\t\tIndique que les vignettes seront générées en parallèle. NOMBRE représente le nombre de vignette à créer en même temps (dans la limite des capacités matérielles de votre PC), par défaut : 4; 1 afin que les vignettes soient générées une par une."
}

galerie_main(){
    rep=$1
    dest=$2
    verb=$3
    force=$4
    index=$5
    help=$6
    open=$7
    title=$8
    para=$9
    tools="$PWD"
    #***********************************
    if [ "$help" -eq 1 ]; then
	help >&2
	exit
    fi;
    
    if [ ! -d "./$dest" ] ; then
	mkdir "$dest"
	if [ "$verb" -eq "1" ] ; then
	    echo "On créé un fichier $dest qui contiendra tous les fichiers utiles à la  création de la galerie." > ./"$dest"/verb.txt
	fi;
    else
        if [ "$verb" -eq 1 ] ; then
	    echo "Le dossier $dest existe deja, pas besoin de le créer." > ./"$dest"/verb.txt
	fi;
    fi;
    (
	if [ "$verb" -eq 1 ] ; then
	    echo "Appel de la fonction html_head qui nous code l'entête de notre galerie." >&2
	fi;
	html_head "ma belle galerie" "$tools"
	if [ "$verb" -eq 1 ] ; then
	    echo "Appel de html_title qui nous code le titre de la galerie." >&2
	fi;
	html_title "$title"
	if [ "$verb" -eq 1 ] ; then
	    echo "Appel de la fonction qui nous ajoute les images à notre galerie." >&2
	    echo "La galerie sera représentée sous forme de tableau de 4 colones." >&2; echo "" >&2
	fi;
	if [ "$para" -lt 2 ]; then
	    if [ "$verb" -eq 1 ] ; then
                echo "Génération séquentielle de nos vignettes." >&2
            fi;
	    generate_img_fragment "$rep" "$dest" "$verb" "$force"
	else
	    if [ "$verb" -eq 1 ] ; then
		echo "Génération parallèle de nos vignettes." >&2
	    fi;
	    generate_img_fragment_para "$rep" "$dest" "$verb" "$force" "$para"
	    
	fi;
	if [ "$verb" -eq 1 ] ; then
	    echo "Appel de la fonction html_tail qui nous code la pied de page de notre galerie." >&2
	fi;
	html_tail "$tools"
    ) >./"$dest"/"$index"
    navigateur "$dest" "$rep" "$index" "$verb"
    
    if [ "$open" -eq 1 ]; then
	cd "$tools" || exit
	firefox "$dest"/"$index"
    else
	echo "$index généré, pour visualiser la galerie, rentrer la commande:"
	echo
	echo "  firefox $dest/$index"
	echo
	echo "enjoy."
    fi;
}
#************************************************************
