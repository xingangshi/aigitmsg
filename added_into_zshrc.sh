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
You need to generate a git commit message based on the following rules:
1. Good git messages examples
- feat: Add type annotation to generate_commit_message function
- fix: Fix bug in generate_commit_message function
- docs: Update README.md
- feat: first commit
- style: Format code using black
- refactor: Refactor generate_commit_message function
- ci: Add GitHub Actions workflow for Python package release
- build: Update setup.py and add tests folder
2. Please make the generate commit message into oneline.
3. the commit message should  based on the diff content is following:
\n
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
    echo "Generating AI-powered commit message using gemini..."
    echo -e "\nAI Commit message is Base on the diff contents:\n\n`git diff --cached --staged`\n\n"
    commit_message=$(generate_commit_message)

    while true; do
        echo -e "\nProposed commit message:\n"
        echo "$commit_message"

        read_input "Do you want to (a)ccept, (e)dit, (r)egenerate, or (c)ancel? "
        choice=$REPLY

        case "$choice" in
            a|A )
                if git commit -m "$commit_message"; then
                    echo "Changes committed successfully!"
                    return 0
                else
                    echo "Commit failed. Please check your changes and try again."
                    return 1
                fi
                ;;
            e|E )
                read_input "Enter your commit message: "
                commit_message=$REPLY
                if [ -n "$commit_message" ] && git commit -m "$commit_message"; then
                    echo "Changes committed successfully with your message!"
                    return 0
                else
                    echo "Commit failed. Please check your message and try again."
                    return 1
                fi
                ;;
            r|R )
                echo "Regenerating commit message using gemini..."
                echo -e "\nThe commit message is Base on the diff contents:\n\n`git diff --cached --staged`\n\n"
                commit_message=$(generate_commit_message)
                ;;
            c|C )
                echo "Commit cancelled."
                return 1
                ;;
            * )
                echo "Invalid choice. Please try again."
                ;;
        esac
    done
}
