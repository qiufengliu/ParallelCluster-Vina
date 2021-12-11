#!/bin/bash
#docking日志
mkdir /fsx/docking_log/
#docking结果
mkdir /fsx/docking_result/
#docking分数
mkdir /fsx/docking_scores/

for f in `ls /fsx/pdbqt`
 do
#pdbqt中每一个文件夹一个job
 sbatch -c 16 -p spe --job-name docking --output /fsx/log/$f-docking.out  --wrap "srun bash docking.sh $1 $2 /fsx/pdbqt/$f"
done
