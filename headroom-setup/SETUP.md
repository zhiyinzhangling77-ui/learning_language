# Headroom をアカウント全体で有効化する手順

Claude Code (CLI / web / IDE) のすべてのセッションで Headroom を有効にする。
1 回だけ手元で実行すれば、以降は自動的に効く。

## 1. ローカル Claude Code CLI で有効化

```bash
bash headroom-setup/install.sh
```

これで `~/.claude.json` (または `~/.claude/settings.json`) に `headroom`
MCP サーバが登録される。登録内容は `headroom-setup/mcp-config.json` と同じ。

確認:

```bash
claude mcp list
# headroom が表示されれば OK
```

## 2. Claude Code on the web で有効化

web セッションは毎回 ephemeral コンテナで起動するので、毎回インストールが必要。
claude.ai/code の **Environment settings** を開き、**Setup script** に以下を追加:

```bash
pip install --user "headroom-ai[all]"
export HEADROOM_OUTPUT_SHAPER=1
export HEADROOM_UPDATE_CHECK=off
headroom mcp install
```

これで web で起動する全リポジトリのセッションで Headroom が立ち上がる。

## 3. 動作確認

任意のセッションで以下のツールが見えていれば成功:

- `mcp__headroom__compress`
- `mcp__headroom__retrieve`
- `mcp__headroom__stats`

## 注意

- Python 3.10+ が必要。
- 企業内 SSL インスペクション環境では、Rust を先に入れておくとビルドが安定する。
- 無効化したいときは `claude mcp remove headroom`、または setup script から
  該当行を削除する。
