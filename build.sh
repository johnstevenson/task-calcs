#!/bin/sh

# Creates pdf and html output in the /temp directory
# from the currently checked-out branch
# pass in "html" or "pdf" to get particular output

# Set the source document and output basename
doc=task-calcs.adoc
output_basename=task-calcs

# Set the code highlighter for pdf
highlighter_pdf=coderay

# Check if we only want html or pdf output
html=1
pdf=1

if [ $# -ne 0 ]; then

    if [ "$1" == "html" ]; then
      pdf=0
    elif [ "$1" == "pdf" ]; then
      html=0
    else
      echo "Unknown format option $output"
      exit 1
    fi
fi

dir=$(cd "${0%[/\\]*}" > /dev/null; pwd)

# Change to this root directory
cd "$dir"

# Get the current release tag
tag=$(git tag | sort -V | tail -1)
if [ -z "$tag" ]; then
    tag=0.0.0
fi

tag=$tag-dev

# Get the UTC date
revdate=$(date -u "+%Y-%m-%d %H:%M:%S")
hash=$(git log -n1 --pretty="%h" HEAD)
filename=$output_basename-$tag
revnumber=$tag.$hash

# Create build filepaths
pdf_release=output/$filename.pdf
html_release=output/$filename.html

function convert_to_pdf {

    if [ $pdf -eq 0 ]; then
      return 0
    fi

    highlighter="source-highlighter=$highlighter_pdf"

    asciidoctor-pdf -o "$pdf_release" -a "revnumber=$revnumber" -a "revdate=$revdate" -a "$highlighter" "$doc"
    if [ $? -ne 0 ]; then
        echo "asciidoctor-pdf failed"
        return 1
    fi

    return 0
}

function convert_to_html {

    if [ $html -eq 0 ]; then
      return 0
    fi

    asciidoctor -o "$html_release" -a "revnumber=$revnumber" -a "revdate=$revdate" "$doc"
    if [ $? -ne 0 ]; then
        echo "asciidoctor failed"
        return 1
    fi

    return 0
}

exit_code=1

if convert_to_pdf && convert_to_html ; then
    exit_code=0
fi

build="version: $revnumber"

if [ $exit_code -eq 0 ]; then
    echo "Built $build"

    if [ $pdf -eq 1 ]; then
      echo "   - $pdf_release"
    fi

    if [ $html -eq 1 ]; then
      echo "   - $html_release"
    fi

else
    echo "Failed to build $build"
    # Clean up any output
    if [ $pdf -eq 1 ] && [ -f $pdf_release ]; then
        unlink $pdf_release
    fi
    if [ $html -eq 1 ] && [ -f $html_release ]; then
        unlink $html_release
    fi
fi

exit $exit_code
