k=`basename $1 /`
mkdir /fsx/3D_sdf/$k /fsx/3D_mol2/$k

#并发设置
tempfifo=$$.fifo
trap "exec 100>&-;exec 1000<&-;exit 0" 2
mkfifo $tempfifo
exec 1000<>$tempfifo
rm -rf $tempfifo

for ((i=0;i<100;i++))
do
   echo >&1000
done

#分子三维构想生成
for f in `cat $1`
 do
         read -u1000
         {
                 b=`basename $f .sdf`
                 echo $f
                 echo $b
                 echo Processing ligand $f $b
                 #生成三维构象，sdf格式，保存在3D_sdf目录下
                 /fsx/openbabel/bin/obabel /fsx/sdf/$b.sdf -O /fsx/3D_sdf/$k/$b.sdf --confab --rcutoff 1
                 #将每一个分子生成的多个三维构象，逐一转化为mol2格式，保存在3D_mol2目录下
                 /fsx/openbabel/bin/obabel -isdf /fsx/3D_sdf/$k/$b.sdf -omol2 -O /fsx/3D_mol2/$k/$b-.mol2 -p 7.4 --append ID -m
                 echo >&1000
 }&
 done
wait
echo $k finish!
