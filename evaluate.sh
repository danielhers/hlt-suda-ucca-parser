#!/bin/bash
#SBATCH --mem=30G
#SBATCH --time=0-1
#SBATCH -p gpu --gres=gpu:titanx:1

gold_path=data/ewt.aug.test
save_path=exp/lexical/english/

gpu=2
python -u run.py evaluate\
    --gpu=$gpu \
    --gold_path=$gold_path \
    --save_path=$save_path
