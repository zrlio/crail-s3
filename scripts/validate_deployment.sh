#!/bin/bash
parent_dir="/home/rst/WORK/PROJECTS/CRAIL/code"
source_dirs="crail spark-io crail-terasort crail-netty crail-objectstore disni darpc stocator-1.0.9 stocator-s3-1.4 spark-2.1.1-bin-without-hadoop hadoop-2.8.1"
dest_dir=/tmp/crail-deployment-jars

rm -rf $dest_dir
mkdir -p $dest_dir
for src in $source_dirs; do
    echo " --- Searching for jars in $parent_dir/$src"
    jars=`find $parent_dir/$src -name $pat*.jar`
    for j in $jars; do
        fn=$(basename $j)
        echo "$fn	$j" >> $dest_dir/all_jars
    done
done

cat $dest_dir/all_jars | sort > $dest_dir/all_jars_sorted

i=0
while read line; do
    name=$(echo $line | awk '{print $1}')
    path=$(echo $line | awk '{print $2}')
    libname=$(echo $name | sed 's/[0-9\-\.]*//g')    
    md5=$(md5sum $path) 

    if [ "$name" == "$pname" ]; then 
        if [ "$md5" != "$pmd5" ]; then
            ./compare_jar_contents.sh  $ppath $path > $dest_dir/out
            if [ "$?" != "0" ]; then
                echo "#$i -- Jar contents differences: $libname ($ppath $path). Reason:"
                cat $dest_dir/out
                i=$(($i+1))
            fi
        fi
    elif [ "$plibname" == "$libname" ]; then
        echo "#$i -- Jar version mismatch: $libname. Mismatch:"
        echo "    1. $ppath"
        echo "    2. $path"
        i=$(($i+1))
    fi
    #echo "$line -> $name $path $libname $md5"
    pname=$name
    ppath=$path
    plibname=$libname
    pline=$line
    pmd5=$md5
done < $dest_dir/all_jars_sorted

