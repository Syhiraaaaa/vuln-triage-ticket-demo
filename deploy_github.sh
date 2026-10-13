#!/usr/bin/env bash
# 把 demo 目录发布到 GitHub Pages。
# 用法（在 Git Bash 里）：
#   bash deploy_github.sh <你的 GitHub Token> [仓库名]
# 仓库名默认是 vuln-triage-ticket-demo
# 说明：Token 只在本次命令里用，不会写进 .git/config（用 http.extraheader 临时带鉴权）。
set -e
TOKEN="$1"
REPO="${2:-vuln-triage-ticket-demo}"
if [ -z "$TOKEN" ]; then echo "用法: bash deploy_github.sh <GitHubToken> [仓库名]"; exit 1; fi
API=https://api.github.com

USER=$(curl -s -H "Authorization: Bearer $TOKEN" "$API/user" | node -e "let d='';process.stdin.on('data',c=>d+=c).on('end',()=>{const j=JSON.parse(d);if(!j.login){console.error('取用户名失败:',j.message||d);process.exit(1);}console.log(j.login);});")
echo "GitHub 用户: $USER"

echo "创建/检查仓库 $REPO ..."
curl -s -X POST -H "Authorization: Bearer $TOKEN" -H "Accept: application/vnd.github+json" \
  "$API/user/repos" -d "{\"name\":\"$REPO\",\"public\":true,\"auto_init\":false}" \
  | node -e "let d='';process.stdin.on('data',c=>d+=c).on('end',()=>{const j=JSON.parse(d);console.log(j.full_name?('已创建 '+j.full_name):('提示: '+(j.message||'仓库可能已存在')));});"

cd "$(dirname "$0")"
AUTH=$(printf '%s' "$USER:$TOKEN" | base64 -w0)
git remote remove origin 2>/dev/null || true
git remote add origin "https://github.com/$USER/$REPO.git"
git branch -M main 2>/dev/null || true
echo "推送到 GitHub ..."
git -c http.extraheader="AUTHORIZATION: Basic $AUTH" push -u origin main

echo "开启 GitHub Pages ..."
PAGES=$(curl -s -X POST -H "Authorization: Bearer $TOKEN" -H "Accept: application/vnd.github+json" \
  "$API/repos/$USER/$REPO/pages" -d '{"source":{"branch":"main","path":"/"}}')
echo "$PAGES" | node -e "let d='';process.stdin.on('data',c=>d+=c).on('end',()=>{const j=JSON.parse(d);console.log(j.html_url?('Pages 已开启: '+j.html_url):('提示: '+(j.message||d.slice(0,200))));});"

echo ""
echo "=============================================="
echo " 访问地址: https://$USER.github.io/$REPO/"
echo "（Pages 首次发布一般 1-3 分钟生效，之后刷新即可）"
echo "=============================================="
