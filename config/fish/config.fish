if status is-interactive
    abbr -a clauded claude --dangerously-skip-permissions
    abbr -a manc man -L zh_CN
    abbr -a tls tmux ls
    abbr -a tnew tmux new
    abbr -a tat tmux at -t
    abbr -a tswitch tmux switch -t
    abbr -a n nvim
    abbr -a e exit
end
if not contains $HOME/.local/bin $PATH
    set -gx PATH $HOME/.local/bin $PATH
end

set -gx EDITOR nvim
set -gx VISUAL nvim

eval (thefuck --alias | tr '\n' ';')
