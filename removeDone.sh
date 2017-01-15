#!/bin/sh
TORRENTLIST=`transmission-remote --list | sed -e '1d;$d;s/^ *//' | cut -s -w -f 1`

for TORRENTID in $TORRENTLIST
do
        # echo "* * * * * Operations on torrent ID $TORRENTID starting. * * * * *"

        DL_COMPLETED=`transmission-remote --torrent $TORRENTID --info | grep "Percent Done: 100%"`
        #DL_IDLE=`transmission-remote --torrent $TORRENTID --info | grep "State: Idle"`
        TORRENTLEECH=`transmission-remote --torrent $TORRENTID --info | grep "torrentleech"`
        if [ "$DL_COMPLETED" != "" ] && [ "$TORRENTLEECH" == "" ]; then
                echo "Torrent #$TORRENTID is done and not torrentleech tracker."
                echo "Removing torrent from list."
                transmission-remote --torrent $TORRENTID --remove-and-delete
        # else
                # echo "Torrent #$TORRENTID is not completed. Ignoring."
        fi
        # echo "* * * * * Operations on torrent ID $TORRENTID completed. * * * * *"
done

