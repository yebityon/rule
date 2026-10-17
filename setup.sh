#!/bin/sh
# shared/AGENTS.md を Claude Code と Codex のグローバル指示ファイルとしてシンボリックリンクする
set -eu

repo_dir=$(cd "$(dirname "$0")" && pwd)
src="$repo_dir/shared/AGENTS.md"

link() {
  dest=$1
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "skip:    $dest (作成済み)"
    return
  fi
  # 既存ファイルはバックアップせずに置き換えるため、置き換える前に確認する
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    echo "warning: $dest は既に存在します。置き換えるとバックアップは作成されず、元の内容は失われます"
    printf '置き換えますか？ [y/N]: '
    read -r answer || answer=
    case $answer in
      [yY] | [yY][eE][sS]) rm -f "$dest" ;;
      *)
        echo "skip:    $dest"
        return
        ;;
    esac
  fi
  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  echo "link:    $dest -> $src"
}

link "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/CLAUDE.md"
link "${CODEX_HOME:-$HOME/.codex}/AGENTS.md"
