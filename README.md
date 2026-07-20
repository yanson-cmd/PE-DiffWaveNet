# 第1组生产实习实验仓库：PE-DiffWaveNet 空气质量预测

本目录是第1组的阶段性实验仓库，用于整理“生产实习”课程中围绕空气质量预测完成的实际实验结果、baseline 复现材料、图表产物和提交用汇总文件。

与原始 `臭氧预测资料` 材料包不同，这里不再重复介绍完整数据包结构，而是聚焦我们组已经完成的内容：

- DiffSTG baseline 跑通与结果归档；
- PE-DiffWaveNet 主实验、消融实验、多 seed 实验；
- 不同预测步长（`pre_len`）实验；
- 面向论文/汇报的表格与图像整理。

## 目录结构

```text
repository1/
  README.md
  week1/
    DiffSTG Baseline/          # baseline 说明文档
    external_baselines/        # DiffSTG 代码、副产物、日志、模型、forecast
    smoke_test/                # CPU smoke test 输出
    数据说明/                   # 第1周数据理解与补充材料
  week2/
    logs/                      # PE-DiffWaveNet 主实验与消融实验输出
    多seed/                     # seed=52,62 等多 seed 结果
    步长/                       # pre_len=1,3,12,24 等步长实验结果
    输出窗口/                   # seq_len 对比实验材料
    Baseline复现/              # baseline 汇总 CSV
    metrics/                   # DiffSTG 等指标汇总
    pre_len_vs_metrics.csv     # 不同步长汇总指标
  week3/
    README.md
    figures/                   # 论文/答辩可直接使用的图
    tables/                    # 论文/答辩可直接使用的表
```

## 我们组的实验重点

### 1. baseline 复现

本组选择 `DiffSTG` 作为扩散类时空图 baseline，并完成了：

- AIR_N95 数据格式转换；
- `seq_len=24`、`pre_len=6`、`seed=42` 主 baseline 运行；
- 模型、日志、forecast 和汇总指标归档。

相关位置：

- `week1/external_baselines/DiffSTG/DiffSTG/output/`
- `week1/DiffSTG Baseline/README.md`
- `week2/metrics/DiffSTG.csv`

当前记录的 baseline 汇总指标为：

- MAE = `18.91`
- RMSE = `23.02`
- MAPE = `301.57`

说明：DiffSTG 的最终汇总指标已经写入比较表，但逐步预测文件没有完整同步到本地，因此 `Peak_RMSE`、`Step6_RMSE` 等字段尚未补全。

### 2. PE-DiffWaveNet 主实验

主实验配置固定为：

- `seq_len=24`
- `pre_len=6`
- `seed=42`
- 使用 diffusion、PE graph、PE FiLM

主实验输出目录：

- `week2/logs/matrix_N95_PEDiffWaveNet_noleak_main_120_earlystop/`

主实验测试集结果：

- RMSE = `11.1815`
- MAE = `7.7991`
- MAPE = `31.1616`
- Peak RMSE = `13.8921`
- Step6 RMSE = `13.8372`

### 3. 消融实验

本组已完成的消融包括：

- 关闭 diffusion：`matrix_N95_PEDiffWaveNet_noleak_no_diffusion_120`
- 关闭 PE graph：`matrix_N95_PEDiffWaveNet_noleak_no_pe_120`
- 关闭 PE FiLM：`matrix_N95_PEDiffWaveNet_noleak_no_pe_film_120`
- 打乱 PE 顺序：`matrix_N95_PEDiffWaveNet_noleak_pe_shuffle_120`

这些结果集中在：

- `week2/logs/`
- `week3/tables/ablation_table.csv`
- `week3/tables/ablation_table.png`

从当前结果看：

- 关闭 diffusion 的单次结果优于当前主实验，说明 diffusion 相关设置仍有优化空间；
- 关闭 PE FiLM 后性能明显下降，说明 FiLM 组件在现有实现中贡献较大；
- 打乱 PE 后性能劣化，说明 PE 信息本身并非可随意替换。

### 4. 多 seed 实验

已补充的多 seed 结果：

- `seed=52`：`week2/多seed/matrix_N95_PEDiffWaveNet_noleak_yourgroup_seq24_pre6_s52/`
- `seed=62`：`week2/多seed/matrix_N95_PEDiffWaveNet_noleak_yourgroup_seq24_pre6_s62/`

用途：

- 评估主实验稳定性；
- 为 `week3` 中的均值 ± 标准差表格提供支撑；
- 用于论文主表和消融表中的多 seed 汇总。

### 5. 预测步长实验

本组围绕 `seq_len=24` 固定窗口，补做了不同 `pre_len` 的结果：

- `pre_len=1`
- `pre_len=3`
- `pre_len=12`
- `pre_len=24`

配合主实验 `pre_len=6`，构成完整步长趋势分析。

相关位置：

- `week2/步长/`
- `week2/pre_len_vs_metrics.csv`
- `week3/figures/pre_len_error_curves.png`

当前误差趋势为：

- `pre_len=1`：RMSE `6.1672`
- `pre_len=3`：RMSE `11.3553`
- `pre_len=6`：RMSE `11.1815`
- `pre_len=12`：RMSE `14.1533`
- `pre_len=24`：RMSE `16.7886`

整体上，预测跨度增大后误差上升，符合时序预测常见规律。

## week3 图表材料

`week3/` 中已经整理出可直接用于答辩或报告的图表材料。

### 表格

- `week3/tables/main_comparison_table.csv`
- `week3/tables/ablation_table.csv`
- `week3/tables/ppe_stratified_summary.csv`
- `week3/tables/pre_len_vs_metrics.csv`
- `week3/tables/station_error_distribution.csv`
- `week3/tables/high_value_error_analysis.csv`
- `week3/tables/true_vs_predicted_curves.csv`

### 图片

- `week3/figures/station_error_distribution.png`
- `week3/figures/high_value_error_analysis.png`
- `week3/figures/pre_len_error_curves.png`
- `week3/figures/ppe_stratified_results.png`
- `week3/figures/true_vs_predicted_curves.png`

### 当前结论

- 主模型整体性能明显优于当前 DiffSTG rerun 结果；
- 高值区误差高于全样本误差，峰值预测仍是难点；
- 高 PpE 分层节点误差更高，说明复杂站点更难预测；
- 步长增大后误差总体上升；
- 主模型已经具备形成主表、消融表、站点图和典型预测曲线的完整材料。

## 快速查看建议

如果只看最关键内容，建议按下面顺序查看：

1. `week3/tables/main_comparison_table.csv`
2. `week3/tables/ablation_table.csv`
3. `week3/figures/pre_len_error_curves.png`
4. `week3/figures/station_error_distribution.png`
5. `week3/figures/true_vs_predicted_curves.png`

## 组内结果汇总建议

当前仓库已经足以支撑组内汇报或提交初稿，建议最终统一提交时至少包含：

- 本 README；
- `week2` 中各实验输出目录；
- `week3` 中整理后的图表；
- `臭氧预测资料/臭氧预测资料/templates/experiment_result_template.csv` 中对应的实验结果表；
- 对 DiffSTG baseline 的结果说明，尤其是 MAPE 偏高与逐步指标未补齐的原因说明。

## 备注

- 本仓库是“结果整理仓库”，不是原始数据或训练代码总仓。
- 原始课程材料、数据和统一模板位于 `臭氧预测资料/臭氧预测资料/`。
- 若后续补齐 DiffSTG 的本地 forecast 文件，应同步更新主对比表中的 baseline 分步指标。