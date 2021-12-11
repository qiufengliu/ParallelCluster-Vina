#创建所有文件目录
#sdf：分子库拆分成的小分子文件，sdf格式
#split_txt：小分子分组目录，即任务单元
#3D_sdf：分子的三维构象，sdf格式
#3D_mol2：分子的三维构象，mol2格式
#pdbqt: 分子的三维构象，pdbqt格式
#log: 日志
#!/bin/bash
cd /fsx
mkdir sdf 3D_mol2 3D_sdf split_txt pdbqt log

#将当前目录下的所有分子库（sdf文件）拆成单个分子，并保存至sdf目录
for f in *.sdf
 do
 echo $f
 b=`basename $f .sdf`
 sbatch -c 1 -p m5 --output /fsx/log/$f.out  --job-name Splitsdf --wrap "srun bash Prepare_sdf.sh $f $b"
done
