#!/bin/sh

top_dir=/Users/rst/WORK/PROJECTS/CRAIL/code-apache-git/incubator-crail/deployment
if [ $# -ge 1 ]; then
    top_dir=$1
fi
echo "Searching for mismatched jar versions in $top_dir..."
rm -rf /tmp/sorted_jars.txt /tmp/jars.txt
files=$(find $top_dir -name '*.jar')
for f in $files; do
    #echo $f
    echo ${f##*/} $(md5sum $f) >> /tmp/jars.txt
done
cat /tmp/jars.txt | sort > /tmp/sorted_jars.txt
i=0
while read line; do
    name=$(echo $line | awk '{print $1}')
    md5=$(echo $line | awk '{print $2}')
    path=$(echo $line | awk '{print $3}')
    name=$(echo $name | sed 's/[0-9\-\.]*//g')
    if [ "$name" == "$pname" ] && [ "$md5" != "$pmd5" ] ; then
        i=$(($i+1))
        echo "#$i. Potential jar version mismatch:"
        echo "   1. $pline"
        echo "   2. $line"
    fi
    pname=$name
    pmd5=$md5
    ppath=$path
    pline=$line
done < /tmp/sorted_jars.txt
