#!/bin/bash
#SBATCH --mem=30G
#SBATCH --time=0-1
#SBATCH -p gpu --gres=gpu:titanx:1

test_path=data/ewt.aug.test
save_path=exp/lexical-bert/english
pred_path=$save_path/ewt.aug.test

gpu=2
python -u run.py predict\
    --gpu=$gpu \
    --test_path=$test_path \
    --pred_path=$pred_path \
    --save_path=$save_path
