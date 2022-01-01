#!/bin/bash
cwd=$(pwd)

output="$1" #new merged filename

function mkimgs() {
    echo "Creating Images"
    echo "$f2c"
    pdfimages -all "$f" images/kat"$i"
    # pdftoppm -png "$f" images/kat"$i"
    echo "Image Creation Complete"
}

function size() {
    mkdir sized
    #match all sizes
    cd images
    NF="${FILENAME}x${percent}.${EXT}"
    echo "${NF}"
    convert "${f}" -resize "2480x3508"  "../sized/${f}"
    cd ..
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

function scalepdf() {
    mkdir pdfscale
    cd pdf

    for f in *.pdf
    do
    pdfposter "$f" "../pdfscale/$f"
    done
}

#2480x3508
function mergepdfs() {
    cd pdfscale
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
i=0
for f in *.pdf
do
mkimgs $f
echo $i
((i=i+1))
done
echo "Creating PDFs directory"
mkdir pdf
mkpdfs
echo "Scaling pdfs to A4"
scalepdf

echo "Creating Single PDF from individual files"
mergepdfs
