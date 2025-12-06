# checkov:skip=CKV_DOCKER_2: This container doesn't need healthchecks
# hadolint global ignore=DL3008,DL3015,DL4006
FROM ubuntu:25.10

ARG goVersion=1.25.4
ARG nodeVersion=22
ARG TARGETARCH
ENV GOOS=linux
ENV GOARCH=${TARGETARCH}

ENV DEBIAN_FRONTEND=noninteractive
# Set the locale
RUN apt-get update && apt-get -y install locales software-properties-common \
  && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && dpkg-reconfigure locales \
  && update-locale LANG=en_US.UTF-8 \
  && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

RUN add-apt-repository universe \
  && apt-get update \
  && apt-get full-upgrade -y \
  && apt-get install -y \
  bat \
  build-essential \
  cargo \
  curl \
  eza \
  fd-find \
  fzf \
  git \
  glow \
  lazygit \
  locate \
  lua5.4 \
  nodejs \
  python3 \
  python3-pip \
  python3-venv \
  ripgrep \
  ruby \
  ruby-dev \
  sqlite3 \
  starship \
  tmux \
  w3m \
  wget \
  zoxide \
  zsh \
  && curl -fsSL "https://deb.nodesource.com/setup_${nodeVersion}.x" | bash - \
  && apt-get update && apt-get install -y nodejs \
  && rm -rf /var/lib/apt/lists/*  \
  && ln -s "$(which fdfind)" /usr/local/bin/fd \
  && ln -s "$(which batcat)" /usr/local/bin/bat

RUN if [ "$TARGETARCH" = "amd64" ]; then \
  export NVIM=nvim-linux-x86_64; \
  else \
  export NVIM="nvim-linux-${TARGETARCH}"; \
  fi \
  && curl -L https://github.com/neovim/neovim/releases/latest/download/$NVIM.tar.gz -o nvim.tgz \
  && tar xf /nvim.tgz \
  && rm /nvim.tgz \
  && mv /$NVIM /nvim \
  && curl -sLo /go.tgz https://go.dev/dl/go${goVersion}.linux-${TARGETARCH}.tar.gz \
  && tar -C /usr/local -xf /go.tgz \
  && rm /go.tgz

RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
  && mv ~/.local/bin/uv /usr/local/bin/uv

RUN uv tool install specify-cli --from git+https://github.com/github/spec-kit.git \
  && npm i -g @fission-ai/openspec@latest \
  && npm i -g @google/gemini-cli \
  && npm i -g @openai/codex \
  && npm i -g codemachine \
  && npm i -g opencode-ai \
  && npm i -g opencode-gemini-auth \
  && npm i -g openskills \
  && npm i -g tree-sitter-cli

COPY linters/cbfmt.toml /home/ubuntu/.cbfmt.toml
COPY config /home/ubuntu/.config
RUN chown -R ubuntu:ubuntu /home/ubuntu \
  && chsh -s /bin/zsh ubuntu

COPY start.sh /start.sh

USER ubuntu
WORKDIR /home/ubuntu
ENV HOME="/home/ubuntu"
ENV PATH="$PATH:/usr/local/go/bin:/nvim/bin:$HOME/go/bin:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/luals/bin:$HOME/dasht/bin"
ENV ZDOTDIR="$HOME/.config/zsh"
RUN bat cache --build

# Make Links
RUN mkdir -p $HOME/.config $HOME/.local/share $HOME/.local/state \
  && ln -s /data/bootdev.yaml $HOME/.bootdev.yaml \
  && ln -s /data/claude $HOME/.config/claude \
  && ln -s /data/codex $HOME/.local/share/codex \
  && ln -s /data/exercism $HOME/.config/exercism \
  && ln -s /data/gemini $HOME/.gemini \
  && ln -s /data/github-copilot $HOME/.config/github-copilot \
  && ln -s /data/lazygit $HOME/.local/state/lazygit \
  && ln -s /data/opencode $HOME/.local/share/opencode \
  && ln -s /data/ssh $HOME/.ssh \
  && ln -s /data/zoxide $HOME/.local/share/zoxide

# Setup Neovim
RUN mkdir -p ~/.local/share/nvim
RUN nvim --headless -c "luafile ~/.config/nvim/update.lua" -c "qall" 2>&1 \
  | tee ~/.local/share/nvim/update.log

ENTRYPOINT ["/start.sh"]
