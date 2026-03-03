bindkey -e
bindkey "\e[1~" beginning-of-line    # Home
bindkey "\e[4~" end-of-line          # End
bindkey "\e[5~" beginning-of-history # PageUp
bindkey "\e[6~" end-of-history       # PageDown
bindkey "\e[2~" quoted-insert        # Ins
bindkey "\e[3~" delete-char          # Del
bindkey "\e[Z" reverse-menu-complete # Shift+n
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
