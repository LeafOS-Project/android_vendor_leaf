#!/bin/bash

function fetch_list() {
    curl --silent "$2" | sed -E "$3" | sed -E "/^#/d; /^$/d" | sed -E "/([[:space:]])?localhost$/d" > "$1"
}

SRC="$(dirname $0)"

fetch_list "$SRC"/adaway.list "https://adaway.org/hosts.txt"
fetch_list "$SRC/"adguard.list "https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardDNS.txt" "s/0\.0\.0\.0/127.0.0.1/g"
fetch_list "$SRC"/disconnect.list "https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt" "/^Malvertising list by Disconnect$/d; /^$/d; s/^([^#]*)$/127.0.0.1 \1/g"
fetch_list "$SRC"/yoyo.list "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts;showintro=0&mimetype=plaintext"

cat "$SRC"/*.list | sort | uniq > "$SRC"/hosts.adblock.in
rm "$SRC"/*.list
