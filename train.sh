#!/bin/bash
#SBATCH --mem=30G
#SBATCH --time=3-0
#SBATCH -p gpu --gres=gpu:titanx:1
#SBATCH --array=1-3%1

train_path=data/ewt.aug.train
dev_path=data/ewt.aug.dev
emb_path=data/cc.en.300.vec
save_path=exp/lexical-bert/english$SLURM_ARRAY_TASK_ID
config_path=config.json
test_id_path=data/ewt.aug.test
test_ood_path=data/ewt.aug.dev

gpu=1

mkdir -p "$save_path"

python -u run.py train\
    --gpu=$gpu \
    --save_path=$save_path \
    --train_path=$train_path \
    --test_id_path=$test_id_path \
    --test_ood_path=$test_ood_path \
    --dev_path=$dev_path \
    --emb_path=$emb_path \
    --config_path=$config_path $*