#!/bin/bash
cwd=$(pwd)
f2c="$1" #file to convert
output="$2" #new merged filename

function mkimgs() {
    echo "Creating Images"
    echo "$f2c"
    pdftoppm -png "$f2c" images/page
}

function mkpdfs {
    cd images
    for f in *
    do
        extension=${f##*.}
        fn=${f%.*}
        if [ $extension == 'png' ]
        then
            tesseract "$f" "../pdf/$fn" pdf
        fi

    done
    cd "$cwd"
}

function mergepdfs() {
    cd pdf
    if [ ${output##*.} == "pdf" ]
    then
        filename=${output##*.}
    else
        filename="$output"
    fi

    pdfunite $(ls -v *.pdf) "$filename.pdf"
}


mkdir images
mkimgs


mkdir pdf

