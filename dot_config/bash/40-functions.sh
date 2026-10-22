# Small helpers.

# mkdir + cd
mkcd() { mkdir -p -- "$1" && cd -- "$1"; }

# Pomodoro: `pomo 4` (needs `timer` and `terminal-notifier`)
pomo() {
  local rounds=${1:-4} i
  for ((i = 1; i <= rounds; i++)); do
    timer 60m && terminal-notifier -title 'Work timer is up! Take a break 😊' -message "Pomodoro $i/$rounds" -sound Crystal
    timer 10m && terminal-notifier -title 'Break is over! Back to work 😬' -message "Pomodoro $i/$rounds" -sound Crystal
  done
}

export NEOVIDE_FRAME=transparent
export NEOVIDE_MULTIGRID=true
