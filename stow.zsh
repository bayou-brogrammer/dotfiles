local program=$1
local path=$2

# Check if path is empty
if [ -z "$path" ]; then
    path="$HOME/.config/$program"
else
    path="$path/$program"
fi