#!/bin/bash

########################################################
## Search for required commands and exit if not found ##
########################################################
commands=( convert pngquant rsvg-convert ar tar xz sed grep tr column cat sort find echo mkdir chmod rm cp mv ln pwd basename mktemp )

for i in "${commands[@]}"; do
    if ! which $i &> /dev/null; then
        missingcommands="$i $missingcommands"
    fi
done
if [[ ! -z $missingcommands ]]; then
    echo "The following commands are not found: $missingcommands"
    echo ""
    echo "Try installing the following packages:"
    echo "imagemagick pngquant binutils librsvg2-bin (Ubuntu)"
    echo "imagemagick pngquant binutils rsvg (Cygwin)"
    read -p "Press any key to exit..." -n1 -s
    exit
fi

##############################################
## Ask the user whether to build SNP or SRP ##
##############################################
if [[ -z $1 ]]; then
    echo "Which style are you going to build?"
    select choice in "Service Reference" "Service Name"; do
        case $choice in
            "Service Reference" ) style=srp; break;;
            "Service Name" ) style=snp; break;;
        esac
    done
else
    style=$1
fi

############################
## Setup folder locations ##
############################
location="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
buildsource="$location/build-source"
buildtools="$location/resources/tools"
binaries="$location/build-output/binaries-$style"
temp=$(mktemp -d --suffix=.picons)
logfile=$(mktemp --suffix=.picons.log)

#############################################
## Check if previously chosen style exists ##
#############################################
if [[ $style = "srp" ]] || [[ $style = "snp" ]]; then
    for file in "$location/build-output/servicelist-"*"-$style" ; do
        if [[ ! -f $file ]]; then
            echo "No $style servicelist has been found! Exiting..."
            read -p "Press any key to exit..." -n1 -s
            exit
        fi
    done
else
    echo "You are using an unsupported style! Keep it tidy!"
fi

###########################################################
## Ask the user which resolution and background to build ##
###########################################################
if [[ -z $2 ]]; then
    for background in "$buildsource/backgrounds/"* ; do
        backgroundname=$(basename $background)
        backgrounds="$backgroundname $backgrounds"
    done

    echo "Which resolution would you like to build?"
    select choice in $backgrounds; do
        if [[ ! -z $choice ]]; then
            backgroundname=$choice; break
        fi
    done

    for backgroundcolor in "$buildsource/backgrounds/$backgroundname/"* ; do
        backgroundcolorname=$(basename ${backgroundcolor%.*})
        backgroundcolors="$backgroundcolorname $backgroundcolors"
    done

    echo "Which background would you like to build?"
    select choice in $backgroundcolors; do
        if [[ ! -z $choice ]]; then
            backgroundcolorname=$choice; break
        fi
    done
else
    if [[ $2 = "all" ]]; then
        backgroundname=""
        backgroundcolorname=""
    else
        backgroundname=$2
        if [[ -z $3 ]]; then
            for backgroundcolor in "$buildsource/backgrounds/$backgroundname/"* ; do
                backgroundcolorname=$(basename ${backgroundcolor%.*})
                backgroundcolors="$backgroundcolorname $backgroundcolors"
            done

            echo "Which background would you like to build?"
            select choice in $backgroundcolors; do
                if [[ ! -z $choice ]]; then
                    backgroundcolorname=$choice; break
                fi
            done
        else
            if [[ $3 = "all" ]]; then
                backgroundcolorname=""
            else
                backgroundcolorname=$3
            fi
        fi
    fi
fi

############################################################
## Cleanup previously created folders/files and re-create ##
############################################################
if [[ -d $binaries ]]; then rm -rf "$binaries"; fi
mkdir "$binaries"

##############################
## Determine version number ##
##############################
if [[ -d $location/.git ]] && which git &> /dev/null; then
    hash="$(git rev-parse --short HEAD)"
    version="$(date --date=@$(git show -s --format=%ct $hash) +'%Y-%m-%d--%H-%M-%S')"
    timestamp="$(date --date=@$(git show -s --format=%ct $hash) +'%Y%m%d%H%M.%S')"
else
    epoch="date +%s"
    version="$(date --date=@$($epoch) +'%Y-%m-%d--%H-%M-%S')"
    timestamp="$(date --date=@$($epoch) +'%Y%m%d%H%M.%S')"
fi

echo "$(date +'%H:%M:%S') - Version: $version"

#############################################
## Some basic checking of the source files ##
#############################################
chmod -R 755 "$buildtools/"*.sh

echo "$(date +'%H:%M:%S') - Checking index"
"$buildtools/check-index.sh" "$buildsource" "srp"
"$buildtools/check-index.sh" "$buildsource" "snp"

echo "$(date +'%H:%M:%S') - Checking logos"
"$buildtools/check-logos.sh" "$buildsource/logos"

#############################################################
## Create symlinks, copy required logos and convert to png ##
#############################################################
echo "$(date +'%H:%M:%S') - Creating symlinks and copying logos"
"$buildtools/create-symlinks+copy-logos.sh" "$location/build-output/servicelist-" "$temp/newbuildsource" "$buildsource" "$style" "$location"

echo "$(date +'%H:%M:%S') - Converting svg files"
for file in "$temp/newbuildsource/logos/"*.svg; do
    rsvg-convert -w 1000 -h 1000 -a -f png -o ${file%.*}.png "$file"
    rm "$file"
done

####################################################################
## Start the actual conversion to picons and creation of packages ##
####################################################################
logocount=$(find "$temp/newbuildsource/logos/" -maxdepth 2 -type f | wc -l)

for background in "$buildsource/backgrounds/$backgroundname"* ; do
    backgroundname=$(basename $background)

    for backgroundcolor in "$buildsource/backgrounds/$backgroundname/$backgroundcolorname"*.png ; do
        currentlogo=""
        backgroundcolorname=$(basename ${backgroundcolor%.*})

        OLDIFS=$IFS
        IFS="-"
        sizes=($backgroundname)
        IFS="."
        logotype=($backgroundcolorname)
        IFS=$OLDIFS
        
        resolution=${sizes[0]}
        logotype=${logotype[0]}

        if [[ $backgroundcolorname == *-nopadding ]]; then
            resize=${sizes[0]}
        else
            resize=${sizes[1]}
        fi

        mkdir -p "$temp/finalpicons/picon/logos"

        echo "$(date +'%H:%M:%S') -----------------------------------------------------------"
        echo "$(date +'%H:%M:%S') - Creating picons: $style.$resolution.$backgroundcolorname"

        for logo in "$temp/newbuildsource/logos/"*.default.png ; do
            ((currentlogo++))
            echo -ne "           Converting logo: $currentlogo/$logocount"\\r

            logoname=$(basename ${logo%.*.*})

            if [[ -f $temp/newbuildsource/logos/$logoname.$logotype.png ]]; then
                logo="$temp/newbuildsource/logos/$logoname.$logotype.png"
            fi

            echo "$logo" >> $logfile
            convert "$backgroundcolor" \( "$logo" -background none -bordercolor none -border 100 -trim -border 1% -resize $resize -gravity center -extent ${sizes[0]} +repage \) -layers merge - 2>> $logfile | pngquant - 2>> $logfile > "$temp/finalpicons/picon/logos/$logoname.png"
            #cat "$backgroundcolor" | git lfs smudge 2>> $logfile | convert - \( "$logo" -background none -bordercolor none -border 100 -trim -border 1% -resize $resize -gravity center -extent ${sizes[0]} +repage \) -layers merge - 2>> $logfile | pngquant - 2>> $logfile > "$temp/finalpicons/picon/logos/$logoname.png"
        done

        echo "$(date +'%H:%M:%S') - Creating binary packages: $style.$resolution.$backgroundcolorname"
        cp --no-dereference "$temp/newbuildsource/symlinks/"* "$temp/finalpicons/picon"

        packagename="$style.$resolution.${backgroundcolorname}_${version}"

        mkdir "$temp/finalpicons/CONTROL" ; cat > "$temp/finalpicons/CONTROL/control" <<-EOF
			Package: enigma2-plugin-picons-$style.$resolution.$backgroundcolorname
			Version: $version
			Section: base
			Architecture: all
			Maintainer: https://picons.xyz
			Source: https://picons.xyz
			Description: $style.$resolution.$backgroundcolorname
			OE: enigma2-plugin-picons-$style.$resolution.$backgroundcolorname
			HomePage: https://picons.xyz
			License: unknown
			Priority: optional
		EOF

        find "$temp/finalpicons" -exec touch --no-dereference -t "$timestamp" {} \;

        "$buildtools/ipkg-build.sh" -o root -g root "$temp/finalpicons" "$binaries" > /dev/null
        mv "$temp/finalpicons/picon" "$temp/finalpicons/$packagename"
        tar --dereference --owner=root --group=root -cf - --directory="$temp/finalpicons" "$packagename" --exclude="logos" | xz -9 --extreme --memlimit=40% 2>> $logfile > "$binaries/$packagename.hardlink.tar.xz"
        tar --owner=root --group=root -cf - --directory="$temp/finalpicons" "$packagename" | xz -9 --extreme --memlimit=40% 2>> $logfile > "$binaries/$packagename.symlink.tar.xz"

        find "$binaries" -exec touch -t "$timestamp" {} \;
        rm -rf "$temp/finalpicons"
    done

    backgroundcolorname=""
done

################################################################################
## Cleanup temporary files and let the user know the location of the packages ##
################################################################################
if [[ -d $temp ]]; then rm -rf "$temp"; fi

echo -e "\nThe binary packages are located in:\n$binaries\n"

##########################
## Ask the user to exit ##
##########################
if [[ -z $1 ]]; then
    read -p "Press any key to exit..." -n1 -s
fi

echo -e "\n"
exit 0
