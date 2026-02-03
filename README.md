✅ 1) reproduce.sh（Linux / macOS / 服务器）

放在仓库根目录：VLA-training/reproduce.sh

#!/usr/bin/env bash
set -e

echo "[VLA] Reproduce script start"

# ---- 基本检查 ----
if ! command -v python >/dev/null 2>&1; then
  echo "Python not found"
  exit 1
fi

python --version

# ---- 可选：离线缓存（按需修改）----
# export HF_HOME=/path/to/cache
# export TRANSFORMERS_CACHE=/path/to/cache

# ---- 安装依赖 ----
if command -v uv >/dev/null 2>&1; then
  echo "[VLA] Using uv"
  uv sync
  uv pip install -e . -c constraints_openpi.txt
else
  echo "[VLA] Using venv + pip"
  python -m venv .venv
  source .venv/bin/activate
  pip install -U pip
  pip install -e . -c constraints_openpi.txt
fi

# ---- 运行训练（按你的脚本实际参数改）----
# 示例入口，如需改 config 名称直接改这里
python scripts/train.py \
  --config default \
  --data_root data \
  --output_dir checkpoints

echo "[VLA] Reproduce script done"


赋权并运行：

chmod +x reproduce.sh
./reproduce.sh

✅ 2) reproduce.ps1（Windows / PowerShell）

放在仓库根目录：VLA-training/reproduce.ps1

Write-Host "[VLA] Reproduce script start"

# ---- 基本检查 ----
python --version
if ($LASTEXITCODE -ne 0) {
  Write-Error "Python not found"
  exit 1
}

# ---- 可选：离线缓存（按需修改）----
# $env:HF_HOME="C:\path\to\cache"
# $env:TRANSFORMERS_CACHE="C:\path\to\cache"

# ---- 安装依赖 ----
if (Get-Command uv -ErrorAction SilentlyContinue) {
  Write-Host "[VLA] Using uv"
  uv sync
  uv pip install -e . -c constraints_openpi.txt
} else {
  Write-Host "[VLA] Using venv + pip"
  python -m venv .venv
  .\.venv\Scripts\Activate.ps1
  pip install -U pip
  pip install -e . -c constraints_openpi.txt
}

# ---- 运行训练（按你的脚本实际参数改）----
python scripts/train.py `
  --config default `
  --data_root data `
  --output_dir checkpoints

Write-Host "[VLA] Reproduce script done"


运行（若首次运行脚本被拦）：

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\reproduce.ps1

🔧 README 里加一小段（可选但很加分）

在 README 的“启动训练”下面加这 6 行就行：

### 一键复现

Linux / macOS:
```bash
./reproduce.sh


Windows:

.\reproduce.ps1


---

## ✅ 最后一步（可选）
把脚本提交上去：

```bash
git add reproduce.sh reproduce.ps1
git commit -m "chore: add one-click reproduce scripts"
git push


到这一步为止，你这个仓库已经是**“开箱即跑”的工程级 VLA 训练 repo了。
如果你之后想把入口脚本/参数再精简成唯一官方入口**，我也可以 1 分钟帮你改。

你把readme给我复制一下 我可以从网页内改吗

可以的 👍，而且完全可以直接在 GitHub 网页里改。
下面我把最终版 README（可复现 + 不复杂）完整复制给你，你整段复制即可。

👉 如何在网页里改（先看这个）

打开你的仓库页面
👉 https://github.com/Jerryzhang258/VLA-training

点 README.md

右上角 ✏️ Edit

全选 → 删除 → 粘贴下面这整段

滚到最下面 → Commit changes

✅ README.md（直接复制下面全部内容）
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

4. 安装依赖（推荐方式）
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

10. 常见问题
Q1: import / ModuleNotFoundError

确认在 repo 根目录运行

确认依赖按 constraints_openpi.txt 安装

确认 sitecustomize.py 未删除

Q2: 显存不足

减小 batch size

使用较小配置

避免 full fine-tuning

Q3: 离线服务器无法联网

提前准备数据、权重、tokenizer

使用本地缓存目录，例如：

export HF_HOME=/path/to/cache
export TRANSFORMERS_CACHE=/path/to/cache

11. 最小可复现 Checklist

 Python 3.11

 GPU 可用（nvidia-smi）

 依赖按 constraints_openpi.txt 安装

 数据位于 data/

 从 repo 根目录运行

 sitecustomize.py 保留
