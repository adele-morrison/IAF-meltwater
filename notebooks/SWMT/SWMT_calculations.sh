#!/bin/bash
#PBS -l ncpus=96
#PBS -l mem=1400GB
#PBS -q hugemem
#PBS -l walltime=3:00:00
#PBS -l storage="gdata/hh5+gdata/ik11+gdata/v45+gdata/e14+gdata/cj50+scratch/v45+scratch/x77"
#PBS -l wd
#PBS -o SWMT_calculations.out
#PBS -j oe

# Run this script with 'qsub SWMT_calculations.sh'

# load conda
module use /g/data/hh5/public/modules
module load conda/analysis3
module load nci-parallel/1.0.0
export ncores_per_task=12
export ncores_per_numanode=12

for y in {1979..2018}; do
    echo python3 SWMT_calculations.py -y $y >> SWMT_calculations.txt
done


mpirun -np $((PBS_NCPUS/ncores_per_task)) --map-by ppr:$((ncores_per_numanode/ncores_per_task)):NUMA:PE=${ncores_per_task} nci-parallel --input-file SWMT_calculations.txt --timeout 4000
