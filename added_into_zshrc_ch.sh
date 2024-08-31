# -----------------------------------------------------------------------------
#
# 功能：通过 Google Gemini AI 自动生成 git 提交信息。
#
# 将此 shell 复制粘贴到你的 ~/.bashrc 或 ~/.zshrc 中以获得 `gcm` 命令。它：
# 1) 获取当前暂存的更改差异
# 2) 将它们发送到 LLM 以编写 git 提交信息
# 3) 允许你轻松接受、编辑、重新生成、取消
#
# 但是 - 只需根据你的喜好阅读和编辑代码
#
# `llm` CLI 工具非常棒，可以在这里获取： https://llm.datasette.io/en/stable/
#


# 取消已经有 gcm 这个命令命名的命令，假如有的话，避免和之前的冲突
unalias gcm 2>/dev/null

# 使用 Google Gemini 生成 Git 提交信息的 gcm 函数
gcm() {
    # 使用 Google Gemini 模型生成 Git 提交信息的 gcm 函数
    generate_commit_message() {
        llm -m gemini-1.5-flash-latest <<EOF
您需要根据以下规则生成 git 提交的信息：
1. 好的 git 提交信息示例：
- 功能：向 generate_commit_message 函数添加类型注释
- 修复：修复 generate_commit_message 功能中的 bug
- 文档： 更新 README.md
- 初始化： 第一次提交
- 格式化： 使用黑色格式化代码
- 重构：重构 generate_commit_message 函数
- 持续集成：为 Python 包发布添加 GitHub Actions 工作流程
- 编译构建：更新 setup.py 并添加 tests 文件夹
2. 请将自动生成的 git 提交信息重构优化成一行信息进行显示
3. 将自动生成的信息结果，翻译成中文，并且只显示中文翻译就可以
4. 自动生成提交消息应基于以下差异的内容进行：
\`\`\`
$(git diff --cached --staged)
\`\`\`
EOF
    }

    # 兼容 Bash 和 Zsh 的用户输入读取函数
    read_input() {
        if [ -n "$ZSH_VERSION" ]; then
            printf '%s' "$1"
            read -r REPLY
        else
            read -p "$1" -r REPLY
        fi
    }

    # 主脚本
    printf '使用 Google Gemini AI 自动生成 Git 的提交消息......'
    printf '\nAI 生成的内容是基于以下的差异化信息：\n\n %s\n\n' "$(git diff --cached --staged)"
    commit_message=$(generate_commit_message)

    while true; do
        printf "\n推荐的提交信息如下：\n"
        printf '%s\n' "$commit_message"

        read_input "你想要 (a)ccept/使用这个提交信息, (e)dit/自己手写, (r)egenerate/重新生成, or (c)ancel/退出? "
        choice=$REPLY

        case "$choice" in
            a|A )
                if git commit -m "$commit_message"; then
                    printf "Commit 成功，已提交 AI 自动生成信息。\n"
                    return 0
                else
                    printf "Commit 失败，请检查你的修改并再次尝试。\n"
                    return 1
                fi
                ;;
            e|E )
                read_input "输入你的提交信息："
                commit_message=$REPLY
                if [ -n "$commit_message" ] && git commit -m "$commit_message"; then
                    printf "Commit 成功，已提交您自己手写的信息。\n"
                    return 0
                else
                    printf "Commit 失败，请检查你的修改并再次尝试。\n"
                    return 1
                fi
                ;;
            r|R )
                printf "再次使用 Google Gemini AI 自动生成 Git 的提交消息......\n"
                printf  '\n\tAI 生成的内容是基于以下的差异化信息：\n\n%s\n\n' "$(git diff --cached --staged)"
                commit_message=$(generate_commit_message)
                ;;
            c|C )
                printf "取消提交，退出。\n"
                return 1
                ;;
            * )
                printf "错误的选项. 请重新输入。\n"
                ;;
        esac
    done
}
