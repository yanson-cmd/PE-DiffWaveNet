import numpy as np
import pandas as pd
from scipy.spatial.distance import cdist
import os

# ========== 修改这里的路径 ==========
BASE_DIR = r"D:/diffSTG/臭氧预测资料"               # 实习资料根目录
MATRIX_DIR = os.path.join(BASE_DIR, "matrix_N95")
STATION_FILE = os.path.join(BASE_DIR, "xlsx_N95/station_loc1.xlsx")
OUTPUT_DIR = "./data/dataset/AIR_N95"              # DiffSTG 数据存放位置
# ===================================

os.makedirs(OUTPUT_DIR, exist_ok=True)

# 读取 O3 数据 (95, 8717) -> (8717, 95, 1)
data_npy = np.load(os.path.join(MATRIX_DIR, "data.npy"))
flow = data_npy.T  # (8717, 95)
flow = flow[:, :, np.newaxis]  # (8717, 95, 1)
print("flow shape:", flow.shape)

# 构建邻接矩阵（基于经纬度距离）
station_df = pd.read_excel(STATION_FILE)
# 请确认列名：可能是 '纬度'/'经度'，如果不是请修改
lats = station_df['纬度'].values
lons = station_df['经度'].values
coords = np.column_stack((lats, lons))

dist = cdist(coords, coords, metric='euclidean')
threshold = 0.5  # 可根据需要调整
adj = (dist < threshold).astype(np.float32)
np.fill_diagonal(adj, 0)
print("adj shape:", adj.shape, "平均连接数:", adj.sum(axis=1).mean())

np.save(os.path.join(OUTPUT_DIR, "flow.npy"), flow)
np.save(os.path.join(OUTPUT_DIR, "adj.npy"), adj)
print("数据保存至:", OUTPUT_DIR)