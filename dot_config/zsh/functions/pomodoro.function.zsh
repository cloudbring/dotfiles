# I'll be doing another one for Linux, but this one will give you 
# a pop up notification and sound alert (using the built-in sounds for macOS)

# Timer
# https://github.com/caarlos0/timer
# brew install caarlos0/tap/timer

# Terminal-Notifier
# https://github.com/julienXX/terminal-notifier
# brew install terminal-notifier

# Mac setup for pomo
alias work="timer 60m && terminal-notifier -message 'Pomodoro'\
        -title 'Work Timer is up! Take a Break 😊'\
        -appIcon '~/Pictures/pumpkin.png'\
        -sound Crystal"
        
alias rest="timer 10m && terminal-notifier -message 'Pomodoro'\
        -title 'Break is over! Get back to work 😬'\
        -appIcon '~/Pictures/pumpkin.png'\
        -sound Crystal"
pomo(){
        echo "How many rounds you want to do?"
        read count;
        for i in {1..$count};
        do
                work;
                sleep 1;
                rest;
        done
}
