#!/bin/bash

j=`basename $3 /`
echo $j

#创建结果文件夹
mkdir /fsx/docking_result/$j
mkdir /fsx/docking_scores/$j

tempfifo=$$.fifo
trap "exec 100>&-;exec 1000<&-;exit 0" 2
mkfifo $tempfifo
exec 1000<>$tempfifo
rm -rf $tempfifo

for ((i=0;i<5;i++))
do
   echo >&1000
done

for f in `ls /fsx/pdbqt/$j`
 do
         read -u1000
         {
         echo $f
         m=`basename $f /`
         echo $m
         #执行对接
         /fsx/vina --config $1 --ligand /fsx/pdbqt/$j/$m --out /fsx/docking_result/$j/$m-docked.pdbqt --receptor $2  --exhaustiveness 24
         echo >&1000
 }&
 done

wait

#整合结果保存至/fsx/docking_scores/$j-sum.txt
grep "VINA RESULT" /fsx/docking_result/$j/*.pdbqt| sort -k4 -r | sed -e 's/:REMARK VINA RESULT://g' > /fsx/docking_scores/$j-sum.txt
