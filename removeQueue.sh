#!/bin/sh
TORRENTLIST=`transmission-remote --list | sed -e '1d;$d;s/^ *//' | cut -s -w -f 1`

for TORRENTID in $TORRENTLIST
do
        # echo "* * * * * Operations on torrent ID $TORRENTID starting. * * * * *"

        DL_QUEUED=`transmission-remote --torrent $TORRENTID --info | grep "State: Queued"`
        if [ "$DL_QUEUED" != "" ]; then
                echo "Torrent #$TORRENTID is queued."
                echo "Removing torrent from list."
                transmission-remote --torrent $TORRENTID --remove-and-delete
        # else
                # echo "Torrent #$TORRENTID is not completed. Ignoring."
        fi
        sleep 2
        # echo "* * * * * Operations on torrent ID $TORRENTID completed. * * * * *"
done
