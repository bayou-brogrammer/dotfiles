# Replace some more things with better alternatives
export alias cat = bat --style header --style snip --style changes --style header

# CHANGE THIS IF PARU IS NOT THERE
export alias yay = paru

alias ll = ls -m
alias la = ls -am
alias lls = ls -aldm

def ld [] { 
  ls -am  | where type == dir
}

# Common use
export alias grubup = sudo update-grub
export alias fixpacman = sudo rm /var/lib/pacman/db.lck
export alias tarnow = tar -acf 
export alias untar = tar -zxvf 
export alias wget = wget -c 
export alias rmpkg = sudo pacman -Rdd
export alias psmem = `ps auxf | sort -nr -k 4`
export alias psmem10 = `ps auxf | sort -nr -k 4 | head -10`
export alias upd = /usr/bin/garuda-update
export alias .. = cd ..
export alias ... = cd ../..
export alias .... = cd ../../..
export alias ..... = cd ../../../..
export alias ...... = cd ../../../../..
export alias dir = dir --color= auto
export alias vdir = vdir --color= auto
export alias grep  = grep --color= auto
export alias fgrep = grep -F --color= auto
export alias egrep = grep -E --color= auto
export alias hw = hwinfo --short                          # Hardware Info

# export alias gitpkg = pacman -Q | grep -i \-git | wc -l # List amount of -git packages
export alias ip = ip -color

# # Get fastest mirrors
export alias mirror = sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist
export alias mirrord = sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist
export alias mirrors = sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist
export alias mirrora = sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist

# Help people new to Arch
export alias apt = man pacman
export alias apt-get = man pacman
export alias please = sudo
export alias tb = nc termbin.com 9999
export alias helpme = cht.sh --shell
export alias pacdiff = sudo -H DIFFPROG= meld pacdiff

# Cleanup orphaned packages
def cleanup [] { 
  sudo pacman -Rns (^pacman -Qtdq)
}

# Get the error messages from journalctl
export alias jctl = journalctl -p 3 -xb

# Recent installed packages
export alias rip = `expac --timefmt=%Y-%m-%d %T %l\t%n %v | sort | tail -200 | nl`

alias fuck = with-env {TF_ALIAS: "fuck", PYTHONIOENCODING: "utf-8"} {
    thefuck (history | last 1 | get command.0)
}