#!/bin/bash
#SBATCH --mem=30G
#SBATCH --time=0-1
#SBATCH -p gpu --gres=gpu:titanx:1
#SBATCH --array=1-3

test_path=data/ewt.aug.dev
save_path=exp/lexical-bert/english$SLURM_ARRAY_TASK_ID
pred_path=$save_path/ewt.aug.dev

gpu=2
python -u run.py predict\
    --gpu=$gpu \
    --test_path=$test_path \
    --pred_path=$pred_path \
    --save_path=$save_path
