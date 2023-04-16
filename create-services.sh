#!/bin/bash

SERV_SKEL="rsnapshot.service.skel"
TIME_SKEL="rsnapshot@.timer.skel"
IFS=','

function make_service_files() {
    local before
    local config
    local fname
    local -n intervals=$2
    local name
    if [[ -n "$1" ]]; then
        name="-$1"
        config="-c /etc/rsnapshot-$1.conf "
    fi

    before=""
    for i in "${intervals[@]}"; do
        fname="rsnapshot$name-$i.service"
        cp -v "$SERV_SKEL" "$fname"
        sed -i "s/{NAME}/$name/g" "$fname"
        sed -i "s|{CONFIG}|$config|g" "$fname"
        sed -i "s/{INTERVAL}/$i/g" "$fname"
        if [[ "$i" = "${intervals[0]}" ]]; then
            sed -i '/Requires/d' "$fname"
            sed -i '/After/d' "$fname"
        else
            sed -i "s/{BEFORE}/$before/g" "$fname"
        fi
        before="$i"
    done
}

function make_timer_file() {
    local fname
    fname="rsnapshot@.timer"
    if [[ -n "$1" ]]; then
        fname="rsnapshot-$1@.timer"
    fi
    cp -v "$TIME_SKEL" "$fname"
    sed -i "s/{NAME}/$name/g" "$fname"
}

function main() {
    local -a intervals_arr
    local intervals_str
    local name
    while read -r line; do
      case "$line" in
        \#*) continue ;;  # Skip comments
        *=*)
          name="${line%=*}"
          if [[ "$name" = "default" ]]; then
              unset name
          fi
          intervals_str="${line#*=}"
          read -ra intervals_arr <<< "$intervals_str"
          make_service_files "$name" intervals_arr
          make_timer_file "$name"
          ;;
      esac
    done < services.sh
}

main
