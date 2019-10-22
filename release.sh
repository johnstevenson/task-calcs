#!/bin/sh

# Creates pdf and html output in the /releases directory
# from either the latest tag on master or a passed-in tag
# as the first argument

# Set the source document and output basename
doc=task-calcs.adoc
output_basename=task-calcs

# Set the code highlighter for pdf
highlighter_pdf=coderay

dir=$(cd "${0%[/\\]*}" > /dev/null; pwd)

# Change to this root directory
cd "$dir"
current_branch="$(git rev-parse --abbrev-ref HEAD)"

if [ $current_branch != "master" ]; then
    echo "You must be on the master branch"
    exit 1
fi

# Check there are no changes to stage or commit
if [ ! -z "$(git status --porcelain)" ]; then
    echo "WARNING: Uncommitted changes on master branch"
fi

# See if we were passed a specific version
if [ $# -ne 0 ]; then
    tag="$1"
    if [ ! $(git tag -l "$tag") ]; then
        echo "Version tag not found"
        exit 1
    fi
else
    tag=$(git tag | sort -V | tail -1)
    if [ -z "$tag" ]; then
        echo "Version tag not found"
        exit 1
    fi
fi

# Get the date of the tag's commit
sha=$(git rev-parse $tag)
revdate=$(git log -1 --date=short --pretty=format:%cd $sha)

# Create temp and release filepaths
tmpdoc=tmp-$output_basename-$tag.adoc
pdf_release=releases/$output_basename-$tag.pdf
html_release=releases/$output_basename-$tag.html

function convert_to_pdf {

    highlighter="source-highlighter=$highlighter_pdf"

    asciidoctor-pdf -o "$pdf_release" -a "revnumber=$tag" -a "revdate=$revdate" -a "$highlighter" "$tmpdoc"
    if [ $? -ne 0 ]; then
        echo "asciidoctor-pdf failed"
        return 1
    fi

    return 0
}

function convert_to_html {

    asciidoctor -o "$html_release" -a "revnumber=$tag" -a "revdate=$revdate" "$tmpdoc"

    if [ $? -ne 0 ]; then
        echo "asciidoctor failed"
        return 1
    fi

    return 0
}

exit_code=1

# Create tmp file with contents from tag
if git show $tag:$doc > "$tmpdoc" ; then

    if convert_to_pdf && convert_to_html ; then
        exit_code=0
    fi
fi

if [ $exit_code -eq 0 ]; then
    echo "Released ${tag}"
else
    echo "Failed to release ${tag}"
    # Clean up
    if [ -f $pdf_release ]; then
        unlink $pdf_release
    fi
    if [ -f $html_release ]; then
        unlink $html_release
    fi
fi

unlink $tmpdoc
exit $exit_code
