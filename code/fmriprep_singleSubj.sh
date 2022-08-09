#!/bin/bash
#SBATCH -J fmriprep_sub-001
#SBATCH --output=/home/ainedineen/motion-robust-mri/fmriprep/sbatch_logs/slurm-%j.out
#SBATCH --error=/home/ainedineen/motion-robust-mri/fmriprep/sbatch_logs/slurm-%j.err

#Template provided by Daniel Levitas of Indiana University
#Edits by Andrew Jahn, University of Michigan, 07.22.2020

# SOURCE: https://github.com/andrewjahn/OpenScience_Scripts/blob/master/fmriprep_singleSubj.sh
#Modified by for use by Cusack Lab 8/5/22

# Replace all instances of $HOME with ~/motion-robust-mri/fmriprep/
# Replace: $HOME/Desktop/Flanker with ~/motion-robust-mri/fmriprep/bids/
# if ~ fails use /home/ainedineen

#User inputs:
bids_root_dir=~/motion-robust-mri/fmriprep/bids/
subj=001 
nthreads=4
mem=20 #gb
container=docker #docker or singularity

source /foundcog/pyenv/bin/activate

#Begin:

#Convert virtual memory from gb to mb
mem=`echo "${mem//[!0-9]/}"` #remove gb at end
mem_mb=`echo $(((mem*1000)-5000))` #reduce some memory for buffer space during pre-processing

#export TEMPLATEFLOW_HOME=$HOME/.cache/templateflow
# export FS_LICENSE=$HOME/Desktop/Flanker/derivatives/license.txt
export FS_LICENSE=~/motion-robust-mri/fmriprep/bids/derivatives/license.txt



#Run fmriprep
if [ $container == singularity ]; then
  unset PYTHONPATH; singularity run -B ~/motion-robust-mri/fmriprep/.cache/templateflow:/opt/templateflow ~/motion-robust-mri/fmriprep/fmriprep.simg \
    $bids_root_dir $bids_root_dir/derivatives \
    participant \
    --participant-label $subj \
    --skip-bids-validation \
    --md-only-boilerplate \
    --fs-license-file ~/motion-robust-mri/fmriprep/bids/derivatives/license.txt \
    --fs-no-reconall \
    --output-spaces MNI152NLin2009cAsym:res-2 \
    --nthreads $nthreads \
    --stop-on-first-crash \
    --mem_mb $mem_mb \
else
  # fmriprep-docker $bids_root_dir $bids_root_dir/derivatives \
  /home/ainedineen/.local/bin/fmriprep-docker $bids_root_dir $bids_root_dir/derivatives \
    participant \
    --participant-label $subj \
    --skip-bids-validation \
    --md-only-boilerplate \
    --fs-license-file ~/motion-robust-mri/fmriprep/bids/derivatives/license.txt \
    --fs-no-reconall \
    --output-spaces MNI152NLin2009cAsym:res-2 \
    --nthreads $nthreads \
    --stop-on-first-crash \
    --mem_mb $mem_mb
fi