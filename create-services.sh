#!/bin/bash

SKEL="rsnapshot.service.skel"

intervals=(
    hourly
    daily
    weekly
    monthly
)

if [[ -n "$1" ]]; then
    name="$1-"
    config="-c /etc/rsnapshot-$1.conf"
fi

before=""
for i in "${intervals[@]}"; do
    fname="rsnapshot-$name$i.service"
    cp -v "$SKEL" "$fname"
    sed -i "s/{NAME}/$name/g" "$fname"
    sed -i "s/{CONFIG}/$config/g" "$fname"
    sed -i "s/{INTERVAL}/$i/g" "$fname"
    if [[ "$i" = "${intervals[0]}" ]]; then
        sed -i '/Requires/d' "$fname"
        sed -i '/After/d' "$fname"
    else
        sed -i "s/{BEFORE}/$before/g" "$fname"
    fi
    before="$i"
done
