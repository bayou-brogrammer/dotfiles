def "nu-complete ps" [] {
    ps -l | each {|x| { value: $"($x.pid)", description: $x.command } }
}

# after <pid> {|| do something ... }
export def after [
    pid: string@"nu-complete ps"
    action
] {
    do -i { tail --pid $pid -f /dev/null }
    do $action
}
