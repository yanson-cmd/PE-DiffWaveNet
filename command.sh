#!/usr/bin/env bash

# ---------- 1. DiffSTG baseline ----------
# Baseline 代码目录
BASELINE_DIR="week1/external_baselines/DiffSTG/DiffSTG"

# 1.1 环境及依赖（只需执行一次）
# conda create -n diffstg_env python=3.8
# conda activate diffstg_env
# pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
# pip install easydict nni numpy pandas openpyxl scikit-learn

# 1.2 数据转换
pushd "$BASELINE_DIR" || exit 1
python convert_data.py

# 1.3 运行 DiffSTG baseline
python train.py --data AIR_N95 --T_h 24 --T_p 6 --batch_size 8 --is_test False
popd || exit 1

# ---------- 2. PE-DiffWaveNet 主实验 ----------
# 主实验：seq_len=24, pre_len=6, seed=42
nohup bash -c 'DEVICE=cuda EPOCHS=120 EXP_NAME=main_benchmark_seq24_pre6_s42 bash scripts/run_train_pediffwavenet.sh 6 24 42' > week2/logs/main_benchmark_seq24_pre6_s42.log 2>&1 &

# ---------- 3. 多 seed 实验 ----------
nohup bash -c 'DEVICE=cuda EPOCHS=120 EXP_NAME=multiseed_seq24_pre6_s42 bash scripts/run_train_pediffwavenet.sh 6 24 42' > week2/logs/multiseed_s42.log 2>&1 &
nohup bash -c 'DEVICE=cuda EPOCHS=120 EXP_NAME=multiseed_seq24_pre6_s52 bash scripts/run_train_pediffwavenet.sh 6 24 52' > week2/logs/multiseed_s52.log 2>&1 &
nohup bash -c 'DEVICE=cuda EPOCHS=120 EXP_NAME=multiseed_seq24_pre6_s62 bash scripts/run_train_pediffwavenet.sh 6 24 62' > week2/logs/multiseed_s62.log 2>&1 &

# ---------- 4. 输出窗口对比实验 ----------
nohup bash -c 'DEVICE=cuda EPOCHS=120 EXP_NAME=window_seq12_pre6_s42 bash scripts/run_train_pediffwavenet.sh 6 12 42' > week2/输出窗口/seq12_pre6_s42.log 2>&1 &
nohup bash -c 'DEVICE=cuda EPOCHS=120 EXP_NAME=window_seq24_pre6_s42 bash scripts/run_train_pediffwavenet.sh 6 24 42' > week2/输出窗口/seq24_pre6_s42.log 2>&1 &
nohup bash -c 'DEVICE=cuda EPOCHS=120 EXP_NAME=window_seq48_pre6_s42 bash scripts/run_train_pediffwavenet.sh 6 48 42' > week2/输出窗口/seq48_pre6_s42.log 2>&1 &

# ---------- 5. 预测步长对比实验 ----------
nohup bash -c 'DEVICE=cuda EPOCHS=120 EXP_NAME=step_pre1_seq24_s42 bash scripts/run_train_pediffwavenet.sh 1 24 42' > week2/步长/step_pre1_seq24_s42.log 2>&1 &
nohup bash -c 'DEVICE=cuda EPOCHS=120 EXP_NAME=step_pre3_seq24_s42 bash scripts/run_train_pediffwavenet.sh 3 24 42' > week2/步长/step_pre3_seq24_s42.log 2>&1 &
nohup bash -c 'DEVICE=cuda EPOCHS=120 EXP_NAME=step_pre6_seq24_s42 bash scripts/run_train_pediffwavenet.sh 6 24 42' > week2/步长/step_pre6_seq24_s42.log 2>&1 &
nohup bash -c 'DEVICE=cuda EPOCHS=120 EXP_NAME=step_pre12_seq24_s42 bash scripts/run_train_pediffwavenet.sh 12 24 42' > week2/步长/step_pre12_seq24_s42.log 2>&1 &
nohup bash -c 'DEVICE=cuda EPOCHS=120 EXP_NAME=step_pre24_seq24_s42 bash scripts/run_train_pediffwavenet.sh 24 24 42' > week2/步长/step_pre24_seq24_s42.log 2>&1 &

# ---------- 6. 消融实验 ----------
nohup bash -c 'DEVICE=cuda EPOCHS=120 USE_DIFFUSION=0 EXP_NAME=ablation_no_diff_seq24_pre6_s42 bash scripts/run_train_pediffwavenet.sh 6 24 42' > week2/logs/ablation_no_diff.log 2>&1 &
nohup bash -c 'DEVICE=cuda EPOCHS=120 USE_PE_GRAPH=0 EXP_NAME=ablation_no_pe_graph_seq24_pre6_s42 bash scripts/run_train_pediffwavenet.sh 6 24 42' > week2/logs/ablation_no_pe_graph.log 2>&1 &
nohup bash -c 'DEVICE=cuda EPOCHS=120 USE_PE_FILM=0 EXP_NAME=ablation_no_pe_film_seq24_pre6_s42 bash scripts/run_train_pediffwavenet.sh 6 24 42' > week2/logs/ablation_no_pe_film.log 2>&1 &
nohup bash -c 'DEVICE=cuda EPOCHS=120 PE_SHUFFLE_SEED=52 EXP_NAME=ablation_pe_shuffle_seq24_pre6_s42 bash scripts/run_train_pediffwavenet.sh 6 24 42' > week2/logs/ablation_pe_shuffle.log 2>&1 &

# ---------- 7. 日志查看命令 ----------
# tail -n 100 week2/logs/main_benchmark_seq24_pre6_s42.log
# tail -f week2/输出窗口/seq12_pre6_s42.log
# tail -f week2/步长/step_pre24_seq24_s42.log
