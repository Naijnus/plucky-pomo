# ~/.pomo.sh

# Path to store the timer PID
TIMER_PID_FILE="/tmp/pomo_timer.pid"

pomo() {
    if [ "$1" = "end" ]; then
        # End Pomodoro session
        pluck_output=$(pluck export)
        matched_line=$(echo "$pluck_output" | grep -E '^#.*when.*allow everything')

        if [ -n "$matched_line" ]; then
            command_suffix=$(echo "$matched_line" | grep -oE 'when.*')
            eval "pluck - $command_suffix"
            echo "Pomodoro session ended."

            # Cancel the timer if it exists
            if [ -f "$TIMER_PID_FILE" ]; then
                timer_pid=$(cat "$TIMER_PID_FILE")
                if kill -0 "$timer_pid" 2>/dev/null; then
                    kill "$timer_pid"
                fi
                rm -f "$TIMER_PID_FILE"
            fi
        else
            echo "No active Pomodoro session found to end."
        fi
    else
        # Check for active session
        pluck_output=$(pluck export)
        matched_line=$(echo "$pluck_output" | grep -E '^#.*when.*allow everything')

        if [ -n "$matched_line" ]; then
            timestamp=$(echo "$matched_line" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}')
            contains_plus=$(echo "$matched_line" | grep -q '+' && echo "yes" || echo "no")

            if [ -n "$timestamp" ]; then
                timestamp_epoch=$(date -d "$timestamp" +%s)
                current_epoch=$(date +%s)
                time_diff=$(( (timestamp_epoch - current_epoch) / 60 ))
                time_diff=${time_diff#-}

                if [ "$contains_plus" = "yes" ]; then
                    echo "The break will start in ${time_diff}m."
                else
                    echo "The break will end in ${time_diff}m."
                fi
            else
                echo "A Pomodoro session is in progress, but the timestamp is missing."
            fi
        else
            delay_seconds=$(pluck delay)
            if [[ ! "$delay_seconds" =~ ^[0-9]+$ ]]; then
                echo "Failed to retrieve delay. Unable to start a new Pomodoro session."
                return 1
            fi

            delay_minutes=$((delay_seconds / 60))
            total_minutes=$((delay_minutes + 10))

            pluck when now+${total_minutes}m allow everything
            echo "Started a new Pomodoro session. The break will start in ${delay_minutes}m."

            # Start timer
            (
                sleep "$delay_seconds"
                notify-send "Pomodoro Timer" "Your break starts now!"
            ) &
            echo $! > "$TIMER_PID_FILE"
        fi
    fi
}

