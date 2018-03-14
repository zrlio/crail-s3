#!/bin/bash

hash1=$(md5sum $1)
hash2=$(md5sum $2)

if [ "$hash1" == "$hash2" ] ; then
	exit 0
fi

d1=/tmp/jar-cmp-1
d2=/tmp/jar-cmp-2

rm -rf $d1 $d2
mkdir -p $d1 $d2

pushd $d1 > /dev/null && jar xf $1 
popd > /dev/null

pushd $d2 > /dev/null && jar xf $2
popd > /dev/null

diff -r $d1 $d2
ret=$?

rm -rf $d1 $d2

exit $ret
