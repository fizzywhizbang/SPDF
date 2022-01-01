#!/bin/bash
#this is for mac/linux have not tried on winderz
#must install poppler and tesseract

CWD=$(pwd)
DIRNAME=${CWD##*/}

output="$DIRNAME"


function mkpdfs {
    echo "Creating PDFs from images"
    
    for f in *
    do
        extension=${f##*.}
        fn=${f%.*}
        if [ $extension == 'jpg' ]
        then
            tesseract "$f" "pdf/$fn" pdf
        fi

    done
    
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

echo "Creating PDFs directory"
mkdir pdf
echo "Creating PDFs"
mkpdfs
echo "Creating Single PDF from individual files"
mergepdfs