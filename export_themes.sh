#!/usr/bin/env bash

remove_hash () {
    original=$1
    echo "${original:1:6}"
}
add_slashes () {
    original=$1
    echo "${original:0:2}/${original:2:2}/${original:4:2}"
}

b16_xresources() {
    echo "#define base00 #${theme[0]}"
    echo "#define base01 #${theme[1]}"
    echo "#define base02 #${theme[2]}"
    echo "#define base03 #${theme[3]}"
    echo "#define base04 #${theme[4]}"
    echo "#define base05 #${theme[5]}"
    echo "#define base06 #${theme[6]}"
    echo "#define base07 #${theme[7]}"
    echo "#define base08 #${theme[8]}"
    echo "#define base09 #${theme[9]}"
    echo "#define base0A #${theme[10]}"
    echo "#define base0B #${theme[11]}"
    echo "#define base0C #${theme[12]}"
    echo "#define base0D #${theme[13]}"
    echo "#define base0E #${theme[14]}"
    echo "#define base0F #${theme[15]}"
    echo "*foreground:   base05"
    echo "*background:   base00"
    echo "*cursorColor:  base05"
    echo "*color0:       base03"
    echo "*color1:       base08"
    echo "*color2:       base0B"
    echo "*color3:       base0A"
    echo "*color4:       base0D"
    echo "*color5:       base0E"
    echo "*color6:       base0C"
    echo "*color7:       base05"
    echo "*color8:       base03"
    echo "*color9:       base08"
    echo "*color10:      base0B"
    echo "*color11:      base0A"
    echo "*color12:      base0D"
    echo "*color13:      base0E"
    echo "*color14:      base0C"
    echo "*color15:      base05"
}

b16_shell() {
    echo "if [ -n \"\$TMUX\" ]; then"
    echo "    put_template() { printf '\033Ptmux;\033\033]4;%d;rgb:%s\033\033\\\\\\033\\\' \$@; }"
    echo "    put_template_var() { printf '\033Ptmux;\033\033]%d;rgb:%s\033\033\\\\\\033\\\' \$@; }"
    echo "    put_template_custom() { printf '\033Ptmux;\033\033]%s%s\033\033\\\\\\033\\\' \$@; }"
    echo "elif [ \"\${TERM%%[-.]*}\" = \"screen\" ]; then"
    echo "    put_template() { printf '\033P\033]4;%d;rgb:%s\007\033\\\' \$@; }"
    echo "    put_template_var() { printf '\033P\033]%d;rgb:%s\007\033\\\' \$@; }"
    echo "    put_template_custom() { printf '\033P\033]%s%s\007\033\\\' \$@; }"
    echo "elif [ \"\${TERM%%-*}\" = \"linux\" ]; then"
    echo "    put_template() { [ \$1 -lt 16 ] && printf \"\e]P%x%s\" \$1 \$(echo \$2 | sed 's/\///g'); }"
    echo "    put_template_var() { true; }"
    echo "    put_template_custom() { true; }"
    echo "else"
    echo "    put_template() { printf '\033]4;%d;rgb:%s\033\\\' \$@; }"
    echo "    put_template_var() { printf '\033]%d;rgb:%s\033\\\' \$@; }"
    echo "    put_template_custom() { printf '\033]%s%s\033\\\' \$@; }"
    echo "fi"
    echo "put_template 0  $(add_slashes ${theme[3]})"
    echo "put_template 1  $(add_slashes ${theme[8]})"
    echo "put_template 2  $(add_slashes ${theme[11]})"
    echo "put_template 3  $(add_slashes ${theme[10]})"
    echo "put_template 4  $(add_slashes ${theme[13]})"
    echo "put_template 5  $(add_slashes ${theme[14]})"
    echo "put_template 6  $(add_slashes ${theme[12]})"
    echo "put_template 7  $(add_slashes ${theme[5]})"
    echo "put_template 8  $(add_slashes ${theme[3]})"
    echo "put_template 9  $(add_slashes ${theme[8]})"
    echo "put_template 10 $(add_slashes ${theme[11]})"
    echo "put_template 11 $(add_slashes ${theme[10]})"
    echo "put_template 12 $(add_slashes ${theme[13]})"
    echo "put_template 13 $(add_slashes ${theme[14]})"
    echo "put_template 14 $(add_slashes ${theme[12]})"
    echo "put_template 15 $(add_slashes ${theme[5]})"
    echo "put_template_var 10 $(add_slashes ${theme[5]})"
    echo "put_template_var 11 $(add_slashes ${theme[0]})"
    echo "put_template_custom 12 \";7\""
    echo "put_template 16 $(add_slashes ${theme[9]})"
    echo "put_template 17 $(add_slashes ${theme[15]})"
    echo "put_template 18 $(add_slashes ${theme[1]})"
    echo "put_template 19 $(add_slashes ${theme[2]})"
    echo "put_template 20 $(add_slashes ${theme[4]})"
    echo "put_template 21 $(add_slashes ${theme[6]})"
}

main() {
    for f in ${1}/*.yaml
    do
        n=$(echo $(basename $f) | cut -f 1 -d ".")
        theme=()
        for c in base0{0..9} base0{A..F}
        do
            theme+=($(sed -ne 's/'"${c}"': "\(.*\)".*/\1/p' $f))
        done
        b16_shell > ${out}/shell/${n}.sh &
        b16_xresources > ${out}/xresources/${n} &
    done
    wait
}

usage () {
    echo "Usage: $(basename "$0") -i path -o path"
    echo "    -i input directory path"
    echo "    -o output directory path"
    exit 1
}

while getopts "i:o:" opt
do
    case "${opt}" in
        i) in="$OPTARG" ;;
        o) out="$OPTARG" ;;
        ?) usage ;;
    esac
done
if [ -z "${in}" ] || [ -z "${out}" ]
then
    usage
fi
if [ ! -d "${in}" ]
then
    echo "directory \"${in}\" does not exist"
    exit 1;
fi
in=${in%/}

mkdir -p "${out}"/xresources
mkdir -p "${out}"/shell
main $in $out
