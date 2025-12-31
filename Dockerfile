# checkov:skip=CKV_DOCKER_2: This container doesn't need healthchecks
# hadolint global ignore=DL3008,DL3015,DL3059,DL4006
FROM ubuntu:25.10

ARG TARGETARCH

ENV DEBIAN_FRONTEND=noninteractive
ENV GOARCH=${TARGETARCH}
ENV GOOS=linux
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV NONINTERACTIVE=1

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/
COPY --from=golangci/golangci-lint:latest /usr/bin/golangci-lint /usr/local/bin/golangci-lint
COPY --from=oven/bun:latest /usr/local/bin/bun /usr/local/bin/bun

RUN apt-get update && apt-get -y install locales software-properties-common \
  && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && dpkg-reconfigure locales \
  && update-locale LANG=en_US.UTF-8 \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc/* /usr/share/man/* 

RUN add-apt-repository -y universe \
  && add-apt-repository -y ppa:longsleep/golang-backports \
  && curl -fsSL "https://deb.nodesource.com/setup_24.x" | bash - \
  && apt-get update \
  && apt-get full-upgrade -y \
  && apt-get install -y \
  bat \
  build-essential \
  curl \
  fd-find \
  fzf \
  git \
  git-delta \
  glow \
  golang-go \
  lazygit \
  lua5.4 \
  nodejs \
  python3 \
  python3-pip \
  python3-venv \
  ripgrep \
  shellcheck \
  shfmt \
  sqlite3 \
  starship \
  unzip \
  wget \
  zsh \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc/* /usr/share/man/* \
  && chsh -s /bin/zsh ubuntu \
  && ln -s "$(which fdfind)" /usr/local/bin/fd \
  && ln -s "$(which batcat)" /usr/local/bin/bat

RUN if [ "$TARGETARCH" = "amd64" ]; then \
  export NVIM=nvim-linux-x86_64; \
  else \
  export NVIM="nvim-linux-${TARGETARCH}"; \
  fi \
  && curl -L https://github.com/neovim/neovim/releases/download/nightly/$NVIM.tar.gz -o /tmp/nvim.tgz \
  && tar -xf /tmp/nvim.tgz --strip-components=1 -C /usr/local \
  && rm /tmp/nvim.tgz

RUN curl -sLo /tmp/bat-extras.zip https://github.com/eth-p/bat-extras/releases/download/v2024.08.24/bat-extras-2024.08.24.zip \
  && unzip -d /usr/local /tmp/bat-extras.zip \
  && rm /tmp/bat-extras.zip

RUN export BUN_INSTALL="/usr/local" \
  && bun add --no-cache -g @github/copilot-language-server \
  && bun add --no-cache -g markdownlint-cli2 \
  && bun add --no-cache -g opencode-ai \
  && bun add --no-cache -g tree-sitter-cli \
  && bun add --no-cache -g vscode-json-languageservice \
  && bun add --no-cache -g yaml-language-server

RUN GOBIN=/usr/local/bin go install golang.org/x/tools/gopls@latest \
  && rm -rf /go/pkg /root/.cache/go-build

RUN UV_TOOL_BIN_DIR=/usr/local/bin uv tool install ruff \ 
  && UV_TOOL_BIN_DIR=/usr/local/bin uv tool install pre-commit 

RUN LUA_VERSION=$(curl -s https://api.github.com/repos/LuaLS/lua-language-server/releases/latest | grep -Po '"tag_name": "\K.*?(?=")') \
    && if [ "$TARGETARCH" = "amd64" ]; then \
         LUA_ARCH="linux-x64"; \
       else \
         LUA_ARCH="linux-arm64"; \
       fi \
    && curl -L https://github.com/LuaLS/lua-language-server/releases/download/${LUA_VERSION}/lua-language-server-${LUA_VERSION}-${LUA_ARCH}.tar.gz -o /tmp/lua-ls.tar.gz \
    && mkdir -p /opt/lua-language-server \
    && tar -xvf /tmp/lua-ls.tar.gz -C /opt/lua-language-server \
    && ln -s /opt/lua-language-server/bin/lua-language-server /usr/local/bin/lua-language-server \
    && rm /tmp/lua-ls.tar.gz

COPY start.sh /start.sh
COPY --chown=ubuntu:ubuntu config /home/ubuntu/.config

USER ubuntu
WORKDIR /home/ubuntu
ENV HOME="/home/ubuntu"
ENV ZDOTDIR="$HOME/.config/zsh"
RUN bat cache --build

# Make Links
RUN mkdir -p $HOME/.config $HOME/.local/share/nvim $HOME/.local/state \
  && opencode models \
  && rm -rf $HOME/.local/share/opencode \
  && ln -s /data/opencode $HOME/.local/share/opencode \
  && ln -s /data/lazygit $HOME/.local/state/lazygit \
  && ln -s /data/github-copilot $HOME/.config/github-copilot \
  && nvim --headless -c "qall" 2>&1 \
  | tee ~/.local/share/nvim/update.log

ENTRYPOINT ["/start.sh"]
