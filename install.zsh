verbose=false
while [[ "$#" -gt 0 ]]
do case $1 in
    -v|--verbose) verbose=true;;
    *) echo "Unknown parameter passed: $1"
    exit 1;;
esac
shift
done

# 2> >(grep -v 'BUG in find_stowed_path? Absolute/relative mismatch' 1>&2)

function debug() { 
  [ -z "$verbose" ] && echo $1 
}

function assign(){
    local program=$1
    local path=$2
    
    # Check if path is empty
    if [ -z "$path" ]; then
        path="$HOME/.config/$program"
    else
        path="$path/$program"
    fi

    debug "Assigning $program to $path"

    local has_sudo=""
    # Create path if it doesn't exist
    if [ ! -d "$path" ]; then
      debug "Creating $path"
      
      if [ -w "$path" ]; then
        mkdir "$path"
      else
        sudo mkdir "$path" && has_sudo=true
      fi
    fi

    # Assign program to path
    if [ -w "$path" ]; then
      debug "Stowing $program to $path"
      stow $program -t "$path" || echo "Error: Stow failed to assign to $path/$program"
    else
      if [ -z "$has_sudo" ] || [ "$has_sudo" = true ]; then
        debug "Stowing $program to $path as sudo"
        sudo stow $program -t "$path" || echo "Error: Stow failed to assign to $path/$program"
      else
        echo "Error: $program not assigned to $path because you are not a sudoer."
      fi
    fi
}

##################
# Assign Programs
##################
stow bash cargo discord git images

assign alacritty
assign bpytop
assign helix
assign kitty
assign lazygit
assign nvim
assign nushell
assign wezterm
assign zellij
assign zsh

# FZF
assign fzf ~/.local/share

##################
# Fonts
##################
if [ ! -d "/usr/share/fonts" ]; then
  sudo mkdir "/usr/share/fonts" && assign fonts "/usr/share/fonts"
else
  sudo cp -r fonts/* "/usr/share/fonts"
fi