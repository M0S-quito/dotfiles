# M0S_quito dotfiles setting

### Bash
- bashrc : 인터렉티브 쉘 설정(터미널 열 때마다 실행)
- profile : 전체 환경(전역) 설정(로그인 시 1회)
- alias.sh : 단축어 및 관련 작업
- export.sh : 환경변수 및 관련 작업
- prompt.sh : 프롬프트 설정 및 관련 작업

### Config
##### 필수!
- git
  > .gitconfig(git 기본 설정)
  => 다른 것도 있는데 걍 이거 하나로

- nvim(외부 설치)->install.sh에서 추가 설정(lazyvim 업데이트)
  > ~/.config/nvim (필요한거만 할까 했는데 이게 차라리 낳아 보임)

- tmux
  > .tmux.conf(tmux 커스텀 설정)

##### 중요!
- btop(외부 설치)
- nethogs
- ss
- iftop

##### 선택
- noefetch
b

### ENV

##### install.sh

