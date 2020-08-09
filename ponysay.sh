#!/bin/sh

COUNT=1
FONT=FreeMono
QUOTE=""
SIZE=44
WRAP=120

function generate () {
    local SUFFIX=${1:-""}
    if [ "x${QUOTE}" != "x" ]; then
        echo $QUOTE | ponysay --wrap $WRAP > /tmp/pony.ansi
    else
        fortune | ponysay --wrap $WRAP > /tmp/pony.ansi
    fi
    ansifilter -i /tmp/pony.ansi -o /tmp/pony.pango --pango --font=$FONT --font-size=$SIZE
    convert -background transparent -border $SIZE pango:@/tmp/pony.pango /tmp/pony.png
    cp /tmp/pony.png /out/pony${SUFFIX}.png
}

function usage () {
    echo "PonyWisdom ( https://github.com/oleyka/PonyWisdom )"
    echo "Usage: ponysay.sh [options]"
    echo "-c|--count <number>:   amount of ponies to generate (default: 1)"
    echo "-f|--font <fontname>:  use a custom font (default: FreeMono)"
    echo "-q|--quote <phrase>:   phrase for pony to say (default: unset, use fortune)"
    echo "-s|--size <number>:    specify a font size (default: 44)"
    echo "                       font sizes affect the image size and the quality of a resulting image"
    echo "                       known good values for the default font are: 14, 15, 44, 45, 46, 48"
    echo "-w|--wrap <number>:    wrap text at a certain number of characters (default: 120)"
    exit 0
}

while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -c|--count)
        COUNT="$2"; COUNT=$((COUNT=COUNT+0)); shift; shift
        ;;
        -f|--font)
        FONT="$2"; shift; shift
        ;;
        -q|--quote)
        QUOTE="$2"; shift; shift
        ;;
        -s|--size)
        SIZE="$2"; shift; shift
        ;;
        -w|--wrap)
        WRAP="$2"; shift; shift
        ;;
        -h|--help|*)
        shift;
        usage
    esac
done

if [ $COUNT -le 1 ]; then
    generate
else
    SUFFIX_LEN=${#COUNT}
    for i in $(seq 0 $COUNT); do
        PRE_SUFFIX_LEN=$(($SUFFIX_LEN - ${#i}))
        SUFFIX="$(dd if=/dev/zero bs=1 count=${PRE_SUFFIX_LEN} | tr '\0' '0')$i"
        generate $SUFFIX
    done
fi
