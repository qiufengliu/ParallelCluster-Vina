#!/bin/bash
j=`basename $1 /`
mkdir /fsx/pdbqt/$j
cd /fsx/3D_mol2/$j
#并发
tempfifo=$$.fifo
trap "exec 100>&-;exec 1000<&-;exit 0" 2
mkfifo $tempfifo
exec 1000<>$tempfifo
rm -rf $tempfifo

for ((i=0;i<300;i++))
do
   echo >&1000
done

for f in ./*
 do
         read -u1000
         {
                 k=`basename $f .mol2`
                 echo $k
#使用mgltool工具将分子的mol2格式转变成pdbqt文件。 
/fsx/mgltools/mgltools_x86_64Linux2_1.5.7/bin/pythonsh /fsx/mgltools/mgltools_x86_64Linux2_1.5.7/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py -l $f -F -A hydrogens
#pdbqt文件迁移到/fsx/pdbqt目录下 
mv $k.pdbqt ../../pdbqt/$j/
 echo >&1000
 }&
 done
wait
echo $1 finish!
