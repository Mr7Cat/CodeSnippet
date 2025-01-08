#!/bin/bash
## 下载所有默认模型
# ./download_model.sh laiye

# # 从Hugging Face下载指定模型
# ./download_model.sh --from hf model1 model2

# # 从ModelScope下载指定模型并使用自定义镜像
# ./download_model.sh --from ms --mirror https://your-mirror.com model1 model2
# 默认模型列表
hf_models=(
    "LinkSoul/Chinese-LLaVA-Cllama2"
    "BAAI/bge-large-zh-v1.5"
    "BAAI/bge-reranker-large"
    "sayakpaul/flux.1-dev-nf4"
    "lmms-lab/llava-onevision-qwen2-72b-ov-sft"
    "google/siglip-so400m-patch14-384"
)

ms_models=(
    "llm-research/meta-llama-3.1-8b-instruct"
    "LLM-Research/Meta-Llama-3.1-8B-Instruct-GPTQ-INT4"
    "baichuan-inc/Baichuan2-13B-Chat"
    "ZhipuAI/glm-4-9b-chat"
    "AI-ModelScope/clip-vit-large-patch14"
    "AI-ModelScope/FLUX.1-dev"
    "Blink_DL/rwkv-6-world"
    ""Qwen/Qwen2.5-7B-Instruct""
    "Qwen/Qwen2.5-14B-Instruct"
    "Qwen/Qwen2.5-Coder-32B-Instruct"
    "Qwen/Qwen2.5-72B-Instruct"
    "Qwen/Qwen2.5-72B-Instruct-GPTQ-Int4"
    "Qwen/Qwen2.5-72B-Instruct-GPTQ-Int8"
    "Qwen/Qwen2.5-72B-Instruct-AWQ"
)

ms_datasets=(
    "Mr7Cat/pubmedqa"
)

# 函数: 下载模型
download_models() {
    local source=$1
    shift
    local models=("$@")
    
    for model in "${models[@]}"; do
        local_dir="./${model}"
        if [ "$source" = "ms" ]; then
            modelscope download --model "$model" --local_dir "$local_dir"
        else
            huggingface-cli download "$model" --local-dir "$local_dir"
        fi
    done
}

# 添加新的函数: 下载数据集
download_datasets() {
    local datasets=("$@")
    
    for dataset in "${datasets[@]}"; do
        local_dir="./${dataset}"
        modelscope download --dataset "$dataset" --local_dir "$local_dir"
    done
}

# 添加新功能执行数据集下载
if [ $# -gt 0 ] && [ "$1" = "--dataset" ]; then
    shift
    download_datasets "$@"
    exit 0
fi

# 主程序
source="ms"
mirror_url="https://pypi.tuna.tsinghua.edu.cn/simple"

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --from)
            source=$2
            shift 2
            ;;
        --mirror)
            mirror_url=$2
            shift 2
            ;;
        *)
            break
            ;;
    esac
done



# 设置环境变量
export HF_ENDPOINT="https://hf-mirror.com"

show_models() {
    local source=$1
    echo "可用的模型列表:"
    
    if [ "$source" = "hf" ]; then
        for i in "${!hf_models[@]}"; do
            echo "$((i+1)). ${hf_models[$i]}"
        done
        local model_count=${#hf_models[@]}
    else
        for i in "${!ms_models[@]}"; do
            echo "$((i+1)). ${ms_models[$i]}"
        done
        local model_count=${#ms_models[@]}
    fi
    
    echo "请输入模型编号(多个模型用空格分隔,输入'all'下载所有,输入'q'退出):"
    read -r selection
    
    if [ "$selection" = "q" ]; then
        exit 0
    elif [ "$selection" = "all" ]; then
        if [ "$source" = "hf" ]; then
            download_models "hf" "${hf_models[@]}"
        else
            download_models "ms" "${ms_models[@]}"
        fi
    else
        local selected_models=()
        for num in $selection; do
            if [ "$num" -le "$model_count" ] && [ "$num" -gt 0 ]; then
                if [ "$source" = "hf" ]; then
                    selected_models+=("${hf_models[$((num-1))]}")
                else
                    selected_models+=("${ms_models[$((num-1))]}")
                fi
            else
                echo "无效的选择: $num"
            fi
        done
        if [ ${#selected_models[@]} -gt 0 ]; then
            download_models "$source" "${selected_models[@]}"
        fi
    fi
}

# 用于显示可供下载数据集的函数
show_datasets() {
    echo "可用的数据集列表:"
    for i in "${!ms_datasets[@]}"; do
        echo "$((i+1)). ${ms_datasets[$i]}"
    done
    
    echo "请输入数据集编号(多个数据集用空格分隔,输入'all'下载所有,输入'q'退出):"
    read -r dataset_selection
    
    if [ "$dataset_selection" = "q" ]; then
        exit 0
    elif [ "$dataset_selection" = "all" ]; then
        download_datasets "${ms_datasets[@]}"
    else
        local selected_datasets=()
        for num in $dataset_selection; do
            if [ "$num" -le "${#ms_datasets[@]}" ] && [ "$num" -gt 0 ]; then
                selected_datasets+=("${ms_datasets[$((num-1))]}")
            else
                echo "无效的选择: $num"
            fi
        done
        if [ ${#selected_datasets[@]} -gt 0 ]; then
            download_datasets "${selected_datasets[@]}"
        fi
    fi
}

# 修改主程序部分
pip install -i "$mirror_url" modelscope huggingface_hub
if [ $# -eq 0 ]; then
    # 如果没有参数，显示交互式菜单
    echo "请选择下载内容:"
    echo "1. 模型"
    echo "2. 数据集"
    read -r -p "请选择要下载的内容(1或2): " content_choice
    
    case $content_choice in
        1)
            echo "请选择模型来源:"
            echo "1. Hugging Face (hf)"
            echo "2. ModelScope (ms)"
            read -r -p "请输入选择(1或2): " source_choice
    
            case $source_choice in
                1) show_models "hf" ;;
                2) show_models "ms" ;;
                *) echo "无效的选择"; exit 1 ;;
            esac
            ;;
        2)
            show_datasets
            ;;
        *)
            echo "无效的选择"; exit 1 ;;
    esac
elif [ "$1" = "laiye" ]; then
    # 下载所有默认模型
    echo "下载Hugging Face默认模型..."
    download_models "hf" "${hf_models[@]}"
    echo "下载ModelScope默认模型..."
    download_models "ms" "${ms_models[@]}"
else
    # 使用命令行参数下载指定模型或数据集
    if [ "$content_choice" = "dataset" ]; then
        download_datasets "$@"
    else
        download_models "$source" "$@"
    fi
fi