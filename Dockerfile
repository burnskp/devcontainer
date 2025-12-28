# checkov:skip=CKV_DOCKER_2: This container doesn't need healthchecks
# hadolint global ignore=DL3008,DL3015,DL3059,DL4006
FROM ubuntu:25.10

ARG TARGETARCH

ENV BUN_INSTALL="/usr/local"
ENV DEBIAN_FRONTEND=noninteractive
ENV GOARCH=${TARGETARCH}
ENV GOOS=linux
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV NONINTERACTIVE=1

RUN apt-get update && apt-get install -y --no-install-recommends \
  locales software-properties-common \
  && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && dpkg-reconfigure locales \
  && update-locale LANG=en_US.UTF-8 \
  && apt-get full-upgrade -y \
  && apt-get install -y --no-install-recommends \
  build-essential \
  curl \
  git \
  procps \
  sudo \
  zsh \
  && echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu \
  && su ubuntu -c 'bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"' \
  && rm /etc/sudoers.d/ubuntu \
  && SUDO_FORCE_REMOVE=yes apt-get purge -y sudo \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc/* /usr/share/man/* \
  && if [ "$TARGETARCH" = "amd64" ]; then \
  export NVIM=nvim-linux-x86_64; \
  else \
  export NVIM="nvim-linux-${TARGETARCH}"; \
  fi \
  && curl -L https://github.com/neovim/neovim/releases/download/nightly/$NVIM.tar.gz -o nvim.tgz \
  && tar -xf /nvim.tgz --strip-components=1 -C /usr/local \
  && rm /nvim.tgz

COPY files /
RUN chown -R ubuntu:ubuntu /home/ubuntu \
  && chsh -s /bin/zsh ubuntu

USER ubuntu
WORKDIR /home/ubuntu
ENV ZDOTDIR="/home/ubuntu/.config/zsh"

RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" \
  && brew install \
  bat \
  cbfmt \
  fd \
  git-delta \
  glow \
  gnupg \
  go \
  golangci-lint \
  gopls \
  jq \
  lazygit \
  lua-language-server \
  markdownlint-cli2 \
  node \
  opencode \
  pre-commit \
  ripgrep \
  ruff \
  shellcheck \
  shfmt \
  starship \
  tree-sitter-cli \
  uv \
  wget \
  yaml-language-server \
  yq \
  && brew cleanup --prune=all \
  && npm install --no-cache -g @github/copilot-language-server \
  && npm install --no-cache -g vscode-json-languageservice

RUN mkdir -p $HOME/.config $HOME/.local/state $HOME/.local/share/nvim \
  && ln -s /data/opencode $HOME/.local/share/opencode \
  && nvim --headless -c "qall"

ENTRYPOINT ["/start.sh"]
