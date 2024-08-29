# aigitmsg
Auto generate git commit message by Google Gemini AI.

## 1. Generate your Gemini key

Open [google ai gemini](https://aistudio.google.com/app/apikey), to get your keys.

## 2. Install the Gemini plugin

```
llm install llm-gemini
```

## 3. Add Self `gcm` command

### 3.1 Set `gcm` into `.zshrc` file.

Added [gcm file content](/added_into_zshrc.sh) into your `.zshrc` file.

### 3.2 Set up your key

```
export GEMINI_API_KEY=your_google_gemini_key
```

## 4. Use `gcm` to generate git commit message

1. Change directory into your git repo.
2. Make Some changes on your repo.
3. use `gcm` command to auto generate commit message.
