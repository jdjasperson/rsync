#!/bin/bash

OPTIND=1
PASSED_ARGS=$@
NOT_SPECIFIED="NOT SPECIFIED"
source=$NOT_SPECIFIED

usage () {
    echo -e "Usage:\n . ./iTunes.sh -s {pc | nas}"
    echo -e "You provided:\n . ./iTunes.sh $PASSED_ARGS"
    echo -e "\n Please correct your usage!"
    return 1
}

if [ ! -d "/Volumes/Jasperson_Music_Library" ]; then
    echo "NAS cannot be located!"
    return
else
    echo -e "NAS has been located."
fi

# debug echo "Passed Arguments = ${PASSED_ARGS}"
if [[ ${#PASSED_ARGS} -ne 0 ]]
then
    # debug echo "Entering option parsing..."
    while getopts "s:" options; do
        #debug echo "Parsing the $options flag."
        case "${options}" in
            s)  source=${OPTARG}
                if [ "$source" != "nas" -a "$source" != "pc" ]; then
                    echo -e "Source is not valid."
                    usage
                fi
                # debug echo -e "Source is: $source"
                ;;
        esac
    done
    # debug echo "Parsing completed."
else
    usage
fi

case "$source" in
    nas)
        echo "Synchronizing music library from NAS to PC"
        rsync -auv --info=progress2 --ignore-existing --group --times --out-format="%t" --omit-dir-times --no-perms --prune-empty-dirs --exclude-from 'music-excludes.txt' /Volumes/Jasperson_Music_Library/ /Users/jerry.jasperson/Music/Music
        ;;
    pc)
        echo "Synchronizing music library from PC to NAS"
        rsync -auv --info=progress2 --ignore-existing --group --times --out-format="%t" --omit-dir-times --no-perms --prune-empty-dirs --exclude-from 'music-excludes.txt' /Users/jerry.jasperson/Music/Music/ /Volumes/Jasperson_Music_Library
        ;;
esac

#echo "Synchronizing movie library from Mac to NAS"
#rsync --update -raucv --omit-dir-times --progress --ignore-existing --prune-empty-dirs --delay-updates --times --exclude-from 'movie-excludes.txt' /Users/jerry.jasperson/Music/iTunes/iTunes\ Media/Movies/ /Volumes/public/media/Movies
