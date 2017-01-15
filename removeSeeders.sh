#!/bin/sh
TORRENTLIST=`transmission-remote --list | sed -e '1d;$d;s/^ *//' | cut -s -w -f 1`

for TORRENTID in $TORRENTLIST
do
        # echo "* * * * * Operations on torrent ID $TORRENTID starting. * * * * *"

        DL_COMPLETED=`transmission-remote --torrent $TORRENTID --info | grep "State: Finished"`
        if [ "$DL_COMPLETED" != "" ]; then
                echo "Torrent #$TORRENTID is completed."
                echo "Removing torrent from list."
                transmission-remote --torrent $TORRENTID --remove-and-delete
        # else
                # echo "Torrent #$TORRENTID is not completed. Ignoring."
        fi
        # echo "* * * * * Operations on torrent ID $TORRENTID completed. * * * * *"
done

