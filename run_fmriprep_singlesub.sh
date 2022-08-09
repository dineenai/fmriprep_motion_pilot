#!/bin/bash
#SBATCH -J fmriprep_sub-001
#SBATCH --output=/home/ainedineen/motion-robust-mri/fmriprep/sbatch_logs/slurm-%j.out
#SBATCH --error=/home/ainedineen/motion-robust-mri/fmriprep/sbatch_logs/slurm-%j.err

source /foundcog/pyenv/bin/activate

/home/ainedineen/.local/bin/fmriprep-docker -w /home/ainedineen/motion-robust-mri/fmriprep/workingdir --output-spaces MNI152NLin2009cAsym:res-2 --fs-license-file ~/motion-robust-mri/fmriprep/deriv/license.txt ~/motion-robust-mri/fmriprep/bids/ ~/motion-robust-mri/fmriprep/deriv --participant_label 001


