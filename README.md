# AI Generate Git Message

Automatically generate git commit messages using Google Gemini AI.

## 1. Installation

### 1.1 Obtain Your Gemini API Key

Visit [Google AI Gemini](https://aistudio.google.com/app/apikey) to get your API key.

### 1.2 Install the Required Packages

Run the following commands to install the necessary packages:

```bash
pip install llm
llm install llm-gemini
```

### 1.3 Configure Your API Key

Set your API key in the environment:

```bash
export GEMINI_API_KEY=your_google_gemini_key
```

## 2. Set Up the `gcm` Command

### 2.1 Add `gcm` to Your Shell Configuration

To enable the `gcm` command, copy the contents of [added_into_zshrc.sh](/added_into_zshrc.sh) into your shell configuration file (`~/.bashrc` or `~/.zshrc`).

**Note**: For generating commit messages in Chinese, use the Chinese version of [added_into_zshrc_ch.sh](/added_into_zshrc_ch.sh).

### 2.2 Generate Git Commit Messages

1. Navigate to your git repository.
2. Make changes to your files.
3. Stage your changes with `git add`.
4. Use the `gcm` command to generate a commit message automatically.

## 3. Additional Information

For more details on usage and options, refer to the documentation in the repository.
