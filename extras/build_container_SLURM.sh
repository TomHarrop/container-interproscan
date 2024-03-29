#!/bin/bash

#SBATCH --job-name=ipr_build
#SBATCH --time=2-00
#SBATCH --ntasks=1
#SBATCH --mem=8g
#SBATCH --output=ipr_build.slurm.out
#SBATCH --error=ipr_build.slurm.err
#SBATCH --mail-type=ALL
#SBATCH --partition=io

# Dependencies
module load apptainer/1.1.5-suid

git clone https://github.com/TomHarrop/container-interproscan.git
(
    cd container-interproscan || exit 1
    git pull origin main
    cd ../ || exit 1
)

VERSION="$(cat container-interproscan/VERSION)"

# clobber the bindpath, or it causes errors
APPTAINER_BINDPATH="" \
    apptainer build \
    "interproscan_${VERSION}.sif" \
    container-interproscan/Singularity
