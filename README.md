# AI Generate Git message
Auto generate git commit message by Google Gemini AI.

## 1. Base Installer

### 1.1 Generate your Gemini key

Open [Google AI Gemini](https://aistudio.google.com/app/apikey), and then get your keys.

### 1.2 Install the Gemini plugin

```
llm install llm-gemini
```

### 1.2 Set up your Google Gemini key

```
export GEMINI_API_KEY=your_google_gemini_key
```

## 2. Add Self `gcm` command

### 2.1 Set `gcm` code into your shell configuration.

Added [gcm file content](/added_into_zshrc.sh) into your shell configuration file:

Copy [gcm](/added_into_zshrc.sh)'s content, and paste this shell into your `~/.bashrc` or `~/.zshrc` to gain the `gcm` command.

**NOTICE**:

If you want to generate a Chinese commit massage, Please use Chinese version file of [add_into_zshrc_ch.sh](/added_into_zshr_ch.sh).

### 2.2 Use `gcm` to generate git commit message

1. Change directory into your git repo.
2. Make Some changes on your repo.
3. use `gcm` command to auto generate commit message.

