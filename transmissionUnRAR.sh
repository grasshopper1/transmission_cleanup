#!/bin/sh

DEST_DIR="/some/other/dir"

echo "called script for transmission dir: $TR_TORRENT_DIR" >> /var/log/posttorrent.log
echo "also seen torrent name: $TR_TORRENT_NAME" >> /var/log/posttorrent.log

#function linker() { # create simlink to downloaded files, rather than copy to final directory
#  if [ ! -d "$DEST_DIR/$1" ]; then mkdir "$DEST_DIR/$1"; fi
#  cd "$1"
#  for F in *; do
#    if [ -d "$F" ]; then linker "$1/$F"; fi
#    ln -s "$TR_TORRENT_DIR/$1/$F" "$DEST_DIR/$1"
#  done
#}

cd $TR_TORRENT_DIR
if [ -d "$TR_TORRENT_NAME" -a ! -h "$TR_TORRENT_NAME" ]
then
  if ls "$TR_TORRENT_NAME"/*.rar > /dev/null 2>&1
  then
    echo "Searching for a rar file in directory: $TR_TORRENT_NAME" >> /var/log/posttorrent.log
    find "$TR_TORRENT_NAME" -iname "*.rar" | while read file
    do
      echo "Unrarring file $file using command: 'unrar -inul \"$file\"" >> /var/log/posttorrent.log
      unrar e -inul "$file"
      chmod 777 "$file"
    done
    #transmission-remote -t$TR_TORRENT_ID --remove-and-delete &
    echo "Unrarred $TR_TORRENT_NAME" >> /var/log/posttorrent.log
  else # for multifile torrents that aren't rar'd
    echo "Unable to unrar $TR_TORRENT_NAME , trying to use linker" >> /var/log/posttorrent.log
    # cp -r "$TR_TORRENT_NAME" "$DEST_DIR"
    linker "$TR_TORRENT_NAME"
  fi
else # for single file torrents
  echo "This should not happen: --- $TR_TORRENT_NAME" >> /var/log/posttorrent.log
  # cp "$TR_TORRENT_NAME" "$DEST_DIR"
  ln -s "$TR_TORRENT_NAME" "$DEST_DIR"
fi

echo "Done executing script $0" >> /var/log/posttorrent.log

