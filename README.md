# VLA-training (Reproducible)

本仓库用于 **Vision-Language-Action (VLA) 模型训练**。  
代码基于 openpi，但已针对 **本仓库的实际训练流程** 做了工程化封装与环境补丁。

**本 README 仅描述如何复现本仓库的训练流程**，不依赖 openpi 官方文档。

---

## 1. 仓库结构

```text
VLA-training/
├── scripts/                # 训练 / 数据处理 / 运行入口（主要使用）
├── src/                    # openpi 源码（可能包含行为修改）
├── sitecustomize.py        # Python 启动时自动加载的环境补丁
├── constraints_openpi.txt  # 依赖版本约束（保证可复现）
├── pyproject.toml          # 项目定义
├── data/                   # 数据目录（需自行准备）
├── packages/               # openpi 相关子包
├── utils/                  # 工具函数
└── README.md
2. 环境要求
OS：Linux（推荐）或 Windows

Python：3.11（由 .python-version 指定）

GPU：NVIDIA GPU（训练需要）

CUDA / Driver：确保 nvidia-smi 可用

检查示例：

python --version
nvidia-smi
3. 获取代码
git clone --recursive https://github.com/Jerryzhang258/VLA-training.git
cd VLA-training
如果仅复现代码逻辑，不需要 Git LFS 下载大文件。

4. 安装依赖
使用 uv（推荐）
uv sync
uv pip install -e . -c constraints_openpi.txt
说明：

-e . 使用本地源码

constraints_openpi.txt 用于锁定依赖版本，避免环境漂移

备用方式（venv + pip）
python -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
pip install -e . -c constraints_openpi.txt
5. 数据准备
本仓库 不包含数据。
请自行准备数据并放置在 data/ 目录。

推荐结构（示例）：

data/
└── dataset_name/
    ├── episode_000/
    │   ├── images/
    │   ├── actions.npy
    │   ├── states.npy
    │   └── language.txt
    ├── episode_001/
    └── ...
实际字段以 scripts/ 中的数据读取逻辑为准。

6. 重要说明：sitecustomize.py
本仓库通过 sitecustomize.py 对 Python 运行环境进行补丁处理，用于：

离线 / 受限网络环境兼容

import 路径修复

第三方依赖兼容性处理

注意：

无需手动 import

在 repo 根目录运行 Python 时会自动生效

不要删除该文件

7. 训练入口（核心）
所有训练相关入口位于：

scripts/
请选择一个脚本作为训练入口，例如：

python scripts/train.py --config <CONFIG_NAME>
常见参数（以脚本内定义为准）：

--config：训练配置名称

--data_root：数据路径

--output_dir：模型输出路径

--batch_size

--epochs

示例：

python scripts/train.py \
  --config default \
  --data_root data \
  --output_dir checkpoints \
  --batch_size 4
8. 一键复现（可选）
Linux / macOS
./reproduce.sh
Windows (PowerShell)
.\reproduce.ps1
9. 训练输出
日志：打印至终端

模型权重：保存于 checkpoints/

若脚本支持，可从已有 checkpoint 恢复训练

