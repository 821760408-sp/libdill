#!/bin/sh

echo ">>> Cleaning up old man pages."
git rm -f man/*.html
mkdir -p man

echo ">>> Getting the man page source files from the libdill repo."
git clone git@github.com:sustrik/libdill.git libdill-tmp
cd libdill-tmp
git checkout $1 --quiet
cd ..
cp libdill-tmp/man/*.md man
rm -rf libdill-tmp

echo ">>> Building manpages."
echo "" > manpage-index.md
for f in man/*.md
do
    # Manpage name.
    name=$(basename "$f")
    name="${name%.*}"
    # Build HTML version of manpage.
    pandoc -f markdown_github $f > $f.tmp
    cat templates/header.html $f.tmp templates/footer.html > man/$name.html
    rm $f $f.tmp
    git add man/$name.html
    # Add manpage to the index.
    echo "* [$name](http://libdill.org/man/$name.html)" >> manpage-index.md
done

echo ">>> Building documenentation.md"
cat templates/documentation-header.md manpage-index.md templates/documentation-footer.md > documentation.md
rm manpage-index.md

git rm -f *.html
other="\
    build_options \
    compatibility \
    documentation \
    download \
    index \
    libdill-history \
    structured-concurrency \
    threads \
    tutorial \
    tutorial-basics \
    tutorial-protocol\
    tutorial-sockets"
for f in $other
do
    echo ">>> Building $f.md"
    pandoc -f markdown_github $f.md > $f.tmp
    cat templates/header.html $f.tmp templates/footer.html > $f.html
    rm $f.tmp
    git add $f.html
done

rm documentation.md

