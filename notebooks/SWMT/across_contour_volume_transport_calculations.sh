#!/bin/bash
#PBS -l ncpus=96
#PBS -l mem=1400GB
#PBS -q hugemem
#PBS -l walltime=12:00:00
#PBS -l storage="gdata/hh5+gdata/ik11+gdata/v45+gdata/e14+gdata/cj50+scratch/v45+scratch/x77"
#PBS -l wd
#PBS -o across_contour_volume_transport_calculations.out
#PBS -j oe

# load conda
module use /g/data/hh5/public/modules
module load conda/analysis3
module load nci-parallel/1.0.0
export ncores_per_task=1
export ncores_per_numanode=12

# run this with qsub across_contour_volume_transport_calculations.sh

for y in {1992..2018}; do
    if (( $y % 4 == 0 ))
    then
        for t in {0..365}; do
            echo python3 across_contour_volume_transport_calculations.py -y $y -t $t >> across_contour_volume_transport_calculations.txt
        done
    else
        for t in {0..364}; do
            echo python3 across_contour_volume_transport_calculations.py -y $y -t $t >> across_contour_volume_transport_calculations.txt
        done
    fi
done
 
mpirun -np $((PBS_NCPUS/ncores_per_task)) --map-by ppr:$((ncores_per_numanode/ncores_per_task)):NUMA:PE=${ncores_per_task} nci-parallel --input-file across_contour_volume_transport_calculations.txt --timeout 4000
