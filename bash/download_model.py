import subprocess
import sys
import argparse
import os

# 默认模型列表
# "stabilityai/sdxl-turbo",
hf_models = [
    "LinkSoul/Chinese-LLaVA-Cllama2",
    "BAAI/bge-large-zh-v1.5",
    "BAAI/bge-reranker-large",
    "sayakpaul/flux.1-dev-nf4",
    "lmms-lab/llava-onevision-qwen2-72b-ov-sft",
    "google/siglip-so400m-patch14-384"
]

ms_models = [
    "llm-research/meta-llama-3.1-8b-instruct",
    "baichuan-inc/Baichuan2-13B-Chat",
    "ZhipuAI/glm-4-9b-chat",
    "AI-ModelScope/clip-vit-large-patch14",
    "AI-ModelScope/FLUX.1-dev",
    "Blink_DL/rwkv-6-world"
]

# 创建参数解析器
parser = argparse.ArgumentParser(description="下载模型")
parser.add_argument("--from", dest="source", choices=["hf", "ms"], default="ms", help="模型来源: hf (Hugging Face) 或 ms (ModelScope)")
parser.add_argument("--mirror", default="https://pypi.tuna.tsinghua.edu.cn/simple", help="指定pip镜像URL")
parser.add_argument("models", nargs="*", help="要下载的模型列表")

args = parser.parse_args()

# 如果没有传入任何参数,显示帮助信息并退出
if len(sys.argv) == 1:
    parser.print_help()
    sys.exit(1)

# 使用用户指定的镜像URL或默认的清华镜像
mirror_url = args.mirror

# 安装必要的工具
subprocess.run(["pip", "install", "-i", mirror_url, "modelscope", "huggingface_hub"], check=True)

# 设置环境变量
os.environ["HF_ENDPOINT"] = "https://hf-mirror.com"

def download_models(source, models):
    for model in models:
        local_dir = f"./{model}"
        if source == "ms":
            download_command = f"modelscope download --model {model} --local_dir {local_dir}"
        else:  # hf
            download_command = f"huggingface-cli download {model} --local-dir {local_dir}"
        
        subprocess.run(download_command.split(), check=True)

# 如果用户没有指定模型,下载所有默认模型
if args.models[0] == "laiye":
    print("下载Hugging Face默认模型...")
    download_models("hf", hf_models)
    print("下载ModelScope默认模型...")
    download_models("ms", ms_models)
else:
    # 用户指定了模型,只从指定的来源下载
    download_models(args.source, args.models)

print("所有模型下载完成。")
