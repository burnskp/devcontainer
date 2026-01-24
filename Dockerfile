# checkov:skip=CKV_DOCKER_2: This container doesn't need healthchecks
# hadolint global ignore=DL3008,DL3015,DL3059,DL4006
FROM ubuntu:25.10

ARG TARGETARCH
ARG AI_AGENT

ENV DEBIAN_FRONTEND=noninteractive
ENV GOARCH=${TARGETARCH}
ENV GOOS=linux
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV NONINTERACTIVE=1

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/
COPY --from=ghcr.io/terraform-linters/tflint /usr/local/bin/tflint /usr/local/bin/tflint
COPY --from=golangci/golangci-lint:latest /usr/bin/golangci-lint /usr/local/bin/golangci-lint
COPY --from=johnnymorganz/stylua:latest /stylua /usr/bin/stylua
COPY --from=oven/bun:latest /usr/local/bin/bun /usr/local/bin/bun
COPY --from=rust:latest /usr/local/cargo/bin/ /usr/local/bin/

RUN apt-get update && apt-get -y install curl locales software-properties-common \
  && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && dpkg-reconfigure locales \
  && update-locale LANG=en_US.UTF-8 \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm /etc/localtime \
  && ln -s /usr/share/zoneinfo/America/Chicago /etc/localtime \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc/* /usr/share/man/*

RUN add-apt-repository -y universe \
  && add-apt-repository -y ppa:longsleep/golang-backports \
  && curl -fsSL "https://deb.nodesource.com/setup_24.x" | bash - \
  && curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com noble main" > /etc/apt/sources.list.d/hashicorp.list \
  && apt-get update \
  && apt-get full-upgrade -y \
  && apt-get install -y \
  bat \
  build-essential \
  eza \
  fd-find \
  fuse-overlayfs \
  fzf \
  git \
  git-delta \
  glow \
  golang-go \
  lazygit \
  libicu76 \
  lua5.4 \
  nodejs \
  packer \
  podman \
  podman-docker\
  python3 \
  python3-pip \
  python3-venv \
  ruby \
  ruby-dev \
  ripgrep \
  shellcheck \
  shfmt \
  sqlite3 \
  starship \
  terraform \
  terraform-ls \
  tmux \
  uidmap \
  unzip \
  wget \
  zsh \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc/* /usr/share/man/* \
  && chsh -s /bin/zsh ubuntu \
  && ln -s "$(which fdfind)" /usr/local/bin/fd \
  && ln -s "$(which batcat)" /usr/local/bin/bat \
  && echo "root:1:65535\nubuntu:100000:65535" > /etc/subuid \
  && echo "root:1:65535\nubuntu:100000:65535" > /etc/subgid

RUN if [ "$TARGETARCH" = "amd64" ]; then \
  export NVIM=nvim-linux-x86_64; \
  else \
  export NVIM="nvim-linux-${TARGETARCH}"; \
  fi \
  && curl -L https://github.com/neovim/neovim/releases/download/nightly/$NVIM.tar.gz -o /tmp/nvim.tgz \
  && tar -xf /tmp/nvim.tgz --strip-components=1 -C /usr/local \
  && rm /tmp/nvim.tgz

RUN BAT_EXTRAS_VERSION=$(curl -s https://api.github.com/repos/eth-p/bat-extras/releases/latest | grep -Po '"tag_name": "\K.*?(?=")') \
  && curl -sLo /tmp/bat-extras.zip "https://github.com/eth-p/bat-extras/releases/download/${BAT_EXTRAS_VERSION}/bat-extras-${BAT_EXTRAS_VERSION#v}.zip" \
  && unzip -d /usr/local /tmp/bat-extras.zip \
  && rm /tmp/bat-extras.zip

RUN --mount=type=cache,target=/root/.bun/install/cache \
  export BUN_INSTALL="/usr/local" \
  && bun add -g @actions/languageserver \
  && bun add -g @anthropic-ai/claude-code \
  && bun add -g @biomejs/biome \
  && bun add -g @github/copilot \
  && bun add -g @github/copilot-language-server \
  && bun add -g markdownlint-cli2 \
  && bun add -g opencode-ai \
  && bun add -g pyright \
  && bun add -g snyk \
  && bun add -g tree-sitter-cli \
  && bun add -g vscode-json-languageservice \
  && bun add -g yaml-language-server

RUN --mount=type=cache,target=/root/.cache/go-build \
  --mount=type=cache,target=/go/pkg \
  export GOBIN=/usr/local/bin \
  && go install github.com/docker/docker-language-server/cmd/docker-language-server@latest \
  && go install github.com/nametake/golangci-lint-langserver@latest \
  && go install github.com/skipants/update-action-pins@latest \
  && go install github.com/suzuki-shunsuke/pinact/v3/cmd/pinact@latest \
  && go install golang.org/x/tools/gopls@latest

RUN export UV_TOOL_BIN_DIR=/usr/local/bin \
  && export UV_TOOL_DIR=/opt/uv \
  && uv tool install ruff \
  && uv tool install pre-commit

RUN LUA_VERSION=$(curl -s https://api.github.com/repos/LuaLS/lua-language-server/releases/latest | grep -Po '"tag_name": "\K.*?(?=")') \
    && if [ "$TARGETARCH" = "amd64" ]; then \
         LUA_ARCH="linux-x64"; \
       else \
         LUA_ARCH="linux-arm64"; \
       fi \
    && curl -L https://github.com/LuaLS/lua-language-server/releases/download/${LUA_VERSION}/lua-language-server-${LUA_VERSION}-${LUA_ARCH}.tar.gz -o /tmp/lua-ls.tar.gz \
    && mkdir -p /opt/lua-language-server \
    && tar -xvf /tmp/lua-ls.tar.gz -C /opt/lua-language-server \
    && echo '#!/bin/bash\nexec "/opt/lua-language-server/bin/lua-language-server" "$@"' > /usr/local/bin/lua-language-server \
    && chmod +x /usr/local/bin/lua-language-server \
    && rm /tmp/lua-ls.tar.gz

RUN if [ "$TARGETARCH" = "amd64" ]; then \
         MARKSMAN_ARCH="linux-x64"; \
       else \
         MARKSMAN_ARCH="linux-arm64"; \
       fi \
    && curl -Lo /usr/local/bin/marksman https://github.com/artempyanykh/marksman/releases/latest/download/marksman-${MARKSMAN_ARCH} \
    && chmod +x /usr/local/bin/marksman

COPY start.sh /start.sh
COPY --chown=ubuntu:ubuntu config /home/ubuntu/.config
COPY --chown=ubuntu:ubuntu local /home/ubuntu/.local
COPY --chown=ubuntu:ubuntu known_hosts /home/ubuntu/.ssh/known_hosts
COPY xterm-ghostty.terminfo /tmp
RUN tic -x /tmp/xterm-ghostty.terminfo && rm /tmp/xterm-ghostty.terminfo


USER ubuntu
WORKDIR /home/ubuntu
ENV HOME="/home/ubuntu"
ENV ZDOTDIR="$HOME/.config/zsh"
RUN bat cache --build

RUN rustup default stable \
  && rustup component add rust-analyzer

RUN mkdir -p ~/.local/share/tmux/plugins \
   && git clone https://github.com/tmux-plugins/tpm ~/.local/share/tmux/plugins/tpm \
   && ~/.local/share/tmux/plugins/tpm/bin/install_plugins

# Make Links
RUN mkdir -p $HOME/.local/share/nvim $HOME/.local/state \
  && opencode models \
  && rm -rf $HOME/.local/share/opencode \
  && ln -s /data/claude $HOME/.config/claude \
  && ln -s /data/configstore $HOME/.config/configstore \
  && ln -s /data/copilot $HOME/.config/.copilot \
  && ln -s /data/github-copilot $HOME/.config/github-copilot \
  && ln -s /data/lazygit $HOME/.local/state/lazygit \
  && ln -s /data/opencode $HOME/.local/share/opencode \
  && nvim --headless -c "lua require('blink.cmp.fuzzy.download').ensure_downloaded(function(err) if err then print(err) end end)" -c "qall" 2>&1 \
  | tee ~/.local/share/nvim/update.log

RUN --mount=type=cache,target=/home/ubuntu/.cargo/registry,uid=1000,gid=1000 \
  cd ~/.local/share/nvim/site/pack/core/opt/blink.cmp \
  && cargo build --release \
  && cd ~/.local/share/nvim/site/pack/core/opt/avante.nvim \
  && make

ENTRYPOINT ["/start.sh"]
