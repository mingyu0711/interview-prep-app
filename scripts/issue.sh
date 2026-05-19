#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# issue.sh — GitHub 이슈 생성 + staging 기준 브랜치 자동화
#
# 사용법:
#   ./scripts/issue.sh <type> <branch-suffix> "<제목>"
#
# 예시:
#   ./scripts/issue.sh chore setup-husky-eslint-prettier "Setup Husky, ESLint, and Prettier"
#
# type: feature | fix | refactor | chore
# ──────────────────────────────────────────────────────────────
set -euo pipefail

TYPE="${1:-}"
BRANCH_SUFFIX="${2:-}"
TITLE="${3:-}"

if [[ -z "$TYPE" || -z "$BRANCH_SUFFIX" || -z "$TITLE" ]]; then
  echo "사용법: $0 <type> <branch-suffix> \"<제목>\""
  echo "type: feature | fix | refactor | chore"
  exit 1
fi

case "$TYPE" in
  feature|fix|refactor|chore) ;;
  *)
    echo "알 수 없는 type: $TYPE"
    echo "type: feature | fix | refactor | chore"
    exit 1
    ;;
esac

# ── 이슈 본문 (초기 추상적 상태) ──────────────────────────────
BODY="## 개요
${TITLE}

## 개발 내용
_개발 후 업데이트 예정_

## 검증 방법
_개발 후 업데이트 예정_"

# ── 이슈 생성 ──────────────────────────────────────────────────
echo "이슈 생성 중..."
ISSUE_URL=$(gh issue create \
  --title "[${TYPE}] ${TITLE}" \
  --body "$BODY" \
  --label "$TYPE" \
  --assignee "@me")

ISSUE_NUMBER=$(echo "$ISSUE_URL" | grep -o '[0-9]*$')
BRANCH_NAME="${TYPE}/${ISSUE_NUMBER}-${BRANCH_SUFFIX}"

echo ""
echo "이슈 #${ISSUE_NUMBER} 생성 완료"
echo "URL    : ${ISSUE_URL}"
echo "브랜치 : ${BRANCH_NAME}"

# ── 브랜치 생성 (staging 기준) ─────────────────────────────────
AUTO_BRANCH="${AUTO_BRANCH:-}"

create_branch() {
  git fetch origin staging
  git checkout staging
  git pull origin staging
  git checkout -b "$BRANCH_NAME"
  echo "브랜치 생성 완료: ${BRANCH_NAME}"
}

if [[ "$AUTO_BRANCH" == "true" ]]; then
  create_branch
elif [[ "$AUTO_BRANCH" != "false" ]]; then
  echo ""
  read -rp "staging 기준으로 '${BRANCH_NAME}' 브랜치를 생성할까요? [Y/n] " CONFIRM
  CONFIRM="${CONFIRM:-Y}"
  if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
    create_branch
  fi
fi
