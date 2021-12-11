#!/bin/bash
#每$1个分子组成一个list,结果写入split_txt文件夹
find sdf | split -l $1 - /fsx/split_txt/Mol_ -d -a 6
#每一个list提交一个job.sh使用
for f in `ls /fsx/split_txt`
 do
 echo $f
 sbatch -c 16 -p spe --job-name GenerateComforation --output /fsx/log/$f.out  --wrap "srun bash Generate_3D_Conformation-Mol.sh /fsx/split_txt/$f"
done
