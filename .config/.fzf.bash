# Setup fzf
# ---------
if [[ ! "$PATH" == */home/arnaud/code/system/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/arnaud/code/system/fzf/bin"
fi

# Auto-completion
# ---------------
# [[ $- == *i* ]] && source "/home/arnaud/code/system/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/arnaud/code/system/fzf/shell/key-bindings.bash"
