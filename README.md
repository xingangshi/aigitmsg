# AI Generate Git Message

Automatically generate git commit messages using Google Gemini AI.

## 1. Base Installer

### 1.1 Generate Your Gemini Key

Visit [Google AI Gemini](https://aistudio.google.com/app/apikey) to obtain your API key.

### 1.2 Install the Gemini Plugin

```bash
pip install llm
llm install llm-gemini
```

### 1.3 Set Up Your Google Gemini Key

```bash
export GEMINI_API_KEY=your_google_gemini_key
```

## 2. Add Self `gcm` Command

### 2.1 Configure `gcm` in Your Shell

Add the `gcm` command from [added_into_zshrc.sh](/added_into_zshrc.sh) to your shell configuration file:

Copy the contents of [added_into_zshrc.sh](/added_into_zshrc.sh) and paste it into your `~/.bashrc` or `~/.zshrc` to enable the `gcm` command.

**NOTICE**:

To generate commit messages in Chinese, use the Chinese version of [added_into_zshrc_ch.sh](/added_into_zshrc_ch.sh).

### 2.2 Use `gcm` to Generate Git Commit Messages

1. Navigate to your git repository.
2. Make some changes in your repository.
3. Use the `gcm` command to automatically generate a commit message.
