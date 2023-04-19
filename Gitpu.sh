#!/bin/bash

# 需要监控的目录
WATCH_DIR=

# GitHub 仓库信息
GITHUB_USER=
GITHUB_REPO=
GITHUB_TOKEN=

# 推送到 GitHub 的分支
BRANCH=main

# 延迟时间（秒）
DELAY=10

# 最大重试次数
MAX_RETRY=10

# 监控指定目录
while true; do
    inotifywait -e modify,create,delete,move "$WATCH_DIR" && sleep $DELAY

    # 获取当前时间并将其作为提交信息
    TIME=$(TZ='Asia/Shanghai' date +%Y-%m-%d\ %H:%M:%S)
    COMMIT_MSG="Update website at ${TIME}"

    # 执行 Git 命令推送文件到 GitHub
    cd $WATCH_DIR
    git add .
    git commit -m "$COMMIT_MSG"

    # 尝试推送
    RETRY=0
    while [ $RETRY -lt $MAX_RETRY ]; do
        PUSH_RESULT=$(git push https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${GITHUB_REPO}.git $BRANCH 2>&1)

        # 判断是否出现特定错误
        if [[ $PUSH_RESULT == *"GnuTLS recv error"* ]]; then
            echo "Error: $PUSH_RESULT. Will retry in 30 seconds."
            sleep 30
            RETRY=$((RETRY+1))
        else
            echo "Pushed successfully."
            break
        fi
    done
done
