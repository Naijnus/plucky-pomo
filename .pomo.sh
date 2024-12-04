# ~/.pomo.sh
pomo() {
    if [ "$1" = "end" ]; then
        # End Pomodoro session
        pluck_output=$(pluck export)

        # Extract the matching line that starts with '#' and contains 'when' and 'allow everything'
        matched_line=$(echo "$pluck_output" | grep -E '^#.*when.*allow everything')

        if [ -n "$matched_line" ]; then
            # Extract the part of the line starting from 'when'
            command_suffix=$(echo "$matched_line" | grep -oE 'when.*')

            # Construct the final command
            final_command="pluck - $command_suffix"

            # Execute the command silently
            eval "$final_command"
            echo "Pomodoro session ended."
        else
            echo "No active Pomodoro session found to end."
        fi
    else
        # Get the delay from 'pluck delay'
        delay_seconds=$(pluck delay)
        if [[ ! "$delay_seconds" =~ ^[0-9]+$ ]]; then
            echo "Failed to retrieve delay. Unable to start a new Pomodoro session."
            return 1
        fi

        # Convert delay to minutes
        delay_minutes=$((delay_seconds / 60))

        # Calculate the total time in minutes: delay + 10 minutes
        total_minutes=$((delay_minutes + 10))

        # Default Pomodoro behavior (start or check session)
        pluck_output=$(pluck export)

        # Check if the output contains a line starting with '#' and includes 'when' and 'allow everything'
        matched_line=$(echo "$pluck_output" | grep -E '^#.*when.*allow everything')

        if [ -n "$matched_line" ]; then
            # Extract the timestamp and check for the presence of '+'
            timestamp=$(echo "$matched_line" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}')
            contains_plus=$(echo "$matched_line" | grep -q '+' && echo "yes" || echo "no")

            if [ -n "$timestamp" ]; then
                # Convert the timestamp to seconds since epoch
                timestamp_epoch=$(date -d "$timestamp" +%s)
                current_epoch=$(date +%s)

                # Calculate the absolute time difference in minutes
                time_diff=$(( (timestamp_epoch - current_epoch) / 60 ))
                time_diff=${time_diff#-} # Ensure time_diff is always positive

                # Output based on the presence of '+'
                if [ "$contains_plus" = "yes" ]; then
                    echo "The break will start in ${time_diff}m."
                else
                    echo "The break will end in ${time_diff}m."
                fi
            else
                echo "A Pomodoro session is in progress, but the timestamp is missing."
            fi
        else
            # If no matching line is found, start a new Pomodoro session
            pluck when now+${total_minutes}m allow everything
            echo "Started a new Pomodoro session. The break will start in ${delay_minutes}m."
        fi
    fi
}

