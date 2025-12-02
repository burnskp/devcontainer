# checkov:skip=CKV_DOCKER_2: This container doesn't need healthchecks
# hadolint global ignore=DL3008,DL3015,DL4006
FROM ubuntu:25.04

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
  atuin \
  bat \
  build-essential \
  cargo \
  curl \
  eza \
  fd-find \
  fzf \
  git \
  glow \
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
  && ln -s "$(which fdfind)" /usr/local/bin/fd

RUN curl -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${TARGETARCH}.tar.gz -o nvim.tgz \
 && mkdir /neovim \
 && tar xf /nvim.tgz \
 && rm /nvim.tgz \
 && mv /nvim-linux-${TARGETARCH} /nvim \
 && curl -sLo /go.tgz https://go.dev/dl/go${goVersion}.linux-${TARGETARCH}.tar.gz \
 && tar -C /usr/local -xf /go.tgz \
 && rm /go.tgz

RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
 && mv ~/.local/bin/uv /usr/local/bin/uv

RUN npm i -g @openai/codex \
 && npm i -g opencode-ai \
 && npm i -g @google/gemini-cli \
 && npm i -g @fission-ai/openspec@latest \
 && npm i -g codemachine \
 && npm i -g tree-sitter-cli \
 && uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

# User Setup
RUN groupadd neovim && useradd -g neovim -ms /bin/bash neovim \
  && mkdir -p /home/neovim/.config/nvim

COPY linters/cbfmt.toml /home/neovim/.cbfmt.toml
COPY config /home/neovim/.config
RUN chown -R neovim:neovim /home/neovim

USER neovim
WORKDIR /home/neovim
ENV HOME="/home/neovim"
ENV PATH="$PATH:/usr/local/go/bin:/nvim/bin:$HOME/go/bin:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/luals/bin:$HOME/dasht/bin"
ENV ZDOTDIR="$HOME/.config/zsh"

# Make Links
RUN mkdir -p $HOME/.config $HOME/.local/share \
 && ln -s /data/github-copilot $HOME/.config/github-copilot \
 && ln -s /data/claude $HOME/.config/claude \
 && ln -s /data/exercism $HOME/.config/exercism \
 && ln -s /data/bootdev.yaml $HOME/.bootdev.yaml \
 && ln -s /data/codex $HOME/.local/share/codex \
 && ln -s /data/opencode $HOME/.local/share/opencode \
 && ln -s /data/atuin $HOME/.local/share/atuin \
 && ln -s /data/zoxide $HOME/.local/share/zoxide

# Setup Neovim
USER neovim
RUN mkdir -p ~/.local/share/nvim
RUN nvim --headless -c "luafile ~/.config/nvim/update.lua" -c "qall" 2>&1 \
  | tee ~/.local/share/nvim/update.log

ENTRYPOINT ["nvim"]
