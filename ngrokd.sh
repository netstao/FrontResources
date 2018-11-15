#!/bin/bash
case "$1" in
start)
  echo "start ngrok service.."  
  path=~/ngrok
  $path/bin/ngrokd -tlsKey=$path/server.key -log=$path/ngrok.log -tlsCrt=$path/server.crt -domain="bs.shangqupai.com" -httpAddr=":8888" -httpsAddr=":8889" &
  ;;
*)
  echo $"Usage: $0 {start|stop|restart|status}"
  exit 1
esac