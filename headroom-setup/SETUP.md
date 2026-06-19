# Headroom MCP セットアップ手順

[Headroom](https://github.com/chopratejas/headroom) は AI エージェント向けのコンテキスト圧縮ライブラリで、MCP サーバとして動作します。これを Claude Code のアカウント全体で有効化するための手順です。

## ローカル Claude Code CLI 用

1. このリポジトリのルートで以下を 1 回だけ実行します:

   ```bash
   bash headroom-setup/install.sh
   ```

   このスクリプトは以下を行います:
   - Python 3.10+ の確認
   - `pipx install --force "headroom-ai[all]"`（pipx がなければ `pip install --user --upgrade "headroom-ai[all]"`）
   - `headroom mcp install`（Claude Code に MCP サーバを登録）

2. 登録できたか確認:

   ```bash
   claude mcp list
   ```

   出力に `headroom` が含まれていれば OK です。

## claude.ai/code (web) 用

web 版 Claude Code は毎回新しいコンテナで起動するため、Environment settings の **Setup script** に以下を貼り付けてください。これにより、すべての web セッション起動時に Headroom が自動でインストール・登録されます。

```sh
pip install --user "headroom-ai[all]"
headroom mcp install
```

> Windows PowerShell ローカルでセットアップする場合も、web 環境を使うほうがシンプルです。ローカル PowerShell でやる場合は `python -m pip install --user "headroom-ai[all]"` → `headroom mcp install` を手動実行してください（`install.sh` は bash 用です）。

## 動作確認

Claude Code セッション内でツール一覧に以下が見えれば成功です:

- `mcp__headroom__compress`
- `mcp__headroom__retrieve`
- `mcp__headroom__stats`

## 設定ファイル参考

`headroom mcp install` で自動登録されますが、手動で追加したい場合は `headroom-setup/mcp-config.json` の内容を参考にしてください。環境変数:

- `HEADROOM_OUTPUT_SHAPER=1` — 出力シェイパーを有効化
- `HEADROOM_UPDATE_CHECK=off` — 起動時のアップデートチェックを無効化

## 無効化

```bash
claude mcp remove headroom
```
