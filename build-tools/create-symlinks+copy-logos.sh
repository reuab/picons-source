#!/bin/bash

serviceref_list="$1"
build_location="$2"
source_location="$3"
style="$4"
repodir="$5"

if [[ -d $build_location ]]; then
    rm -rf "$build_location"
fi

mkdir -p "$build_location/symlinks"
mkdir -p "$build_location/logos"

cd "$repodir"

####################################################################
## Create symlinks and copy logos for SNP & SRP using servicelist ##
####################################################################
if [[ $style = "snp" ]] || [[ $style = "srp" ]]; then
    cat "$serviceref_list"*"$style" | tr -d [:blank:] | tr -d [=*=] | while read line ; do
        IFS="|"
        line_data=($line)
        serviceref=${line_data[0]}
        link_srp=${line_data[2]}
        link_snp=${line_data[3]}

        IFS="="
        link_srp=($link_srp)
        logo_srp=${link_srp[1]}
        link_snp=($link_snp)
        logo_snp=${link_snp[1]}
        snpname=${link_snp[0]}

        if [[ ! $logo_srp = "--------" ]]; then
            ln -s -f "logos/$logo_srp.png" "$build_location/symlinks/$serviceref.png"
            cp -n "$source_location/logos/$logo_srp.*" "$build_location/logos/"
            #find "$source_location/logos/" -maxdepth 1 -type f -name "$logo_srp.*" -exec cp -n {} "$build_location/logos/" \;
            #find "$source_location/logos/" -maxdepth 1 -type f -name "$logo_srp.*" -exec sh -c 'cat {} | git lfs smudge 2>> /tmp/picons.log > '$build_location'/logos/$(basename {})' \;
        fi

        if [[ $style = "snp" ]] && [[ ! $logo_snp = "--------" ]]; then
            ln -s -f "logos/$logo_snp.png" "$build_location/symlinks/$snpname.png"
            cp -n "$source_location/logos/$logo_snp.*" "$build_location/logos/"
            #find "$source_location/logos/" -maxdepth 1 -type f -name "$logo_snp.*" -exec cp -n {} "$build_location/logos/" \;
            #find "$source_location/logos/" -maxdepth 1 -type f -name "$logo_snp.*" -exec sh -c 'cat {} | git lfs smudge 2>> /tmp/picons.log > '$build_location'/logos/$(basename {})' \;
        fi
    done
fi

#########################################################
## Create symlinks and copy logos using only snp-index ##
#########################################################
if [[ $style = "snp-full" ]]; then
    sed '1!G;h;$!d' "$source_location/snp-index" | while read line ; do
        IFS="="
        link_snp=($line)
        logo_snp=${link_snp[1]}
        snpname=${link_snp[0]}

        if [[ $snpname == *"_"* ]]; then
            ln -s -f "logos/$logo_snp.png" "$build_location/symlinks/"'1_0_1_'"$snpname"'_0_0_0'".png"
        else
            ln -s -f "logos/$logo_snp.png" "$build_location/symlinks/$snpname.png"
        fi

        cp -n "$source_location/logos/$logo_snp.*" "$build_location/logos/"
        #find "$source_location/logos/" -maxdepth 1 -type f -name "$logo_snp.*" -exec cp -n {} "$build_location/logos/" \;
        #find "$source_location/logos/" -maxdepth 1 -type f -name "$logo_snp.*" -exec sh -c 'cat {} | git lfs smudge 2>> /tmp/picons.log > '$build_location'/logos/$(basename {})' \;
    done
fi

#########################################################
## Create symlinks and copy logos using only srp-index ##
#########################################################
if [[ $style = "srp-full" ]]; then
    sed '1!G;h;$!d' "$source_location/srp-index" | while read line ; do
        IFS="="
        link_srp=($line)
        logo_srp=${link_srp[1]}
        unique_id=${link_srp[0]}

        ln -s -f "logos/$logo_srp.png" "$build_location/symlinks/"'1_0_1_'"$unique_id"'_0_0_0'".png"

        cp -n "$source_location/logos/$logo_srp.*" "$build_location/logos/"
        #find "$source_location/logos/" -maxdepth 1 -type f -name "$logo_srp.*" -exec cp -n {} "$build_location/logos/" \;
        #find "$source_location/logos/" -maxdepth 1 -type f -name "$logo_srp.*" -exec sh -c 'cat {} | git lfs smudge 2>> /tmp/picons.log > '$build_location'/logos/$(basename {})' \;
    done
fi
