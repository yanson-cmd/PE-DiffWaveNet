import pickle
import numpy as np
import torch

# 替换为你的 pkl 文件路径
pkl_path = "output/forecast/UGnet+32+200+quad+0.1+200+ddpm+24+6+8+True+AIR_N95+0.0+True+False+0.002+8.pkl"

with open(pkl_path, 'rb') as f:
    samples, targets, observed_flag, evaluate_flag = pickle.load(f)

# 转换为 NumPy 数组（如果是 Tensor）
if isinstance(samples, torch.Tensor):
    samples = samples.numpy()
    targets = targets.numpy()

# 打印形状以便调试
print("samples.shape:", samples.shape)  # 预期 (B, n_samples, T, V, F) 或 (B, n_samples, F, V, T)
print("targets.shape:", targets.shape)  # 预期 (B, T, V, F)

# 根据实际的维度顺序调整索引
# 从 evals 函数看，samples 在保存前经过 transpose(2,4)，即 (B, n_samples, F, V, T) -> (B, n_samples, T, V, F)
# 假设现在的顺序是 (B, n_samples, T, V, F)，我们取最后 pre_len 个时间步
pre_len = 6
T_total = targets.shape[1]   # 总时间步数 = T_h + T_p
V = targets.shape[2]
F = targets.shape[3] if len(targets.shape) > 3 else 1

# 提取预测部分：最后 pre_len 个时间步
y_true = targets[:, -pre_len:, :, 0]          # (B, pre_len, V) 取特征 0（O3）
# samples 的形状： (B, n_samples, T, V, F) 或 (B, n_samples, F, V, T) 需要核对
# 我们假设 samples 形状为 (B, n_samples, T, V, F)
y_pred_all = samples[:, :, -pre_len:, :, 0]   # (B, n_samples, pre_len, V)
y_pred_mean = y_pred_all.mean(axis=1)          # (B, pre_len, V)

# 展平
y_true_flat = y_true.flatten()
y_pred_flat = y_pred_mean.flatten()

# 转换为 numpy 数组（确保是 ndarray）
if not isinstance(y_true_flat, np.ndarray):
    y_true_flat = np.array(y_true_flat)
if not isinstance(y_pred_flat, np.ndarray):
    y_pred_flat = np.array(y_pred_flat)

# 计算 MAPE
epsilon = 1e-8
mape = np.mean(np.abs((y_true_flat - y_pred_flat) / (y_true_flat + epsilon))) * 100

print(f"Test MAE: {np.mean(np.abs(y_true_flat - y_pred_flat)):.2f}")
print(f"Test RMSE: {np.sqrt(np.mean((y_true_flat - y_pred_flat) ** 2)):.2f}")
print(f"Test MAPE: {mape:.2f}%")