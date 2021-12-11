#!/bin/bash
for f in `ls /fsx/split_txt`
 do
 echo $f
 sbatch -c 16 -p spe --job-name GeneratePDBQT --output /fsx/log/$f-pdbqt.out  --wrap "srun bash Generate_pdbqt.sh /fsx/split_txt/$f"
done
