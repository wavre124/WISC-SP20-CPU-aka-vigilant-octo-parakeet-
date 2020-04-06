#!/bin/sh

dname=`pwd`;
echo "Using directory $dname";
echo "Vcheckout output files in .vcheck.out";

for a in *.v; do
    echo "Checking file $a";
    outfile=`basename $a .v`".vcheck.out";
    /u/s/i/sinclair/courses/cs552/spring2020/handouts/bins/vcheck.sh $a $outfile;
done
