# **Pomodoro Timer with Plucky**

A lightweight Bash script for implementing the Pomodoro technique using **Plucky**. This script supports managing Pomodoro sessions and integrates with `systemd` to provide **notification reminders** during break times.

## **Features**

- Automates Pomodoro session management using **Plucky**.
- Provides **notifications** at the start of break times.
- Fully configurable with default and custom break durations.
- Uses `systemd` timers for reliable and precise notifications.

## **About Plucky**

[Plucky](https://getplucky.net/) is a powerful **self-discipline and internet blocking tool** designed to help you stay focused by blocking distracting websites or applications.

## **Usage**

### **1. Start a Pomodoro**
Start a Pomodoro session with the default break time (10 minutes):
```bash
pomo start
```

Start a Pomodoro session with a custom break time (e.g., 15 minutes):
```bash
pomo 15m start
```

### **2. Check the status**
Check the current Pomodoro session status:
```bash
pomo
```

### **3. End a Pomodoro**
Manually cancel a running Pomodoro session:
```bash
pomo end
```

## **Notifications**

- **Break notifications** are triggered using `notify-send`, ensuring timely reminders.
- Notifications work seamlessly on **Wayland** or **X11** environments with `systemd` user services.

## **Installation**

1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/pomodoro-plucky.git
   cd pomodoro-plucky
   ```

2. Copy the scripts to your local user scripts directory:
   ```bash
   mkdir -p ~/.user_scripts
   cp pomo pomo_notify ~/.user_scripts/
   chmod +x ~/.user_scripts/pomo ~/.user_scripts/pomo_notify
   ```

3. Configure `systemd` user services:
   ```bash
   mkdir -p ~/.config/systemd/user
   cp pomo-notify.service pomo-notify.timer ~/.config/systemd/user/
   ```

   > **Important**: If you are using this script under a different username, ensure the service file references the correct script path. Replace `jian` in the service file paths (e.g., `/home/jian/.user_scripts/`) with your actual username. You can edit the file using:
   > ```bash
   > nano ~/.config/systemd/user/pomo-notify.service
   > ```

4. Reload `systemd` user configuration:
   ```bash
   systemctl --user daemon-reload
   ```

5. Test the setup:
   - Start a Pomodoro:
     ```bash
     pomo start
     ```
   - Check the timer:
     ```bash
     systemctl --user list-timers
     ```

## **Requirements**

- **Plucky**: Used to block distractions during focus time. Learn more at [https://getplucky.net/](https://getplucky.net/).
- **notify-send**: For notifications (install via `libnotify`).
- **systemd**: Required for managing timers and notifications.

## **License**

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

### **Notes**
1. Make sure the `pomo-notify.service` file points to the correct user-specific script path.
2. This project assumes you have Plucky installed and configured for focus management.

