#!/bin/bash

# 设置颜色输出
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 引入公共函数
source "$(dirname "$0")/utils/directory.sh"

# 解析命令行参数
parse_depth_param "$@"
shift $((OPTIND-1))

# 收集所有剩余参数作为 git 命令
GIT_COMMAND="$*"

# 检查是否提供了 git 命令
if [ -z "$GIT_COMMAND" ]; then
    echo -e "\n${RED}错误: 请提供要执行的 git 命令${NC}"
    echo -e "用法: $0 [-d <深度>] <git命令> [参数...]"
    echo -e "示例: $0 pull"
    echo -e "      $0 -d 4 status"
    echo -e "      $0 pull --rebase\n"
    exit 1
fi

echo -e "\n${GREEN}正在搜索最多 ${MAX_DEPTH} 层目录深度的 git 仓库...${NC}"

# 显示当前目录
echo -e "${YELLOW}当前目录: $(pwd)${NC}"

# 找到所有 git 仓库
echo -e "\n${GREEN}正在搜索 .git 目录...${NC}"
REPOS=()
while IFS= read -r dir; do
    if [[ -n "$dir" ]]; then
        REPOS+=("$dir")
        echo -e "${YELLOW}找到目录: $dir${NC}"
    fi
done < <(search_directories ".git" "$MAX_DEPTH")

# 如果没有找到仓库，退出
if [ ${#REPOS[@]} -eq 0 ]; then
    echo -e "\n${YELLOW}未找到任何 git 仓库${NC}\n"
    exit 0
fi

# 显示找到的仓库列表
show_directories "${REPOS[@]}"

# 确认操作
confirm_operation "git $GIT_COMMAND"

# 执行命令
execute_command "git $GIT_COMMAND" "${REPOS[@]}"

echo -e "\n${GREEN}所有目录处理完成！${NC}\n" 
