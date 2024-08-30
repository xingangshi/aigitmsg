# -----------------------------------------------------------------------------
#
# Funtion: Auto generate git commit message by Google Gemini AI.
#
# Copy paste this shell into your ~/.bashrc or ~/.zshrc to gain the `gcm` command. It:
# 1) gets the current staged changed diff
# 2) sends them to an LLM to write the git commit message
# 3) allows you to easily accept, edit, regenerate, cancel
#
# But - just read and edit the code however you like
#
# the `llm` CLI util is awesome, can get it here: https://llm.datasette.io/en/stable/
#

# Unalias gcm if it exists (to prevent conflicts)
unalias gcm 2>/dev/null

# Define the AI-powered gcm function using gemini
gcm() {
    # Function to generate commit message using the gemini model
    generate_commit_message() {
        llm -m gemini-1.5-flash-latest <<EOF
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
2. Please make the generate commit message into one line.
3. the commit message should based on the diff content is following:
\`\`\`
$(git diff --cached --staged)
\`\`\`
EOF
    }

    # Function to read user input compatibly with both Bash and Zsh
    read_input() {
        if [ -n "$ZSH_VERSION" ]; then
            printf "%s" "$1"
            read -r REPLY
        else
            read -p "$1" -r REPLY
        fi
    }

    # Main script
    printf "Generating AI-powered commit message using gemini...\n"
    printf "\nAI Commit message is based on the diff contents:\n\n%s\n\n" "$(git diff --cached --staged)"
    commit_message=$(generate_commit_message)

    while true; do
        printf "\nProposed commit message:\n\n%s\n" "$commit_message"

        read_input "Do you want to (a)ccept, (e)dit, (r)egenerate, or (c)ancel? "
        choice=$REPLY

        case "$choice" in
            a|A )
                if git commit -m "$commit_message"; then
                    printf "Changes committed successfully!\n"
                    return 0
                else
                    printf "Commit failed. Please check your changes and try again.\n"
                    return 1
                fi
                ;;
            e|E )
                read_input "Enter your commit message: "
                commit_message=$REPLY
                if [ -n "$commit_message" ] && git commit -m "$commit_message"; then
                    printf "Changes committed successfully with your message!\n"
                    return 0
                else
                    printf "Commit failed. Please check your message and try again.\n"
                    return 1
                fi
                ;;
            r|R )
                printf "Regenerating commit message using gemini...\n"
                printf "\nThe commit message is based on the diff contents:\n\n%s\n\n" "$(git diff --cached --staged)"
                commit_message=$(generate_commit_message)
                ;;
            c|C )
                printf "Commit cancelled.\n"
                return 1
                ;;
            * )
                printf "Invalid choice. Please try again.\n"
                ;;
        esac
    done
}
