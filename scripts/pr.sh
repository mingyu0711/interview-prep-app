#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# pr.sh — GitHub PR 생성 자동화
#
# 사용법:
#   ./scripts/pr.sh [issue-number] ["<PR 제목>"] ["<항목1>" ...]
#
# 이슈 번호 생략 시 브랜치명(feature/12-xxx)에서 자동 파싱
# 베이스 브랜치 자동 판단: staging → main, 그 외 → staging
#
# 예시:
#   ./scripts/pr.sh                         # 전부 자동
#   ./scripts/pr.sh 12                      # 이슈 번호만 지정
#   ./scripts/pr.sh 12 "질문 목록 화면 구현"
# ──────────────────────────────────────────────────────────────
set -euo pipefail

CURRENT_BRANCH=$(git branch --show-current)

# ── 베이스 브랜치 자동 판단 ────────────────────────────────────
if [[ "$CURRENT_BRANCH" == "staging" ]]; then
  BASE_BRANCH="main"
else
  BASE_BRANCH="staging"
fi

# ── 이슈 번호: 인자 > 브랜치명 파싱 ───────────────────────────
if [[ "${1:-}" =~ ^[0-9]+$ ]]; then
  ISSUE_NUMBER="$1"
  shift 1
else
  ISSUE_NUMBER=$(echo "$CURRENT_BRANCH" | grep -oE '/[0-9]+' | grep -oE '[0-9]+' | head -1 || true)
fi

if [[ -z "${ISSUE_NUMBER:-}" ]]; then
  echo "이슈 번호를 찾을 수 없습니다. 첫 번째 인자로 전달해주세요."
  exit 1
fi

PR_TITLE_SUFFIX="${1:-}"
shift 1 2>/dev/null || true
ITEMS=("$@")

# ── 이슈 정보 조회 ─────────────────────────────────────────────
echo "이슈 #${ISSUE_NUMBER} 조회 중..."
ISSUE_TITLE=$(gh issue view "$ISSUE_NUMBER" --json title --jq '.title')
ISSUE_LABELS=$(gh issue view "$ISSUE_NUMBER" --json labels --jq '[.labels[].name] | join(",")')

# PR 제목: 인자 없으면 이슈 제목 그대로 사용
if [[ -z "$PR_TITLE_SUFFIX" ]]; then
  PR_TITLE_SUFFIX="$ISSUE_TITLE"
fi

# 작업 내용: 인자 없으면 이슈 체크리스트 항목 추출
if [[ ${#ITEMS[@]} -eq 0 ]]; then
  while IFS= read -r line; do
    [[ -n "$line" ]] && ITEMS+=("$line")
  done < <(gh issue view "$ISSUE_NUMBER" --json body --jq '.body' | grep '^\- \[' | sed 's/- \[.\] //' || true)
fi

# ── PR 본문 생성 ───────────────────────────────────────────────
PR_TITLE="[#${ISSUE_NUMBER}] ${PR_TITLE_SUFFIX}"

BODY="## 연관 이슈

Closes #${ISSUE_NUMBER}

## 작업 내용"

if [[ ${#ITEMS[@]} -gt 0 ]]; then
  for ITEM in "${ITEMS[@]}"; do
    BODY+="
- ${ITEM}"
  done
else
  BODY+="
- "
fi

# ── PR 생성 ────────────────────────────────────────────────────
echo "PR 생성 중... (${CURRENT_BRANCH} → ${BASE_BRANCH})"

PR_ARGS=(--base "$BASE_BRANCH" --title "$PR_TITLE" --body "$BODY")
[[ -n "$ISSUE_LABELS" ]] && PR_ARGS+=(--label "$ISSUE_LABELS")

PR_URL=$(gh pr create "${PR_ARGS[@]}")

echo ""
echo "PR 생성 완료"
echo "URL : ${PR_URL}"
