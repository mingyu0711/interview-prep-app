# 커밋

변경사항을 분석하여 컨벤셔널 커밋 메시지를 제안하고 커밋한다.

## 실행 순서

### 1단계: 컨텍스트 수집

아래를 병렬로 실행한다:

```bash
git branch --show-current
git status
git diff
git diff --cached
```

### 2단계: 브랜치명 파싱

브랜치명 `{type}/{number}-{suffix}` 에서 추출한다:

- **type**: `chore`, `feature`, `fix`, `refactor`
- **issue-number**: 숫자 부분

파싱 실패 시 (main, staging 등) type과 번호 없이 메시지만 작성한다.

### 3단계: 커밋 메시지 제안

변경사항을 분석하여 아래 형식으로 제안한다:

```
{type}: {변경 내용 요약} (#{issue-number})
```

예시:

```
chore: setup husky, eslint, and prettier (#1)
feature: add question list screen (#12)
fix: resolve token not saved after login (#15)
```

- 영문 소문자로 작성
- 50자 이내
- 이슈 번호 없으면 `(#N)` 생략

### 4단계: 확인 후 커밋

메시지를 보여주고 확인을 받는다. 확인 후 실행한다:

```bash
git add -p  # 또는 사용자가 이미 staged했으면 스킵
git commit -m "{메시지}"
```

staged된 파일이 없으면 `git add .` 할지 먼저 묻는다.

## 사용 예시

```
/commit
```
