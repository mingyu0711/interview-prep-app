# PR 생성

현재 브랜치의 작업 내용을 분석하여 GitHub PR을 자동으로 생성한다.

## 컨텍스트 수집

아래 명령들을 병렬로 실행하여 컨텍스트를 수집한다:

```bash
git branch --show-current
git log staging..HEAD --oneline
git diff staging..HEAD --stat
```

## 추론 규칙

**이슈 번호:** 브랜치명 `{type}/{number}-{suffix}` 에서 파싱. 없으면 사용자에게 질문

**베이스 브랜치:** 자동 판단 (scripts/pr.sh가 처리)

- 현재 브랜치가 `staging` → `main`
- 그 외 → `staging`

**PR 제목:** 생략 시 이슈 제목 자동 사용

**작업 내용:** git log와 diff --stat을 분석해 의미 있는 단위로 구성. 생략 시 이슈 체크리스트 자동 추출

## 실행

추론이 완료되면 아래 명령을 Bash로 실행한다:

```bash
./scripts/pr.sh [<issue-number>] ["<PR 제목>"] ["<항목1>" ...]
```

실행 전 구성한 PR 내용을 사용자에게 보여주고 확인을 받는다.
완료 후 PR URL을 알린다.

## 사용 예시

```
/pr
/pr 이슈 번호는 12야
```
