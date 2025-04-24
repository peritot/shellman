# Shellman

一个强大的 shell 脚本工具集，用于自动化日常开发任务。

## 功能

- `git_all.sh`: 批量执行 git 命令
- `pnpm_all.sh`: 批量执行 pnpm 命令

## 安装

```bash
git clone https://github.com/peritotchan/shellman.git
cd shellman
```

## 使用说明

### git_all.sh

```bash
./scripts/git_all.sh <git命令> [参数...]
```

示例：
```bash
./scripts/git_all.sh status
./scripts/git_all.sh pull
```

### pnpm_all.sh

```bash
./scripts/pnpm_all.sh <pnpm命令> [参数...]
```

示例：
```bash
./scripts/pnpm_all.sh install
./scripts/pnpm_all.sh update
```

## 许可证

MIT
