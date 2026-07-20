### Week 2: DiffSTG Baseline 实验

## 实验目标

完成 DiffSTG 最低要求：

1. 用本项目 AIR_N95 数据跑通 DiffSTG
2. 跑 seq_len=24, pre_len=6, seed=42 作为主 baseline
3. 输出 RMSE、MAE、MAPE
4. 填入 experiment_result_template.csv

## 与 PE-DiffWaveNet 的关系

- PE-DiffWaveNet: 面向空气质量复杂性、PE 特征增强的扩散预测模型（我们的主模型）
- DiffSTG: 通用概率时空图扩散预测模型（对比 baseline）

## 运行命令

1.环境准备：

创建并激活 conda 环境
conda create -n diffstg_env python=3.8
conda activate diffstg_env

安装 PyTorch（CPU 版本）
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

安装其他依赖
pip install easydict nni numpy pandas openpyxl scikit-learn

2.数据转换
python convert_data.py

3.训练与评估（debug模式）
python train.py --data AIR_N95 --T_h 24 --T_p 6 --batch_size 8

## 实验结果
# 训练过程验证集指标
Epoch	Train Loss	Val MAE (Future)	Val RMSE (Future)	Val MAE (History)	Val RMSE (History)	验证耗时
0	12.454	1095.93	1859.23	1087.63	1859.22	821.56s
1	10.193	1058.93	1793.40	1013.68	1749.60	1046.15s

# 测试集最终指标
指标	值	说明
MAE	160.62	平均绝对误差，主要评估指标
RMSE	190.25	均方根误差，主要评估指标
MAPE	1395.87%	平均绝对百分比误差，异常偏高，仅供参考

## MAPE异常说明
MAPE 高达 1395.87% 是由于 O₃ 浓度序列中存在大量接近 0 的真实值（如夜间或清洁时段），导致 MAPE 计算公式中分母趋近 0 时，单个数据点的百分比误差爆炸式增长。这是 MAPE 指标在空气质量预测任务中的已知缺陷。因此，本报告以 MAE 和 RMSE 作为主要评估指标，MAPE 仅作为参考项并注明其局限性。如需更鲁棒的百分比误差指标，可改用 sMAPE 或设定阈值忽略真实值小于 5 μg/m³ 的样本。

## 附件清单
数据转换脚本：PE-DiffWaveNet\week1\external_baselines\DiffSTG\DiffSTG\convert_data.py
训练日志文件：PE-DiffWaveNet\week1\external_baselines\DiffSTG\DiffSTG\output\log
测试集预测结果：PE-DiffWaveNet\week1\external_baselines\DiffSTG\DiffSTG\output\forecast
最佳模型权重：PE-DiffWaveNet\week1\external_baselines\DiffSTG\DiffSTG\output\model
