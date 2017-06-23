#!/usr/bin/env sh

install_packages() {

    # get previous hash of package.json file
    PREV_HASH="$(cat .package.json.hash 2> /dev/null || echo 0)"

    # get current hash of package.json file
    CURR_HASH="$(sha1sum package.json)"

    # if content changed (hashes differ) perform update
    if [ "$CURR_HASH" != "$PREV_HASH" ]; then 
        echo "Updating packages..." 
        npm install      
        echo "$CURR_HASH" > .package.json.hash
        echo "Hash updated!"
    fi

}


# command to execute
ROLE=$1

case "$ROLE" in
  "clean" )
    rm -rf dist || true
    rm .package.json.hash 2> /dev/null || true
    ;;

  "install" )    
    # ignore first two args, first is path, second is command
    shift || shift || true
    sha1sum package.json > .package.json.hash
    exec npm install --save-dev "$@"
    ;;

  "force-install" )
    sha1sum package.json > .package.json.hash
    exec npm install
    ;;

   * )
    # before every command, check if newest packages are installed
    install_packages
    exec $@
    ;;
esac
