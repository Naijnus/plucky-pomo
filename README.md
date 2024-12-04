# Pomodoro Bash Script

A lightweight Bash script that integrates with **Plucky** to manage Pomodoro sessions directly from the terminal. The script leverages Plucky's scheduling and delay features to dynamically set and manage session delays and breaks.

## Features

- Start a new Pomodoro session with a delay and break time calculated dynamically.
- Check the status of an ongoing session, including time until the next break starts or ends.
- End an active session gracefully.
- Break conditions are customizable to fit your preferences.

## Requirements

- **Bash**: Compatible with standard Bash shells.
- **Plucky**: Install Plucky to enable the script's functionality. Visit the [Plucky Official Website](https://getplucky.net/) for installation and documentation.

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/pomodoro-bash.git
   ```

2. Move the script to your home directory:
   ```bash
   mv pomodoro-bash/pomo.sh ~/.pomo.sh
   ```

3. Add the following line to your `~/.bashrc`:
   ```bash
   if [ -f ~/.pomo.sh ]; then
       source ~/.pomo.sh
   fi
   ```

4. Reload your `.bashrc`:
   ```bash
   source ~/.bashrc
   ```

5. Ensure Plucky is installed and configured. Refer to the [Plucky Official Website](https://getplucky.net/) for installation and usage.

## Usage

### Start or Check a Session

```bash
pomo
```

- **If a session is active**:
  - Displays the time remaining until the next break starts or ends.
- **If no session is active**:
  - Starts a new session with the delay and break conditions based on Plucky's settings. By default, breaks are configured with `allow everything`.

### End a Session

```bash
pomo end
```

- Ends the current session if active.

## Customization

- **Break Conditions**:
  - By default, the script uses `allow everything` for breaks. You can modify this condition in the `pomo.sh` script to better suit your needs:
    ```bash
    pluck when now+${total_minutes}m allow your_condition
    ```

## Notes

- **Plucky Dependency**: This script relies on Plucky's `pluck delay` and `pluck export` commands. If these commands fail or produce invalid output, the script will not function as expected.
- **Dynamic Break Timing**: The session's total time is calculated as the Plucky delay plus 10 minutes.

## License

