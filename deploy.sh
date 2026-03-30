rm -rf build
git clone git@github.com:davidsiaw/rcalc doc
cd doc
git checkout gh-pages
cd ..
mv doc/.git gitbak
rm -rf doc
sleep 2
bundle exec yard
mv gitbak doc/.git
cd doc
echo rcalc.davidsiaw.net > CNAME
git add .
git commit -m "update"
git push
cd ..
