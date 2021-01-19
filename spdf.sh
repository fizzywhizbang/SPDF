#!/bin/bash
cwd=$(pwd)
f2c="$1" #file to convert
output="$2" #new merged filename

function mkimgs() {
    echo "Creating Images"
    echo "$f2c"
    pdftoppm -png "$f2c" images/page
    echo "Image Creation Complete"
}

function mkpdfs {
    echo "Creating PDFs from images"
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
    echo "PDF files from images complete"
}

function mergepdfs() {
    cd pdf
    if [ ${output##*.} == "pdf" ]
    then
        filename=${output##*.}
    else
        filename="$output"
    fi

    pdfunite $(ls -v *.pdf) "../$filename.pdf"
}

echo "Creating images directory"
mkdir images
mkimgs
echo "Creating PDFs directory"
mkdir pdf
mkpdfs
echo "Creating Single PDF from individual files"
mergepdfs



