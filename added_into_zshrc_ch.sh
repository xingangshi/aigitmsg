# -----------------------------------------------------------------------------
#
# AI-powered Git Commit Function
#
# Copy paste this shell into your ~/.bashrc or ~/.zshrc to gain the `gcm` command. It:
# 1) gets the current staged changed diff
# 2) sends them to an LLM to write the git commit message
# 3) allows you to easily accept, edit, regenerate, cancel
#
# But - just read and edit the code however you like
#
# the `llm` CLI util is awesome, can get it here: https://llm.datasette.io/en/stable/


# Unalias gcm if it exists (to prevent conflicts)
unalias gcm 2>/dev/null

# Define the AI-powered gcm function using gemini
gcm() {
    # Function to generate commit message using the gemini model
    generate_commit_message() {
        llm -m gemini-1.5-flash-latest "
您需要根据以下规则生成 git 提交的信息：
1. 好的 git 提交信息示例
- 功能：向 generate_commit_message 函数添加类型注释
- 修复：修复 generate_commit_message 功能中的 bug
- 文档： 更新 README.md
- 初始化： 第一次提交
- 格式化： 使用黑色格式化代码
- 重构：重构 generate_commit_message 函数
- 持续集成：为 Python 包发布添加 GitHub Actions 工作流程
- 编译构建：更新 setup.py 并添加 tests 文件夹
2. 请将自动生成的 git 提交信息重构优化成一行信息进行显示
3. 自动生成提交消息应基于以下差异的内容进行：
n
\`\`\`
`git diff --cached --staged`
\`\`\`
"
    }

    # Function to read user input compatibly with both Bash and Zsh
    read_input() {
        if [ -n "$ZSH_VERSION" ]; then
            echo -n "$1"
            read -r REPLY
        else
            read -p "$1" -r REPLY
        fi
    }

    # Main script
    echo "使用 Google Gemini AI 自动生成 Git 的提交消息......"
    echo -e "\nAI 生成的内容是基于以下的差异化信息：\n\n`git diff --cached --staged`\n\n"
    commit_message=$(generate_commit_message)

    while true; do
        echo -e "\n推荐的提交信息如下：\n"
        echo "$commit_message"

        read_input "你想要 (a)ccept/使用这个提交信息, (e)dit/自己手写, (r)egenerate/重新生成, or (c)ancel/退出? "
        choice=$REPLY

        case "$choice" in
            a|A )
                if git commit -m "$commit_message"; then
                    echo "Commit 成功，已提交 AI 自动生成信息。"
                    return 0
                else
                    echo "Commit 失败，请检查你的修改并再次尝试。"
                    return 1
                fi
                ;;
            e|E )
                read_input "输入你的提交信息："
                commit_message=$REPLY
                if [ -n "$commit_message" ] && git commit -m "$commit_message"; then
                    echo "Commit 成功，已提交您自己手写的信息。"
                    return 0
                else
                    echo "Commit 失败，请检查你的修改并再次尝试。"
                    return 1
                fi
                ;;
            r|R )
                echo "再次使用 Google Gemini AI 自动生成 Git 的提交消息......"
                echo -e "\nAI 生成的内容是基于以下的差异化信息：\n\n`git diff --cached --staged`\n\n"
                commit_message=$(generate_commit_message)
                ;;
            c|C )
                echo "取消提交，退出。"
                return 1
                ;;
            * )
                echo "错误的选项. 请重新输入:w
                "
                ;;
        esac
    done
}
