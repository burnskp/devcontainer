# checkov:skip=CKV_DOCKER_2: This container doesn't need healthchecks
# hadolint global ignore=DL3008,DL3015,DL3059,DL4006
FROM ubuntu:25.10

ARG goVersion=1.25.4
ARG nodeVersion=22
ARG TARGETARCH

ENV BUN_INSTALL="/usr/local"
ENV DEBIAN_FRONTEND=noninteractive
ENV GOARCH=${TARGETARCH}
ENV GOOS=linux
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

RUN apt-get update && apt-get -y install locales software-properties-common \
  && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && dpkg-reconfigure locales \
  && update-locale LANG=en_US.UTF-8 \
  && add-apt-repository universe \
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
  git-delta \
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
  wget \
  zoxide \
  zsh \
  && curl -fsSL "https://deb.nodesource.com/setup_${nodeVersion}.x" | bash - \
  && apt-get update && apt-get install -y nodejs \
  && rm -rf /var/lib/apt/lists/*  \
  && ln -s "$(which fdfind)" /usr/local/bin/fd \
  && ln -s "$(which batcat)" /usr/local/bin/bat \
  && if [ "$TARGETARCH" = "amd64" ]; then \
  export NVIM=nvim-linux-x86_64; \
  export BUN=bun-linux-x64; \
  else \
  export NVIM="nvim-linux-${TARGETARCH}"; \
  export BUN="bun-linux-${TARGETARCH}"; \
  fi \
  && curl -L https://github.com/neovim/neovim/releases/download/nightly/$NVIM.tar.gz -o nvim.tgz \
  && tar xf /nvim.tgz \
  && rm /nvim.tgz \
  && mv /$NVIM /nvim \
  && curl -sLo /go.tgz https://go.dev/dl/go${goVersion}.linux-${TARGETARCH}.tar.gz \
  && tar -C /usr/local -xf /go.tgz \
  && rm /go.tgz \
  && curl -LsSf https://astral.sh/uv/install.sh | sh \
  && mv ~/.local/bin/uv /usr/local/bin/uv \
  && curl -sLo /tmp/bat-extras.zip https://github.com/eth-p/bat-extras/releases/download/v2024.08.24/bat-extras-2024.08.24.zip \
  && unzip -d /usr/local /tmp/bat-extras.zip \
  && rm /tmp/bat-extras.zip \
  && curl -sLo /tmp/bun.zip https://github.com/oven-sh/bun/releases/latest/download/$BUN.zip \
  && unzip /tmp/bun.zip \ 
  && mv $BUN/bun /usr/local/bin \
  && chmod +x /usr/local/bin/bun \
  && rmdir $BUN \
  && rm /tmp/bun.zip \
  && bun add -g @github/copilot-language-server \
  && bun add -g opencode-ai \
  && bun add -g tree-sitter-cli \
  && rm -rf /root /usr/local/install/cache 

COPY files /
RUN chown -R ubuntu:ubuntu /home/ubuntu \
  && chsh -s /bin/zsh ubuntu

USER ubuntu
WORKDIR /home/ubuntu
ENV HOME="/home/ubuntu"
ENV PATH="$PATH:/usr/local/go/bin:/nvim/bin:$HOME/go/bin:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.local/node/bin:$HOME/.local/bun/bin:$HOME/.bun/bin"
ENV ZDOTDIR="$HOME/.config/zsh"

RUN bat cache --build \
  && mkdir -p $HOME/.config $HOME/.local/share $HOME/.local/state \
  && ln -s /data/bootdev.yaml $HOME/.bootdev.yaml \
  && ln -s /data/copilot $HOME/.config/.copilot \
  && ln -s /data/exercism $HOME/.config/exercism \
  && ln -s /data/gemini $HOME/.gemini \
  && ln -s /data/github-copilot $HOME/.config/github-copilot \
  && ln -s /data/lazygit $HOME/.local/state/lazygit \
  && ln -s /data/opencode $HOME/.local/share/opencode \
  && ln -s /data/ssh $HOME/.ssh \
  && ln -s /data/zoxide $HOME/.local/share/zoxide \
  && mkdir -p ~/.local/share/nvim \
  && nvim --headless -c "luafile ~/.config/nvim/update.lua" -c "qall" 2>&1 \
  | tee ~/.local/share/nvim/update.log

ENTRYPOINT ["/start.sh"]
