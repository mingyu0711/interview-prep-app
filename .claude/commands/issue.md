# 이슈 생성

사용자의 설명을 듣고 제목만 먼저 제시한다. 확인 후 이슈와 브랜치를 생성한다.

## 실행 순서

### 1단계: 파라미터 추론

사용자 입력에서 아래를 추론한다:

**type:**

- 새 기능 → `feature`
- 버그 수정 → `fix`
- 코드 구조 개선 → `refactor`
- 설정·의존성·문서 → `chore`

**branch-suffix:** 영어 kebab-case, 핵심만 간결하게 (예: `setup-eslint-prettier`)

**제목:** 영문으로, 무엇을 하는지 명확하게 (예: `Setup ESLint and Prettier`)

### 2단계: 제목 제시 후 확인

추론한 값을 아래 형식으로 보여주고 확인을 받는다. 스크립트는 아직 실행하지 않는다:

```
type   : chore
브랜치 : chore/setup-eslint-prettier
제목   : Setup ESLint and Prettier

진행할까요? 제목 수정이 필요하면 말씀해주세요.
```

### 3단계: 이슈 + 브랜치 생성

확인을 받으면 실행한다:

```bash
AUTO_BRANCH=true ./scripts/issue.sh <type> <branch-suffix> "<제목>"
```

완료 후 이슈 번호, URL, 브랜치명을 알린다.
개발이 끝나면 `/issue-update`로 이슈 내용을 업데이트할 수 있다고 안내한다.

## 사용 예시

```
/issue 허스키+린트+프리티어 셋팅
/issue 질문 목록 화면 만들기
/issue 로그인 후 토큰 저장 안 되는 버그
```
