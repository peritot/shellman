#!/bin/bash

# 设置颜色输出
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 默认目录层级为3
MAX_DEPTH=3

# 需要忽略的目录列表
IGNORE_DIRS=(
    ".git"
    "node_modules"
    "vendor"
    ".cache"
    "__pycache__"
    "dist"
    "build"
    "out"
    "venv"
    ".venv"
    "target"
    ".idea"
    ".vscode"
)

# 构建忽略目录的 find 命令参数
IGNORE_PATTERN=""
for dir in "${IGNORE_DIRS[@]}"; do
    IGNORE_PATTERN+=" -o -name $dir"
done
IGNORE_PATTERN=${IGNORE_PATTERN# -o}  # 移除开头的 -o

# 函数：解析深度参数
parse_depth_param() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -d|--depth)
                MAX_DEPTH="$2"
                shift 2
                ;;
            *)
                break
                ;;
        esac
    done
}

# 函数：搜索目录
search_directories() {
    local search_pattern="$1"
    local max_depth="$2"
    local temp_file
    temp_file=$(mktemp)
    
    # 查找目录并保存到临时文件
    find . -maxdepth "$max_depth" \( -type d -name "$search_pattern" -o -type f -name "$search_pattern" \) 2>/dev/null | while read -r dir; do
        if [[ -e "$dir" ]]; then
            dirname "$dir" >> "$temp_file"
        fi
    done
    
    # 对目录进行排序和去重，并直接输出
    if [[ -f "$temp_file" ]]; then
        sort -u "$temp_file"
        rm -f "$temp_file"
    fi
}

# 函数：显示目录列表
show_directories() {
    local -a directories=("$@")
    
    if [ ${#directories[@]} -eq 0 ]; then
        return
    fi
    
    echo -e "\n${GREEN}找到以下目录：${NC}"
    for i in "${!directories[@]}"; do
        echo -e "${GREEN}$((i+1)).${NC} ${directories[$i]}"
    done
}

# 函数：确认操作
confirm_operation() {
    local command="$1"
    echo -e "\n${YELLOW}是否要在以上目录中执行 '$command'？[Y/n]${NC} "
    read -r response
    
    if [[ "$response" =~ ^[nN] ]]; then
        echo -e "\n${YELLOW}操作已取消${NC}\n"
        exit 0
    fi
}

# 函数：执行命令
execute_command() {
    local directories=("$@")
    local command="$1"
    shift
    directories=("$@")
    
    for dir in "${directories[@]}"; do
        echo -e "\n${GREEN}正在处理目录: $dir${NC}"
        
        # 进入目录
        cd "$dir" || continue
        
        # 执行命令
        eval "$command" || echo -e "\n${RED}命令执行失败: $dir${NC}"
        
        # 返回原始目录
        cd - > /dev/null
    done
} 