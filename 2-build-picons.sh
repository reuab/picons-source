#!/bin/bash

#####################
## Setup locations ##
#####################
location=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
temp=$(mktemp -d --suffix=.picons)
logfile=$(mktemp --suffix=.picons.log)

echo -e "\nLog file located at: $logfile\n"

########################################################
## Search for required commands and exit if not found ##
########################################################
commands=( convert pngquant rsvg-convert ar tar xz sed grep tr column cat sort find mkdir rm cp mv ln readlink )

for i in ${commands[@]}; do
    if ! which $i &> /dev/null; then
        missingcommands="$i $missingcommands"
    fi
done
if [[ ! -z $missingcommands ]]; then
    echo "ERROR: The following commands are not found: $missingcommands" >> $logfile
    echo "ERROR: Try installing on Ubuntu: imagemagick pngquant binutils librsvg2-bin" >> $logfile
    echo "ERROR: Try installing on Cygwin: imagemagick pngquant binutils rsvg" >> $logfile
    exit 1
fi

###########################
## Check path for spaces ##
###########################
if [[ $location == *" "* ]]; then
    echo "ERROR: The path contains spaces, please move the repository to a path without spaces!" >> $logfile
    exit 1
fi

##############################################
## Ask the user whether to build SNP or SRP ##
##############################################
if [[ -z $1 ]]; then
    echo "Which style are you going to build?"
    select choice in "Service Reference" "Service Reference (Full)" "Service Name" "Service Name (Full)"; do
        case $choice in
            "Service Reference" ) style=srp; break;;
            "Service Reference (Full)" ) style=srp-full; break;;
            "Service Name" ) style=snp; break;;
            "Service Name (Full)" ) style=snp-full; break;;
        esac
    done
else
    style=$1
fi

#############################################
## Check if previously chosen style exists ##
#############################################
if [[ ! $style = "srp-full" ]] && [[ ! $style = "snp-full" ]]; then
    for file in $location/build-output/servicelist-*-$style ; do
        if [[ ! -f $file ]]; then
            echo "ERROR: No $style servicelist has been found!" >> $logfile
            exit 1
        fi
    done
fi

###########################################
## Cleanup binaries folder and re-create ##
###########################################
binaries=$location/build-output/binaries-$style
if [[ -d $binaries ]]; then rm -rf $binaries; fi
mkdir $binaries

##############################
## Determine version number ##
##############################
if [[ -d $location/.git ]] && which git &> /dev/null; then
    hash=$(git rev-parse --short HEAD)
    version=$(date --date=@$(git show -s --format=%ct $hash) +'%Y-%m-%d--%H-%M-%S')
    timestamp=$(date --date=@$(git show -s --format=%ct $hash) +'%Y%m%d%H%M.%S')
else
    epoch="date +%s"
    version=$(date --date=@$($epoch) +'%Y-%m-%d--%H-%M-%S')
    timestamp=$(date --date=@$($epoch) +'%Y%m%d%H%M.%S')
fi

echo "$(date +'%H:%M:%S') - Version: $version"

#############################################
## Some basic checking of the source files ##
#############################################
echo "$(date +'%H:%M:%S') - Checking index"
$location/resources/tools/check-index.sh $location/build-source srp
$location/resources/tools/check-index.sh $location/build-source snp

echo "$(date +'%H:%M:%S') - Checking logos"
$location/resources/tools/check-logos.sh $location/build-source/logos

#####################
## Create symlinks ##
#####################
echo "$(date +'%H:%M:%S') - Creating symlinks"
$location/resources/tools/create-symlinks.sh $location $temp $style

####################################################################
## Start the actual conversion to picons and creation of packages ##
####################################################################
logocount=$(readlink $temp/symlinks/* | sed -e 's/logos\///g' -e 's/.png//g' | sort -u | wc -l)
mkdir -p $temp/cache

if [[ -f $location/build-input/backgrounds.conf ]]; then
    backgroundsconf=$location/build-input/backgrounds.conf
else
    echo "$(date +'%H:%M:%S') - No \"backgrounds.conf\" file found in \"build-input\", using default file!"
    backgroundsconf=$location/build-source/backgrounds/backgrounds.conf
fi

grep -v -e '^#' -e '^$' $backgroundsconf | while read lines ; do
    currentlogo=""

    OLDIFS=$IFS
    IFS=";"
    line=($lines)
    IFS=$OLDIFS

    resolution=${line[0]}
    resize=${line[1]}
    type=${line[2]}
    background=${line[3]}

    packagenamenoversion=$style.$resolution-$resize.$type.on.$background
    packagename=$style.$resolution-$resize.$type.on.${background}_${version}

    mkdir -p $temp/package/picon/logos

    echo "$(date +'%H:%M:%S') -----------------------------------------------------------"
    echo "$(date +'%H:%M:%S') - Creating picons: $packagenamenoversion"

    readlink $temp/symlinks/* | sed -e 's/logos\///g' -e 's/.png//g' | sort -u | while read logoname ; do
        ((currentlogo++))
        echo -ne "           Converting logo: $currentlogo/$logocount"\\r

        if [[ -f $location/build-source/logos/$logoname.$type.png ]] || [[ -f $location/build-source/logos/$logoname.$type.svg ]]; then
            logotype=$type
        else
            logotype=default
        fi

        echo $logoname.$logotype >> $logfile

        if [[ -f $location/build-source/logos/$logoname.$logotype.svg ]]; then
            logo=$temp/cache/$logoname.$logotype.png
            if [[ ! -f $logo ]]; then
                rsvg-convert -w 1000 -h 1000 -a -f png -o $logo $location/build-source/logos/$logoname.$logotype.svg
                #inkscape --without-gui -w 850 --export-area-drawing --file=$location/build-source/logos/$logoname.$logotype.svg --export-png=$logo >> $logfile
            fi
        else
            logo=$location/build-source/logos/$logoname.$logotype.png
        fi

        convert $location/build-source/backgrounds/$resolution/$background.png \( $logo -background none -bordercolor none -border 100 -trim -border 1% -resize $resize -gravity center -extent $resolution +repage \) -layers merge - 2>> $logfile | pngquant - 2>> $logfile > $temp/package/picon/logos/$logoname.png
    done

    echo "$(date +'%H:%M:%S') - Creating binary packages: $packagenamenoversion"
    cp --no-dereference $temp/symlinks/* $temp/package/picon

    mkdir $temp/package/CONTROL ; cat > $temp/package/CONTROL/control <<-EOF
		Package: enigma2-plugin-picons-$packagenamenoversion
		Version: $version
		Section: base
		Architecture: all
		Maintainer: https://picons.xyz
		Source: https://picons.xyz
		Description: $packagenamenoversion
		OE: enigma2-plugin-picons-$packagenamenoversion
		HomePage: https://picons.xyz
		License: unknown
		Priority: optional
	EOF

    find $temp/package -exec touch --no-dereference -t $timestamp {} \;

    $location/resources/tools/ipkg-build.sh -o root -g root $temp/package $binaries >> $logfile
    mv $temp/package/picon $temp/package/$packagename
    tar --dereference --owner=root --group=root -cf - --directory=$temp/package $packagename --exclude=logos | xz -9 --extreme --memlimit=40% 2>> $logfile > $binaries/$packagename.hardlink.tar.xz
    tar --owner=root --group=root -cf - --directory=$temp/package $packagename | xz -9 --extreme --memlimit=40% 2>> $logfile > $binaries/$packagename.symlink.tar.xz

    find $binaries -exec touch -t $timestamp {} \;
    rm -rf $temp/package
done

######################################
## Cleanup temporary files and exit ##
######################################
if [[ -d $temp ]]; then rm -rf $temp; fi

exit 0
