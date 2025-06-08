#!/usr/bin/env python3
import json
import os

# Paths to battery info — change if your battery name is different
BATTERY_PATH = "/sys/class/power_supply/BAT0"

# Icons (can be Unicode or Nerd Font icons)
# Example: charging, full, high, medium, low, critical
icons = {
    "charging": "",  # plug icon
    "full": "",      # full battery
    "high": "",      # 75%
    "medium": "",    # 50%
    "low": "",       # 25%
    "critical": ""   # 10%
}

def read_file(path):
    try:
        with open(path, "r") as f:
            return f.read().strip()
    except Exception:
        return None

def get_battery_status():
    status = read_file(os.path.join(BATTERY_PATH, "status"))
    capacity_str = read_file(os.path.join(BATTERY_PATH, "capacity"))
    if status is None or capacity_str is None:
        return None, None
    try:
        capacity = int(capacity_str)
    except ValueError:
        capacity = None
    return status, capacity


def choose_icon(status, capacity):
    if status == "Charging":
        return icons["charging"]
    if capacity is None:
        return ""  # unknown icon (battery missing)
    if capacity >= 90:
        return icons["full"]
    elif capacity >= 65:
        return icons["high"]
    elif capacity >= 40:
        return icons["medium"]
    elif capacity >= 15:
        return icons["low"]
    else:
        return icons["critical"]

def main():
    status, capacity = get_battery_status()
    if status is None or capacity is None:
        text = "Battery N/A"
    else:
        icon = choose_icon(status, capacity)
        text = f"{icon} {capacity}%"

    output = {
        "text": text,
        "tooltip": f"Battery status: {status}, {capacity}%" if status and capacity is not None else "Battery status unknown",
        "class": "battery"
    }
    print (json.dumps(output))

if __name__ == "__main__":
    main()
