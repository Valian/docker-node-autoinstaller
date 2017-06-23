#!/usr/bin/env sh

install_packages() {
    # get previous hash of package.json file
    PREV_HASH="$(cat "$PROJECT_PATH/.package.json.hash" 2> /dev/null || echo 0)"

    # get current hash of package.json file
    CURR_HASH="$(sha1sum "$PROJECT_PATH/package.json")"

    echo "Current hash '$CURR_HASH'"
    echo "Prev hash    '$PREV_HASH'"

    # if content changed (hashes differ) perform update
    if [ "$CURR_HASH" != "$PREV_HASH" ]; then 
        echo "Updating packages..." 
        npm install --prefix "$PROJECT_PATH"
    fi
    echo "$CURR_HASH" > "$PROJECT_PATH/.package.json.hash"
    echo "Hash updated!"
}


# command to execute
ROLE=$1

case "$ROLE" in
  "clean" )
    rm -rf dist || true
    ;;

  "install" )    
    # ignore first two commands, first is path, second is command
    shift || shift || true
    sha1sum package.json > "$PROJECT_PATH/.package.json.hash"
    exec npm install --prefix "$PROJECT_PATH" --save-dev "$@"
    ;;

  "force-install" )
    sha1sum package.json > "$PROJECT_PATH/.package.json.hash"
    exec npm install --prefix "$PROJECT_PATH"
    ;;

   * )
    # before every command, check if newest packages are installed
    install_packages
    exec $ROLE $@
    ;;
esac
