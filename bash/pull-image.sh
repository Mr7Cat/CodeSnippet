#!/bin/bash

# 默认拉取的镜像列表
default_images=("10.10.20.110/laiye-foundry/pretrain:20240412.07" "10.10.20.110/laiye-foundry/notebook_rapids:20240410" "10.10.20.110/laiye-foundry/laiye-llama2-7b-chat:2024.06.05" "10.10.20.110/nvidia/nemo-inference:latest" "10.10.20.110/laiye-foundry/fastapi:2024.05.08.01" "10.10.20.110/laiye/download-model:20240318" "10.10.20.110/nvidia/nemo-training:latest" "10.10.20.110/nvidia/nemo-inference:latest" "10.10.20.110/laiye-foundry/pretrain:20240412.07" "10.10.20.110/laiye-foundry/notebook_rapids:20240410" "10.10.20.110/laiye-foundry/nemo-training:notebook" "10.10.20.110/laiye-foundry/nemo-inference:notebook" "")

# 提示用户输入镜像名称，选择默认镜像或全部拉取
echo "请选择要拉取的镜像："
echo "0. 自定义镜像"
echo "a. 全部拉取" # 新增全部拉取选项
for i in "${!default_images[@]}"; do
  echo "$((i+1)). ${default_images[i]}"
done

read -p "请输入你的选择 (0, a, 1-${#default_images[@]})： " choice

# 处理用户选择
case "$choice" in
  [0])
    read -p "请输入要拉取的镜像名称： " image_name
    ;;
  a)  # 处理全部拉取选项
    for image in "${default_images[@]}"; do
      docker pull "$image"
      if [ $? -eq 0 ]; then
        echo "镜像 $image 拉取成功！"
      else
        echo "镜像 $image 拉取失败！"
      fi
    done
    exit 0 # 全部拉取完成后退出脚本
    ;;
  [1-9]|[1-9][0-9])
    if [ "$choice" -le "${#default_images[@]}" ]; then
      image_name="${default_images[choice-1]}"
    else
      echo "无效的选择！"
      exit 1
    fi
    ;;
  *)
    echo "无效的选择！"
    exit 1
    ;;
esac


# 检查镜像名称是否为空 (仅当选择自定义镜像时才需要)
if [ -z "$image_name" ]; then
  echo "镜像名称不能为空！"
  exit 1
fi

# 拉取镜像 (仅当选择自定义镜像或单个默认镜像时才需要)
docker pull "$image_name"

# 检查拉取结果 (仅当选择自定义镜像或单个默认镜像时才需要)
if [ $? -eq 0 ]; then
  echo "镜像 $image_name 拉取成功！"
else
  echo "镜像 $image_name 拉取失败！"
  exit 1
fi
