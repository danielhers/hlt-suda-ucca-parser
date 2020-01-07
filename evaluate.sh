#!/bin/bash
#SBATCH --mem=30G
#SBATCH --time=0-1
#SBATCH -p gpu --gres=gpu:titanx:1
#SBATCH --array=1-3

gold_path=data/ewt.aug.test
save_path=exp/lexical-bert/english$SLURM_ARRAY_TASK_ID

gpu=2
python -u run.py evaluate\
    --gpu=$gpu \
    --gold_path=$gold_path \
    --save_path=$save_path
